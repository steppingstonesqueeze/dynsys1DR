
.strip_index <- function(expr, vars) {
  expr_chr <- deparse(expr, width.cutoff = 500)
  for (v in vars) {
    expr_chr <- gsub(paste0("\\b", v, "\\s*\\[\\s*n\\s*\\]"), v, expr_chr)
  }
  parse(text = expr_chr)[[1]]
}

parser <- function(..., params = list(), init = list(), n_iter = 100) {
  exprs <- rlang::enexprs(...)
  vars <- names(init)
  if (length(exprs) != length(vars)) stop("Equations must match number of variables")
  rhs <- vector("list", length(exprs))
  for (i in seq_along(exprs)) {
    rhs[[i]] <- .strip_index(exprs[[i]][[3]], vars)
  }
  structure(list(rhs = rhs, params = params, init = init, n_iter = n_iter, vars = vars),
            class = "dynsys1D")
}
