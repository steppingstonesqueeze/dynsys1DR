
stability_1d <- function(sys, vary = NULL, range = NULL, bracket = c(0, 1)) {
  var <- sys$vars[1]
  deriv_expr <- D(sys$rhs[[1]], var)
  fp_one <- function(params) {
    env <- list2env(params)
    f <- function(x) { env[[var]] <- x; eval(sys$rhs[[1]], envir = env) - x }
    root <- tryCatch(uniroot(f, bracket)$root, error = function(e) NA_real_)
    if (is.na(root)) return(list(fp = NA_real_, deriv = NA_real_))
    env[[var]] <- root
    d <- eval(deriv_expr, envir = env)
    list(fp = root, deriv = d)
  }
  if (is.null(vary)) {
    ans <- fp_one(sys$params)
    stab <- if (is.finite(ans$deriv) && abs(ans$deriv) < 1) "Stable" else "Unstable"
    tibble::tibble(fixed_point = ans$fp, derivative = ans$deriv, stability = stab)
  } else {
    r_vals <- seq(range[1], range[2], length.out = 400)
    df <- lapply(r_vals, function(rv) {
      params <- sys$params; params[[vary]] <- rv
      ans <- fp_one(params)
      tibble::tibble(param = rv, fp = ans$fp,
                     stability = ifelse(is.finite(ans$deriv) & abs(ans$deriv) < 1, "Stable", "Unstable"))
    })
    df <- dplyr::bind_rows(df)
    ggplot2::ggplot(df, ggplot2::aes(param, fp, color = stability)) +
      ggplot2::geom_point(na.rm = TRUE) +
      ggplot2::labs(title = "Fixed Point vs Parameter", x = vary, y = "Fixed Point")
  }
}
