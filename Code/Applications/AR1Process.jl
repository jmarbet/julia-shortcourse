using Plots                     # Needed for creating plots
using Distributions, StatsPlots # Needed for plotting the pdfs in AR1Example()
using BSON: @load, @save        # Needed to save and load Julia variables


"""
    AR1Simulation()

Basic example on how to simulate an AR(1) process.

"""
function AR1Simulation()

    # Settings
    T = 100     # Number of periods
    ρ = 0.9     # AR(1) coefficent
    σ = 0.1     # Standard deviation of the shock

    # Simulate the AR(1) process
    x = simulateAR1(ρ, σ; T = T)
    display(x) # Displays the resulting series in REPL

    # We can compute statistics for the computed process and print them
    computeSummaryStatistics(x, ρ, σ)

    # If you choose large T, the theoretical and simualted means and variances
    # should be very close to each other.

    # Now, let's see how we can plot the results

    # Creates a plot with the simulated series and saves it as variable p1
    p1 = plot(x, label = "AR(1) Process", legend = :bottomright)

    # Add a horizontal dashed line in black (so that we can see the zero line better)
    hline!([0], linestyle = :dash, color = :black, label = "")
    # Note the exclamation mark ! means that this is added to the previous plot
    # We could also explicitly write that we want to add it to plot p1:
    # hline!(p1, [0], linestyle = :dash, color = :black, label = "")

    # Suppose we want to compare our AR(1) process to a white noise process
    y = σ * randn(T) # White noise: N(0, σ²)
    plot!(y, label = "White Noise Process")

    # Let's add some axis labels and a title
    xlabel!("t")
    title!("Simulation")

    # Let's display the plot
    display(p1)

    # We could stop here but let's explore some of the functionality of Plots.jl

    # We could also compare the histograms
    p2 = histogram(x, title = "AR(1) Process", xlabel = "x_t", legend = :none, xlims = (-0.8, 0.8), normalize = :pdf)
    p3 = histogram(y, title = "White Noise Process", xlabel = "y_t", legend = :none, xlims = (-0.8, 0.8), normalize = :pdf)

    # Note how we used title and xlabel in the plotting command directly, while
    # we used separate commands for the plot p1.

    # Overlay the theoretical distributions
    plot!(p2, Normal(0.0, σ / sqrt(1-ρ^2)), linewidth = 2)
    plot!(p3, Normal(0.0, σ), linewidth = 2)

    # Now, we want to combine the three plots. First, let's define the layout
    l = @layout [a{0.5h}; grid(1,2)] # 1 plot in the top row that uses 50% of the total height,
                                     # 1x2 plots in the bottom row
    p = plot(p1, p2, p3, layout = l, size = (900, 600), margin = 5Plots.PlotMeasures.mm)

    # Save the figure
    savefig(p, "Code/Applications/AR1Plot.pdf")

    # Save the results of our simulation
    @save "Code/Applications/results.bson" ρ σ T x y

    return p # Note: we return the plot such that it will be displayed in Atom automatically
             # Alternatively, you can call display(p) to display the plot

end


"""
    simulateAR1(ρ, σ; T = 100)

Simulates a process of the form x_t = ρ x_{t-1} + ε_t for given ρ and σ.

"""
function simulateAR1(ρ, σ; T = 100, x1 = 0)

    # Initialize a vector holding the simulated AR(1) process
    x = zeros(T)

    # Set the initial value
    x[1] = x1 # Remember that array indexing in Julia starts at 1

    # Loop over the elements of x and compute the realizations of the AR(1 process)
    for tt in 2:T
        ε = σ * randn() # Note that randn() draws a random number from N(0,1).
                        # By multiplying by σ, the error term is actually N(0, σ²),
                        # i.e. Normal with mean 0 and variance σ²
        x[tt] = ρ * x[tt-1] + ε
    end

    return x

end


"""
    computeSummaryStatistics(x::Array{Float64,1}, ρ, σ)

Computes some statistics for the given vector and prints them in REPL.

"""
function computeSummaryStatistics(x, ρ, σ)

    # Note here we explicitly write that this functions only accepts vectors x with
    # elements of type Float64. However, this is not required. This is just
    # meant to show you the syntax.

    println("Simulated mean: ", mean(x))
    println("Theoretical mean: ", 0)
    println("Simulated variance: ", var(x))
    println("Theoretical variance: ", σ^2 / (1-ρ^2))

    nothing # Since this function only plots results, we don't return anything

end


"""
    AR1Estimation()

Basic example on how to estimate an AR(1) process. Note: you need to run
AR1Simulation() first.

"""
function AR1Estimation()

    # Load the simulated series for the AR(1) process
    @load "Code/Applications/results.bson" x

    # We need to construct the matrices for our OLS regression
    # Y = X * β + ε

    # We pretend to not know the exact process and will include a constant
    # in our regression (it will be part of X). This is just to show you how to
    # construct more complex arrays.

    # Dependent variable: x_t
    Y = x[2:end] # (T-1) vector

    # Explanatory variables: constant (represeneted as 1) and x_{t-1}
    X = [ones(length(Y)) x[1:end-1]] # (T-1)x2 matrix

    # Then, we can get an estimate of β using the usual OLS formula β̂ = (X'X)^(-1) * X' * Y
    β̂ = (X'*X) \ X' * Y
    # Alternatively, you could also write
    # β̂ = inv(X'*X) * X' * Y
    # However, backslash \ is preferred to inv() for numerical stability.
    # Note: To get β̂ type \beta, press tab, type \hat and press tab again

    # We can extract our estimate for ρ from β
    ρ̂ = β̂[2]
    c = β̂[1] # Constant

    # Residuals from the regression
    ε̂ = Y - X * β̂

    # Let's load the true ρ used in the simulation
    @load "Code/Applications/results.bson" ρ

    # Print the true and estimated values
    println("True ρ: ", ρ)
    println("Estimated ρ: ", ρ̂)
    println("Constant c (shoud be close to zero): ", c)

    nothing

end
