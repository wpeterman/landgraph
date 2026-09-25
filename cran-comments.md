## Update submission

This is an update of landgraph from 0.0.1 (on CRAN) to 0.0.3. Version 0.0.2
was an internal development iteration and was not submitted.

## Changes in this version

* Grouped genetic covariance in `cov_from_genetic_data()` now defaults to the
  Gower diagonal, which preserves site centering and keeps the covariance on a
  single scale suitable for a Wishart likelihood. The previous behavior remains
  available via `diagonal = "within"` or `diagonal = "auto"`.
* `cov_from_biallelic()` and `cov_from_genetic_data()` now record covariance
  construction metadata (`diagonal`, `centered`) as attributes without changing
  any returned numerical values.
* Documentation clarifications on rare-variant weighting, unequal sampling
  variance, and which outputs are suitable for Wishart models.

See `NEWS.md` for the full list.

## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

* Local: Windows 11, R 4.6.0 (`devtools::check(cran = TRUE)`)
* `devtools::check_win_devel()`: Windows, R-devel

## Reverse dependencies

There are no reverse dependencies on CRAN.
