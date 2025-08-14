
trajectory_1d <- function(sys) {
  var <- sys$vars[1]
  x <- numeric(sys$n_iter)
  x[1] <- unlist(sys$init)[1]
  env <- list2env(c(sys$params))
  for (i in 1:(sys$n_iter - 1)) {
    env[[var]] <- x[i]
    x[i + 1] <- eval(sys$rhs[[1]], envir = env)
  }
  df <- tibble::tibble(iter = seq_len(sys$n_iter), x = x)
  ggplot2::ggplot(df, ggplot2::aes(iter, x)) +
    ggplot2::geom_line(na.rm = TRUE) +
    ggplot2::labs(title = "Trajectory (1D)", x = "Iteration", y = var)
}
