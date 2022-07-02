## Loading required packages ###################################################

using LinearAlgebra


## Types #######################################################################

# Functions to determine types
x = 1
println(typeof(x))
println(isa(x, Int64))

X = [1,2,3]
println(typeof(X)) # Type of X
println(eltype(X)) # Type of elements of X


## Simple types vs composite types #############################################

# Composite type definition
struct Parameter
  value::Float64
  transformation::Function
  tex_label::String
  description::String
end

# Create an instance of a composite type with a default constructor
β = Parameter(0.9, identity, "\beta", "Discount factor")
println(typeof(β))
println("β.value = ", β.value)

# Note that struct is immutable, i.e. redefining β.value would not work, which
# is usually not an issue for parameters. If you need to be able to change the
# values, you need to define a mutable struct.

# Define a constructor that refers to the default constructor
function Parameter(value::Float64, tex_label::String)
  transformation = identity
  description = "No description available"
  return Parameter(value, transformation, tex_label, description)
end

# Create an instance of a composite type with the new constructor
α = Parameter(0.5,"\alpha")
println(typeof(α))

# Obtain the fields contained in a composite type
println(fieldnames(typeof(α)))

# Access a particular field of an instance
println(α.value)
println(α.description)


## Concrete types vs abstract types ############################################

# Abstract type definition - the abstract keyword
abstract type Model end

# Define concrete types of the abstract type
mutable struct VAR <: Model
  n_lags::Int64
  variables::Vector{Symbol}
  coefficients::Matrix{Float64}
end

# Check subtype relation
println(VAR <: Model)

# Instances of the VAR type are also instances of the Model type
model = VAR(1,[:y_t,:π_t], Matrix(1.0I, 2, 2))
println(isa(model, VAR))
println(isa(model, Model))
# What happens if we do model <: Model?


## Parametric types ############################################################

# Define a parametric type
struct Duple{T}
  x::T
  y::T
end

# Create instances of the type duple
x = Duple(3,-10)
x = Duple{Int64}(3,-10)
x = Duple("Hello","Madrid")
x = Duple{String}("Hello","Madrid")
# Would x = Duple(3,3.0) work?

# Create parametric types restricted to certain subtypes
mutable struct PlanarCoordinate{T<:Number}
  x::T
  y::T
end


## Type-stable functions #######################################################

# Example of a type-unstable function
function f_unstable()
  sum = 0
  for i in 1:1000000
    sum = sum + i/2
  end
end
f_unstable() # Always run the function once before timing it.
             # The first run is always slower because of compilation.
@time f_unstable()
# @code_native f_unstable() to see the translation to machine language

# Example of a type-stable function
function f_stable()
  sum = 0.0
  for i in 1:1000000
    sum = sum + i/2
  end
end
f_stable()
@time f_stable()
# @code_native f_stable() to see the translation to machine language

# Note that if we time within another function we don't get any allocations.
# Thus, it's preferable to not time in global scope.
function timeBothFunctions()
  @time f_unstable()
  @time f_stable()
end
timeBothFunctions()


## Multiple dispatch ###########################################################

# Define one method for the function print_type
function print_type(x::Number)
  println("$x is a number")
end

# Define another method for the function print_type
function print_type(x::String)
  println("$x is a string")
end

# Define yet another method for the function print_type
function print_type(x::Number,y::Number)
  println("$x and $y are both numbers")
end

# Investigate the methods contained in a given function
println(methods(print_type))

# Try the function
x = 1
print_type(x)
x = "Hola"
print_type(x)
x = 1
y = 2.0
print_type(x,y)
# What happens if we try print_type([1,2,3])?

# Use multiple dispatch to specify different estimation behaviors for different models
# Define other subtypes of Model
mutable struct GLM <: Model
  independent_variables::Vector{Symbol}
  dependent_variables::Vector{Symbol}
  coefficients::Matrix{Float64}
end

# Attach multiple methods to the function estimate
function estimate(model::GLM)
  println("We will estimate a Generalized Linear Model")
end

function estimate(model::VAR)
  println("We will estimate a Vector Autoregression")
end

import Distributions

function estimate(model::VAR, prior::Distributions.Distribution)
  println("We will estimate a Bayesian Vector Autoregression")
end

println(methods(estimate))
estimate(model)
