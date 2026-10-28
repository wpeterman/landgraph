# landgraph <img src="man/figures/logo.png" align="right" height="139" alt="landgraph hex sticker" />

<!-- badges: start -->
<!-- badges: end -->

Shared, dependency-light functions for landscape-genetic **network** methods: a
lightweight graph, genetic covariance/distance from data, and antisymmetric
directional edge-covariate builders. It provides the common elements beneath
[terradish](https://github.com/wpeterman/terradish) (symmetric resistance). No
compiled code.

## Installation

```r
install.packages("landgraph")

# development version
# install.packages("remotes")
remotes::install_github("wpeterman/landgraph")
```

## What it provides

- **Graph:** `deme_graph(coords, neighbours = c("delaunay", "knn", "lattice"))`
  builds a deme/landscape graph (`vertex_coordinates` + an undirected `edge_pairs`
  list) directly from coordinates. The result has class
  `c("landgraph", "terradish_graph")`. The class lets `edge_gradient()` and
  `edge_flow()` accept the object. It lacks the covariates, Laplacian, and
  Cholesky factor that `terradish::terradish()` needs; build fitting graphs with
  `terradish::conductance_surface()`.
- **Genetic covariance / distance:** `cov_from_biallelic()` (Yang-style normalized
  dosage covariance), `cov_from_genetic_data()` (Dyer-style multivariate, including
  microsatellite allele calls), `fst_from_biallelic()`, `dist_from_cov()`,
  `dist_from_biallelic()`.
- **Directional edge covariates:** `edge_gradient(potential, graph)` (the
  curl-free gradient of a scalar potential) and `edge_flow(field, graph)` (the
  projection of a vector flow field, which can carry a rotational/curl component a
  scalar potential cannot).

## Example

```r
library(landgraph)

coords <- as.matrix(expand.grid(x = 0:4, y = 0:4))
g <- deme_graph(coords, neighbours = "lattice")   # 25 demes, rook adjacency

# derived-allele counts Y (demes x loci), 40 chromosomes per deme
set.seed(1)
Y <- matrix(rbinom(25 * 50, size = 40, prob = 0.4), nrow = 25)
S <- cov_from_biallelic(Y, N = 40)                # count-standardized scale
S_freq <- S / 40                                  # frequency scale for terradish

# directional covariates for a downstream directed model
elev <- g$vertex_coordinates[, 1]
d_grad <- edge_gradient(elev, g)                  # gradient of a scalar potential
wind_field <- function(xy) cbind(-(xy[, 2] - 2), xy[, 1] - 2)  # rotation about (2, 2)
d_curl <- edge_flow(wind_field, g)                # a rotational flow field
```

## Relationship to other packages

`landgraph` holds only the shared inputs. `terradish` estimates symmetric
conductance (resistance distance) from the covariance and distance matrices
built by `cov_from_*()` and `dist_from_*()`, and it builds its own fitting graphs
with `terradish::conductance_surface()`. `edge_gradient()` builds the
antisymmetric covariate `d_ab = x_a - x_b` for directional gene-flow models; it
is positive from high to low `x`. `edge_flow()` serves the same directional
models. `terradish` does not fit directional models.
