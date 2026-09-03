#!/usr/bin/env bash

set -euo pipefail

gmap_bin=${GMAP_BIN:-/src/MToolBox/bin/gmap/bin}
work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

mkdir -p "$work_dir/index"

# Generate a deterministic, non-biological reference and a 150 bp read whose
# first half is at the end of the reference and second half is at its start.
awk 'BEGIN {
    srand(25)
    bases = "ACGT"
    print ">chrM"
    for (i = 1; i <= 1000; i++) {
        printf "%s", substr(bases, int(rand() * 4) + 1, 1)
    }
    print ""
}' > "$work_dir/reference.fa"

reference=$(tail -n 1 "$work_dir/reference.fa")
read_sequence=${reference: -75}${reference:0:75}
quality=$(printf '%*s' "${#read_sequence}" '' | tr ' ' 'I')
printf '@origin-crossing\n%s\n+\n%s\n' "$read_sequence" "$quality" \
    > "$work_dir/read.fastq"

"$gmap_bin/gmap_build" \
    -D "$work_dir/index" -d circular --circular=chrM \
    -s numeric-alpha -k 15 "$work_dir/reference.fa" \
    > "$work_dir/gmap-build.log" 2>&1

"$gmap_bin/gsnap" \
    -D "$work_dir/index" -d circular -A sam --nofails -n 1 -Q -O \
    "$work_dir/read.fastq" \
    > "$work_dir/alignment.sam" 2> "$work_dir/gsnap.log"

awk 'BEGIN { FS = "\t" }
    /^@SQ/ {
        for (i = 1; i <= NF; i++) {
            if ($i ~ /^LN:/) {
                split($i, field, ":")
                reference_length = field[2]
            }
        }
        next
    }
    /^@/ { next }
    {
        records++
        if ($3 != "*") {
            aligned++
        }
        cigar = $6
        reference_span = 0
        while (match(cigar, /^[0-9]+[MIDNSHP=X]/)) {
            token = substr(cigar, RSTART, RLENGTH)
            operation = substr(token, length(token), 1)
            operation_length = substr(token, 1, length(token) - 1) + 0
            if (operation ~ /[MDN=X]/) {
                reference_span += operation_length
            }
            cigar = substr(cigar, RLENGTH + 1)
        }
        if ($3 != "*" && $4 + reference_span - 1 > reference_length) {
            off_end++
        }
        if (int($2 / 2048) % 2 == 1) {
            supplementary++
        }
    }
    END {
        if (reference_length != 1000 || records < 2 || aligned < 2 ||
            off_end != 0 || supplementary < 1) {
            print "circular-origin regression failed" > "/dev/stderr"
            print "records=" records ", aligned=" aligned \
                ", off_end=" off_end ", supplementary=" supplementary \
                > "/dev/stderr"
            exit 1
        }
        print "circular-origin regression passed: records=" records \
            ", off_end=" off_end + 0 ", supplementary=" supplementary
    }' "$work_dir/alignment.sam"
