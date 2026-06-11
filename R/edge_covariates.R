#' Directional edge covariates from a spatial layer
#'
#' Builds the antisymmetric per-directed-edge covariate
#' \eqn{d_{ab} = x_a - x_b} used by \code{terradish_directed} to drive
#' directional gene flow (e.g. elevation drop, flow accumulation, wind
#' potential).  \eqn{d_{ab} = -d_{ba}}, so a positive coefficient makes movement
#' from high to low \code{x} faster.
#'
#' @param x A \code{terra::SpatRaster} layer (or a numeric vector with one value
#'   per active graph cell) giving the potential whose gradient drives direction.
#' @param data A \code{terradish_graph} from \code{\link{deme_graph}}.
#' @return A list with \code{edges} (an integer matrix of directed edges, columns
#'   \code{a}, \code{b}, 1-based node indices) and \code{d} (the matching numeric
#'   vector \eqn{d_{ab} = x_a - x_b}).
#' @seealso \code{terradish_directed}
#' @export
edge_gradient <- function(x, data)
{
  stopifnot(inherits(data, c("terradish_graph", "radish_graph")))
  if (inherits(x, "PackedSpatRaster")) x <- terra::unwrap(x)
  if (inherits(x, "SpatRaster")) {
    vals <- terra::values(x, dataframe = FALSE)[, 1]
    # active cells in vertex order: extract at vertex coordinates
    vals <- terra::extract(x, data$vertex_coordinates)[, ncol(terra::extract(x, data$vertex_coordinates))]
  } else {
    vals <- as.numeric(x)
  }
  n <- nrow(data$vertex_coordinates)
  if (length(vals) != n)
    stop("`x` must give one value per active graph cell (", n, ").", call. = FALSE)
  ed <- .directed_edges(data)
  list(edges = ed, d = vals[ed[, 1]] - vals[ed[, 2]])
}

#' Circulation (flow-field) edge covariate from a spatial vector field
#'
#' Builds an antisymmetric per-edge covariate from a spatial VECTOR field (for
#' example wind or current), for the \code{circulation} argument of
#' \code{dragon}. Where \code{\link{edge_gradient}} takes the gradient of a
#' scalar potential -- which is curl-free and so yields a reversible generator
#' whose stationary distribution is collinear with the potential -- a flow field
#' can carry a rotational/curl component, making the directed generator
#' non-reversible and its stationary distribution non-collinear with any scalar
#' covariate.
#'
#' For undirected edge \eqn{(a, b)} the covariate is the mean field along the edge
#' projected onto the edge direction,
#' \eqn{c_{ab} = \tfrac{1}{2}(f_a + f_b) \cdot (xy_b - xy_a)}; it is antisymmetric
#' by construction, and \code{dragon} applies \eqn{-c_{ab}} to the reverse
#' edge \eqn{b \to a}.
#'
#' @param field The vector field at the active graph cells: a two-column numeric
#'   matrix or data frame (x- and y-components, in vertex order), a two-layer
#'   \code{terra::SpatRaster} (sampled at the vertex coordinates), or a function of
#'   a two-column coordinate matrix returning such a two-column field.
#' @param data A \code{terradish_graph} from \code{\link{deme_graph}}
#'   (must carry \code{vertex_coordinates}).
#' @return A numeric vector with one entry per undirected edge in
#'   \code{data$edge_pairs}, ready to pass as \code{dragon(circulation = )}.
#' @seealso \code{\link{edge_gradient}}, \code{dragon}
#' @export
edge_flow <- function(field, data)
{
  stopifnot(inherits(data, c("terradish_graph", "radish_graph")))
  vc <- as.matrix(data$vertex_coordinates)
  n <- nrow(vc)
  if (inherits(field, "PackedSpatRaster")) field <- terra::unwrap(field)
  if (inherits(field, "SpatRaster")) {
    ex <- terra::extract(field, vc)
    fmat <- as.matrix(ex[, (ncol(ex) - 1L):ncol(ex), drop = FALSE])
  } else if (is.function(field)) {
    fmat <- as.matrix(field(vc))
  } else {
    fmat <- as.matrix(field)
  }
  if (nrow(fmat) != n || ncol(fmat) != 2L)
    stop("`field` must give a two-column vector field per active graph cell (",
         n, " x 2).", call. = FALSE)
  ep <- data$edge_pairs
  if (is.null(ep)) ep <- t(data$adj) + 1L
  ep <- as.matrix(ep); a <- ep[, 1]; b <- ep[, 2]
  dirv <- vc[b, , drop = FALSE] - vc[a, , drop = FALSE]      # edge direction a -> b
  favg <- 0.5 * (fmat[a, , drop = FALSE] + fmat[b, , drop = FALSE])
  rowSums(favg * dirv)
}

# Directed edge list (both directions) from the graph's undirected edge_pairs.
.directed_edges <- function(data)
{
  ep <- data$edge_pairs
  if (is.null(ep)) {
    ep <- t(data$adj) + 1L                      # adj is 0-based upper-tri
  }
  ep <- as.matrix(ep); storage.mode(ep) <- "integer"
  rbind(cbind(a = ep[, 1], b = ep[, 2]),
        cbind(a = ep[, 2], b = ep[, 1]))
}

# Generator model: par = c(theta (p), gamma (q)) -> directed rates + design.
