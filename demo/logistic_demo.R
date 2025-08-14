
library(dynsys1DR)

sys <- parser(
  x[n+1] ~ r * x[n] * (1 - x[n]),
  params = list(r = 3.7),
  init = list(x = 0.2),
  n_iter = 800
)

trajectory_1d(sys)
bifurcation_1d(sys, vary = "r", range = c(0.5, 4))
lyapunov_1d(sys, vary = "r", range = c(0.5, 4))
stability_1d(sys) # just shows stability of nonzero fps at r = 3.7 by default
stability_1d(sys, vary = "r", range = c(0.5, 4))
