# doublr
An R package with with shiny apps for microbiologists. There are two functions, one which helps you convert wellplate maps to long format, and another that helps you analyze growth curve data.

# To install:
```
if (!requireNamespace("devtools", quietly=TRUE))
    install.packages("devtools")
devtools::install_github('gus-pendleton/doublr', build_vignettes=TRUE)
```

# `Launch()`

Launch Shiny app to calculate doubling times interactively


## Description

This app doesn't take any arguments, but launches a shiny app wherein you can interactively upload data to calculate doubling times. Please see the vignette using browseVignettes("doublr") to read through a walk-through of using the app. If no vignette is available, make sure to use devtools::install_github("gus-pendleton/doublr", build_vignettes = T) to make sure it is installed alongside the package.

# `make_wellmap_long`

Convert a "wide-formatted" 96-well plate map into long format

## Usage

```r
make_wellmape_long()
```

This will launch an interactive Shiny session where you can enter values manually or copy and paste from Excel/Google Sheets.
