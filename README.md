# portfolio-optimization-matlab
# Portfolio Optimization in MATLAB

## Overview

This project implements and compares five portfolio allocation strategies in MATLAB, using historical asset returns and an Euro Stoxx benchmark.

The objective is to study portfolio construction, rolling-window evaluation, out-of-sample performance, and risk-adjusted metrics in a quantitative investment framework.

## Portfolio Strategies

The project compares the following approaches:

1. **Equal Weight (EW):** allocates capital equally across selected assets.
2. **Mean-Variance Constraint (MVC):** implements a constrained mean-variance allocation approach.
3. **Global Minimum Variance (GMV):** seeks to minimize portfolio variance.
4. **Risk Parity (RP):** allocates risk across portfolio constituents.
5. **Most Diversified Portfolio (MDP):** aims to maximize portfolio diversification.

## Methodology

The MATLAB workflow includes:

- Importing historical asset returns and benchmark data.
- Estimating expected returns and covariance matrices.
- Constructing portfolios using five allocation strategies.
- Applying rolling estimation windows to update portfolio inputs.
- Comparing portfolio performance across distinct in-sample and out-of-sample periods.
- Selecting the strategy with the highest Sharpe ratio at each evaluation step.
- Ranking assets by average portfolio weights and constructing a Top-15 portfolio.
- Comparing cumulative portfolio performance with the Euro Stoxx benchmark.

## Performance Evaluation

The backtesting framework includes two out-of-sample evaluation periods.

The analysis considers:

- Cumulative returns.
- Sharpe ratio.
- Beta and alpha.
- Correlation with the benchmark.
- Portfolio and benchmark volatility.
- Information ratio.

These metrics provide complementary perspectives on portfolio performance, market exposure, and risk-adjusted returns.

## Technologies

- **MATLAB** — portfolio construction, rolling-window analysis, backtesting, and performance evaluation.
- **Excel** — input data storage.

## Project Structure

The project is designed to include the main MATLAB script, supporting functions, input datasets where redistribution is permitted, and performance visualizations.

## Reproducibility

To run the analysis, MATLAB and the required input files and supporting functions must be available. The main script imports data from `DATI.xlsx` and `Eurostoxx.xlsx` and calls auxiliary functions for strategy construction, cumulative returns, portfolio sorting, beta estimation, and information ratio calculation.

The required files and execution instructions will be documented as the repository is organized.

