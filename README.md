# ATRADA

[![License: MIT][1]][2]

## Overview

ATRADA (Automated Turbidity Reduction Assay Data Analysis) is an R-package for
analysing TRA data in an automated and easy-to-use manner. It is currently in
the very early stages of development and is thus **NOT** ready for any sort of
use beyond testing. *Use with causon*, in other words.

ATRADA's features include:

 * Parsing of TRA outputs from multiple compatible instruments
 * Fitting of the activity from each well to a sigmoidal curve and plotting the
   results in a 96-well format for inspection
 * Calculation of the specific enzymatic activity with both numerical and
   graphical outputs

So far, only the first two points are implemented, and only using a basic
fitting methodology. Future versions of ATRADA will evaluate other methods as
as include the last planned feature.

## Installation

ATRADA is currently only available here on GitHub, and can easily be installed
using the `devtools` R-package:

```r
# install.packages("devtools")
devtools::install_github("fasterius/ATRADA")
```

## Usage

Using ATRADA is simple. All you need is the installed package itself and your
TRA data in a `CSV` file. Analysing the activity in each well of your
experiment requires very little code:

```{r
# Load the ATRADA package
library("ATRADA")

# Read the TRA data
data <- read_tra_data("your_tra_data.csv")

# Fit and plot the per-well activites
fit_activity(data, "wells.png")
```

## License

ATRADA is released with a MIT licence. ATRADA is free software: you may
redistribute it and/or modify it under the terms of the MIT license. For more
information, please see the `LICENCE` file that comes with the ATRADA package.

[1]: https://img.shields.io/badge/License-MIT-blue.svg
[2]: https://opensource.org/licenses/MIT
