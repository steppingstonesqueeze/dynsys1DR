
lyapunov_1d <- function(sys, vary, range, n_transient = 400, n_keep = 600) {
  var <- sys$vars[1]
  deriv_expr <- D(sys$rhs[[1]], var)
  r_vals <- seq(range[1], range[2], length.out = 600)
  out <- numeric(length(r_vals))
  for (k in seq_along(r_vals)) {
    params <- sys$params; params[[vary]] <- r_vals[k]
    env <- list2env(params)
    x <- unlist(sys$init)[1]
    for (i in 1:n_transient) {
      env[[var]] <- x
      x <- eval(sys$rhs[[1]], envir = env)
      if (!is.finite(x)) break
    }
    s <- 0; count <- 0
    if (is.finite(x)) {
      for (i in 1:n_keep) {
        env[[var]] <- x
        dval <- eval(deriv_expr, envir = env)
        if (is.finite(dval) && length(dval) == 1 && dval != 0) {
          s <- s + log(abs(dval)); count <- count + 1
        }
        x <- eval(sys$rhs[[1]], envir = env)
        if (!is.finite(x)) break
      }
    }
    out[k] <- if (count > 0) s / count else NA_real_
  }
  df <- tibble::tibble(param = r_vals, lyap = out)
  ggplot2::ggplot(df, ggplot2::aes(param, lyap)) +
    ggplot2::geom_line(na.rm = TRUE) +
    ggplot2::geom_hline(yintercept = 0, linetype = "dashed") +
    ggplot2::labs(title = "Lyapunov Exponent (1D)", x = vary, y = "lambda")
}
