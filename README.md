# docker-MToolBox

Dockerfile for installing MToolBox.

# Version
| Tool | Version |
|------|---------|
| MToolBox | 1.2.1 (`b52269e98c694d3e4ba25eb80f27b74b48985ddb`) |
| Python | 2.7.18 |
| Anaconda | 2-4.2.0 |
| zlib | 1.3.1 |
| SAMtools | 1.3 |
| MUSCLE | 3.8.31_i86linux64 |
| GMAP / GSNAP | 2021-03-08 |

---

## Notes

- The image downloads the upstream MToolBox source archive at build time and replaces the bundled installer with the checked-in [install.sh](./install.sh).

## Discussions

- [Issue tracker](https://github.com/TheBoutrosLab/docker-MToolBox/issues) to report errors and enhancement ideas.
- Discussions can take place in [docker-MToolBox Discussions](https://github.com/TheBoutrosLab/docker-MToolBox/discussions)
- [docker-MToolBox pull requests](https://github.com/TheBoutrosLab/docker-MToolBox/pulls) are also open for discussion

---

## Contributors

Please see list of [Contributors](https://github.com/TheBoutrosLab/docker-MToolBox/graphs/contributors) at GitHub.

---

## References

1. [MToolBox GitHub repository](https://github.com/mitoNGS/MToolBox)
2. [Calabrese C, Simone D, Diroma MA, et al. MToolBox: a highly automated pipeline for heteroplasmy annotation and prioritization analysis of human mitochondrial variants in high-throughput sequencing. Bioinformatics. 2014;30(21):3115-3117.](https://pubmed.ncbi.nlm.nih.gov/25028726/)

---

## License

Author: Yash Patel

`docker-MToolBox` is licensed under the GNU General Public License version 2. See the file LICENSE for the terms of the GNU GPL license.

`docker-MToolBox` provides a Dockerfile for  creating an image with MToolBox and its legacy dependency stack.

Copyright (C) 2026 Sanford Burnham Prebys Medical Discovery Institute ("Boutros Lab") All rights reserved.

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
