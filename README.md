# Caravel User Project

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)

| :exclamation: Important Note            |
|-----------------------------------------|


## Project description and development: https://github.com/openpowerfoundation/toy-sram

This project is a test site for a custom 10T array cell design.  It is built as a 32x32 2R1W regfile and includes Wishbone and scan I/O access.


### Sim

* should build and sim (currently fails)

```
make verify-toysram_scan-rtl
```

Refer to [README](docs/source/index.rst) for this sample project documentation.
