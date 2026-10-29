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

0 errors | 0 warnings | 1 note

The note appears only on win-builder (R-devel):

    * checking CRAN incoming feasibility ... NOTE
    Possibly misspelled words in DESCRIPTION:
      Bhatia (18:16)
      Gower (16:68)
      Nason (16:3)
      al (15:6, 18:26)
      et (15:3, 18:23)

These words are author surnames and "et al." in the method citations that
this version adds to the Description field (Yang et al. 2010; Dyer and Nason
2004; Gower 1966; Bhatia et al. 2013). They are spelled correctly.

## Test environments

* Local: Windows 11, R 4.6.0 (`R CMD check --as-cran` on the built tarball):
  0 errors, 0 warnings, 0 notes
* GitHub Actions (`R CMD check --as-cran`): macOS (R release), Windows
  (R release and R-devel), Ubuntu 24.04 (R-devel, R release, R oldrel-1):
  0 errors, 0 warnings, 0 notes
* win-builder (`devtools::check_win_devel()`): Windows, R-devel
  (2026-10-28 r90783 ucrt): 0 errors, 0 warnings, 1 note (above)

## Reverse dependencies

terradish: `R CMD check --as-cran` of terradish 1.0.0 against this version
gave no errors or warnings, and its tests and vignettes passed. (TO CONFIRM at
submission: rerun against the CRAN release of terradish.)
