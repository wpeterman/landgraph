# landgraph <img src="man/figures/logo.png" align="right" height="139" alt="landgraph hex sticker" />

<!-- badges: start -->
<!-- badges: end -->

Shared, dependency-light functions for landscape-genetic **network** methods: a
lightweight graph, genetic covariance/distance from data, and antisymmetric
directional edge-covariate builders. It is the common elements beneath
[terradish](https://github.com/wpeterman/terradish) (symmetric resistance) and
[dragonflow](https://github.com/wpeterman/dragonflow) (asymmetric gene flow). No
compiled code.

## Installation

```r
# install.packages("remotes")
remotes::install_github("wpeterman/landgraph")
```

## What it provides

- **Graph:** `deme_graph(coords, neighbours = c("delaunay", "knn", "lattice"))`
  builds a deme/landscape graph (`vertex_coordinates` + an undirected `edge_pairs`
  list) directly from coordinates. The result has class
  `c("landgraph", "terradish_graph")`, so it is drop-in compatible with the graph
  consumed by `dragonflow::dragon()` and interchangeable with a
  `terradish::conductance_surface()` result.
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

# deme genetic covariance from per-deme derived-allele counts Y (demes x loci)
S <- cov_from_biallelic(Y, N = 40)

# directional covariates for a downstream directed model
elev <- g$vertex_coordinates[, 1]
d_grad <- edge_gradient(elev, g)                   # gradient of a scalar potential
d_curl <- edge_flow(wind_field, g)                 # a rotational flow field
```

## Relationship to the other packages

`landgraph` holds only the shared inputs. The methods live downstream: `terradish`
estimates symmetric conductance (resistance distance); `dragonflow` estimates
asymmetric gene flow via the structured coalescent. Both consume a `landgraph`
graph, a covariance from `cov_from_*`, and directional covariates from
`edge_gradient`/`edge_flow`.
