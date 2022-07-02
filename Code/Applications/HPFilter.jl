using Plots         # Needed for creating plots
using DataFrames    # Needed for easily handling datasets
using Dates         # Needed for date vector in dataframes
using CSV           # Needed for writing and reading CSV files
using Optim         # Needed for minimization of the objective function HP filter
using SparseArrays  # Needed for a more efficent implementation of the HP Filter
using LinearAlgebra # Needed for less efficient, full matrix implementation of the HP Filter


"""
    HPFilterExample()

Shows how to load data from a CSV file and apply a HP filter to a time series.

"""
function HPFilterExample()

    # Load the provided CSV file (which contains GDPC1 and GDPDEF)
    dataset = DataFrame!(CSV.File("Code/Applications/dataset.csv"))

    # Let's view the dataset in REPL
    display(dataset)

    # Now, we would like to use the HP filter on the log of the GDPC1 series
    y = log.(dataset.GDPC1)

    # Settings
    λ = 1600 # For quarterly data, it is common to use λ = 1600

    # A "naive" implementation just tries to minimize the function using a
    # function minimizer (similar to fminsearch in Matlab, for example)
    potential_output = apply_hp_filter_naive(y, λ)

    # A better implementation of the HP filter is based on the first
    # order conditios (FOCs). The FOCs can be put into matrix form and can then
    # be used to get a closed form solution for τ.
    potential_output = apply_hp_filter_inefficient(y, λ)

    # However, in the implementation based of FOCs it is important to take advantage
    # of sparse matrices (matrices mostly consisting of zeros) for best performance.
    # We compare the differences between implementations further down below.
    potential_output = apply_hp_filter(y, λ)

    # Plot the output and potential output series
    p1 = plot(dataset.date, y, label = "Log Output (GDP)", legend = :topleft)
    plot!(dataset.date, potential_output, label = "Log Potential Output")
    title!("Actual vs Potential Output")

    # Output Gap
    p2 = plot(dataset.date, y - potential_output, legend = :none)
    hline!([0], linestyle = :dash, color = :black, label = "")
    title!("Output Gap")

    # Combine both plots
    p = plot(p1, p2, layout = grid(2,1), size = (600, 800))
    display(p)

    # Comparing the implementations
    println("Naive HP filter implementation:")
    @time apply_hp_filter_naive(y, λ)
    println("\nInefficient matrix implementation:")
    @time apply_hp_filter_inefficient(y, λ)
    println("\nEfficient matrix implementation:")
    @time apply_hp_filter(y, λ)

    # Note to time a function always run it twice. The initial run will always be
    # a bit slower because of the initial compilation.

    return p

end


"""
    apply_hp_filter_naive(y, λ)

This "naive" implementation of the HP filter tries to minimize the objective
function using a function minimizer (similar to fminsearch in Matlab, for example)

"""
function apply_hp_filter_naive(y, λ)

    # Inital guess for τ
    x0 = copy(y)

    # Minimize the objective function
    res = optimize(
        x -> compute_objective(y, x, λ), # x is the vector we want to find
        x0,
        LBFGS(),
        Optim.Options(allow_f_increases = true)
    )

    # Retrieve the result
    τ = Optim.minimizer(res)

    return τ

end


"""
    compute_objective(y, τ, λ)

Objective function of the HP filter.

"""
function compute_objective(y, τ, λ)

    obj = 0.0

    # Compute the obejective function based on periods 2 to T-1
    for tt in 2:length(y)-1
        obj += (y[tt] - τ[tt])^2 + λ * (τ[tt+1] - τ[tt] - (τ[tt] - τ[tt-1]))^2
    end

    # Add parts of the objective function related to period 1 and T
    obj += (y[1] - τ[1])^2 + (y[end] - τ[end])^2

    return obj

end


"""
    apply_hp_filter(y, λ)

Efficient implementation of the HP filter based on FOCs of the minimization problem.
Uses SparseArrays for efficiency.

"""
function apply_hp_filter(y, λ)

    # Determine the length of the time series
    T = length(y)

    # The FOCs can be written in the following form:
    #  y = Γ * τ
    # We need to construct Γ which has 5 "diagonals" and the remaining elements are zero

    # The diagonals below and above the main diagonal are the same. Thus, we only
    # need to construct 3 diagonals to be able to construct the whole matrix
    diagonal0 = [1+λ; 1+5λ; (1+6λ) * ones(T-4); 1+5λ; 1+λ] # Vector of length T not Tx1 matrix!
    diagonal1 = [-2λ; -4λ * ones(T-3); -2λ] # Vector of length T-1
    diagonal2 = λ * ones(T-2) # Vector of length T-2

    # spdiagm initializes a sparse matrix which takes into account that most of
    # the elemnts of the matrix are zero. This is more memory efficient and matrix
    # calculations are also faster
    Γ = spdiagm(-2 => diagonal2, -1 => diagonal1, 0 => diagonal0, 1 => diagonal1, 2 => diagonal2)

    # Then, computing the inverse of Γ and multiplying by y is enough to compute
    # the filtered series
    τ = Γ \ y

    return τ

end


"""
    apply_hp_filter_inefficient(y, λ)

Inefficient implementation of the HP filter based on FOCs of the minimization problem.

"""
function apply_hp_filter_inefficient(y, λ)

    # Determine the length of the time series
    T = length(y)

    # The FOCs can be written in the following form:
    #  y = Γ * τ
    # We need to construct Γ which has 5 "diagonals" and the remaining elements are zero

    # The diagonals below and above the main diagonal are the same. Thus, we only
    # need to construct 3 diagonals to be able to construct the whole matrix
    diagonal0 = [1+λ; 1+5λ; (1+6λ) * ones(T-4); 1+5λ; 1+λ] # Vector of length T not Tx1 matrix!
    diagonal1 = [-2λ; -4λ * ones(T-3); -2λ] # Vector of length T-1
    diagonal2 = λ * ones(T-2) # Vector of length T-2

    # diagm creates a full matrix
    Γ = diagm(-2 => diagonal2, -1 => diagonal1, 0 => diagonal0, 1 => diagonal1, 2 => diagonal2)

    # Then, computing the inverse of Γ and multiplying by y is enough to compute
    # the filtered series
    τ = Γ \ y

    return τ

end
