# dynsys1DR

A computational framework for analyzing one-dimensional discrete dynamical systems in R, featuring automated parsing of difference equations and comprehensive tools for studying chaos, bifurcations, and stability.

## Overview

This package provides a domain-specific language (DSL) for defining and analyzing discrete dynamical systems of the form x[n+1] = f(x[n], parameters). It automates the mathematical analysis typically done by hand in dynamical systems theory, making complex nonlinear dynamics accessible through computational exploration.

## Theoretical Foundation

### Discrete Dynamical Systems

The package analyzes systems of the form:
```
x[n+1] = f(x[n], r)
```

Where:
- `x[n]` is the state at iteration n
- `f` is the mapping function (potentially nonlinear)
- `r` represents system parameters
- The system evolves through discrete time steps

### Key Concepts Implemented

**Fixed Points**: Solutions where x* = f(x*, r)
- Found by solving f(x) - x = 0 using numerical root finding
- Stability determined by |f'(x*)| < 1 (stable) or |f'(x*)| ≥ 1 (unstable)

**Bifurcation Theory**: Parameter values where system behavior changes qualitatively
- Period-doubling cascades leading to chaos
- Critical parameter values where stability changes

**Lyapunov Exponents**: Measure of sensitivity to initial conditions
```
λ = lim[n→∞] (1/n) Σ log|f'(x[i])|
```
- λ > 0: Chaotic behavior (sensitive dependence)
- λ = 0: Marginal stability
- λ < 0: Periodic or fixed point behavior

## Core Architecture

### Equation Parser

The `parser()` function implements a sophisticated expression manipulation system:

```r
parser <- function(..., params = list(), init = list(), n_iter = 100)
```

**Key Innovation**: Automatic index stripping that converts:
- `x[n+1] ~ r * x[n] * (1 - x[n])` (mathematical notation)
- To: `r * x * (1 - x)` (computational form)

This allows users to write equations in natural mathematical notation while the system handles the computational details internally.

### Analysis Functions

**Trajectory Analysis** (`trajectory_1d.R`)
- Numerical integration of the difference equation
- Visualization of system evolution over time
- Handles parameter-dependent dynamics

**Stability Analysis** (`stability_1d.R`)
- Automatic computation of fixed points using `uniroot()`
- Derivative-based stability classification
- Parameter sweep functionality for stability boundaries

**Bifurcation Diagrams** (`bifurcation_1d.R`)
- High-resolution parameter sweeps
- Transient elimination for steady-state behavior
- Visual identification of period-doubling routes to chaos

**Lyapunov Exponent Computation** (`lyapunov_1d.R`)
- Numerical computation using derivative chain rule
- Automatic differentiation via R's symbolic `D()` operator
- Statistical averaging over long trajectories

## Advanced Features

### Symbolic Differentiation Integration

The package leverages R's built-in symbolic differentiation:

```r
deriv_expr <- D(sys$rhs[[1]], var)
```

This enables automatic computation of:
- Stability criteria via f'(x*)
- Lyapunov exponents via log|f'(x[i])|
- Linearization around fixed points

### Robust Numerical Methods

**Fixed Point Finding**:
- Bracketing methods with error handling
- Automatic bracket adjustment for convergence
- Graceful failure modes for unbounded systems

**Long-term Behavior Analysis**:
- Transient elimination (typically 400 iterations)
- Statistical sampling of attractors (600+ points)
- Numerical stability checks throughout computation

### Expression Manipulation System

The core parser implements sophisticated string processing:

```r
.strip_index <- function(expr, vars) {
  expr_chr <- deparse(expr, width.cutoff = 500)
  for (v in vars) {
    expr_chr <- gsub(paste0("\\b", v, "\\s*\\[\\s*n\\s*\\]"), v, expr_chr)
  }
  parse(text = expr_chr)[[1]]
}
```

This allows seamless translation between mathematical and computational representations.

## Usage Examples

### Logistic Map Analysis
```r
library(dynsys1DR)

# Define the classic logistic map
sys <- parser(
  x[n+1] ~ r * x[n] * (1 - x[n]),
  params = list(r = 3.5),
  init = list(x = 0.1),
  n_iter = 1000
)

# Generate trajectory
trajectory_1d(sys)

# Bifurcation diagram showing route to chaos
bifurcation_1d(sys, vary = "r", range = c(2.8, 4.0))

# Lyapunov exponent across parameter space  
lyapunov_1d(sys, vary = "r", range = c(2.8, 4.0))

# Fixed point stability analysis
stability_1d(sys, vary = "r", range = c(1.0, 4.0))
```

### Custom Nonlinear Systems
```r
# Tent map
tent_sys <- parser(
  x[n+1] ~ ifelse(x[n] < 0.5, 2*a*x[n], 2*a*(1-x[n])),
  params = list(a = 0.9),
  init = list(x = 0.3)
)

# Cubic map
cubic_sys <- parser(
  x[n+1] ~ r * x[n] * (1 - x[n]^2),
  params = list(r = 2.5),
  init = list(x = 0.2)
)
```

## Research Applications

### Chaos Theory Studies
- Route to chaos investigation (period-doubling, intermittency)
- Lyapunov exponent computation for chaos characterization
- Strange attractor analysis through bifurcation diagrams

### Population Dynamics
- Discrete-time population models
- Harvesting and resource limitation effects
- Multi-species competition dynamics

### Economic Modeling
- Discrete-time market dynamics
- Consumer behavior iteration models
- Economic cycle analysis

### Pedagogical Applications
- Interactive exploration of nonlinear dynamics concepts
- Visualization of mathematical theory
- Computational experiments complementing analytical work

## Technical Advantages

### Automated Analysis Pipeline
Unlike manual mathematical analysis, the package provides:
- Automatic stability classification
- Numerical bifurcation detection
- Systematic parameter space exploration

### Computational Efficiency
- Optimized numerical routines
- Vectorized operations where possible
- Memory-efficient long-term iteration

### Mathematical Rigor
- Proper transient elimination
- Statistical averaging for Lyapunov exponents
- Robust root-finding algorithms

## Package Dependencies

```r
# Core dependencies
library(rlang)      # Advanced expression manipulation
library(tibble)     # Modern data frame handling  
library(dplyr)      # Data transformation
library(ggplot2)    # Visualization system
```

The package leverages advanced R metaprogramming capabilities through `rlang` for expression capture and manipulation, while providing publication-quality visualizations through `ggplot2`.

## Limitations and Future Development

### Current Scope
- Limited to one-dimensional discrete systems
- Single-variable dynamics only
- Fixed numerical parameters (iteration counts, resolution)

### Potential Extensions
- **Multi-dimensional Systems**: 2D and 3D discrete dynamics
- **Stochastic Elements**: Noise-driven dynamical systems  
- **Adaptive Resolution**: Smart parameter space sampling
- **Advanced Attractors**: Strange attractor reconstruction
- **Interactive Visualization**: Real-time parameter exploration

## Theoretical Context

This package implements computational methods for studying discrete dynamical systems, a field with applications spanning:

- **Mathematical Biology**: Population dynamics, epidemiology
- **Physics**: Discrete-time quantum systems, nonlinear oscillators  
- **Economics**: Market models, game theory dynamics
- **Computer Science**: Pseudo-random number generation, complexity theory

The combination of symbolic computation, numerical analysis, and visualization provides a comprehensive toolkit for exploring the rich behavior of nonlinear discrete systems.

---

*This package demonstrates the power of computational mathematics to make advanced dynamical systems theory accessible through automated analysis and visualization, bridging theoretical mathematics with practical exploration tools.*