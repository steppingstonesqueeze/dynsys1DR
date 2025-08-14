
bifurcation_1d <- function(sys, vary, range, n_transient = 400, n_keep = 120) {
  var <- sys$vars[1]
  r_vals <- seq(range[1], range[2], length.out = 600)
  res <- lapply(r_vals, function(rv) {
    params <- sys$params; params[[vary]] <- rv
    env <- list2env(params)
    x <- numeric(n_transient + n_keep)
    x[1] <- unlist(sys$init)[1]
    for (i in 1:(length(x) - 1)) {
      env[[var]] <- x[i]
      x[i + 1] <- eval(sys$rhs[[1]], envir = env)
    }
    tibble::tibble(param = rv, x = x[(n_transient + 1):(n_transient + n_keep)])
  })
  df <- dplyr::bind_rows(res)
  ggplot2::ggplot(df, ggplot2::aes(param, x)) +
    ggplot2::geom_point(shape = 16, size = 0.1, alpha = 0.6, na.rm = TRUE) +
    ggplot2::labs(title = "Bifurcation Diagram", x = vary, y = var)
}
