## Update submission

This is an update of landgraph from 0.0.3 (on CRAN) to 0.0.4.

## Changes in this version

* Documentation corrections so that the help pages and vignette agree with
  the code and with the downstream package 'terradish', which re-exports the
  covariance and distance helpers.
* `dist_from_cov()` keeps row and column names. `fst_from_biallelic()` keeps
  names and aligns a locus-length `N` vector with the columns of `Y` (the only
  change in returned values). `dist_from_biallelic()` gains `N = NULL`.
  `deme_graph()` validates `k`.
* DESCRIPTION now cites the implemented methods with DOIs.

See `NEWS.md` for the full list.

## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

* Local: Windows 11, R 4.6.0 (`R CMD check --as-cran` on the built tarball)
* `devtools::check_win_devel()`: Windows, R-devel (TO RUN before submission)

## Reverse dependencies

terradish: `R CMD check --as-cran` of terradish 1.0.0 against this version
gave no errors or warnings, and its tests and vignettes passed. (TO CONFIRM at
submission: rerun against the CRAN release of terradish.)
