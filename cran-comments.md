## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission. Versions 0.0.2 and 0.0.3 were internal development
  iterations; 0.0.3 is the first version submitted for publication on CRAN.

Local `R CMD check --as-cran` returns 0 errors, 0 warnings, and 0 notes. The
single note above is the expected "New submission" note raised by CRAN's
incoming checks.

## Changes in this version

* Grouped genetic covariance now defaults to the Gower diagonal, which preserves
  site centering and keeps the covariance on a single scale suitable for a
  Wishart likelihood. The previous behavior remains available via
  `diagonal = "within"` or `diagonal = "auto"`.
* `cov_from_biallelic()` and `cov_from_genetic_data()` now record covariance
  construction metadata (`diagonal`, `centered`) as attributes without changing
  any returned numerical values.

See `NEWS.md` for the full list.

## Platforms tested

* Local: Windows 11, R 4.6.0 (`devtools::check(cran = TRUE)`)
* `devtools::check_win_devel()`: Windows, R-devel

## Reverse dependencies

This is a new package. There are no existing reverse dependencies.
