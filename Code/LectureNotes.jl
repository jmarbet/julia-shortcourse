### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# ╔═╡ ab1cffca-efd5-11ec-1d46-67a055f03758
begin
	using ImageShow
	using ImageIO
	using FileIO
	using BenchmarkTools
end;

# ╔═╡ a8e4672d-2889-4813-a986-9604659b8096
using Plots

# ╔═╡ 186958e8-dbd1-4bbf-94d1-10f9de56b083
md"# Julia Language Short Course

Joël Marbet, July 2, 2022

Prepared for the CEMFI Undergraduate Internship 2022.


"

# ╔═╡ 1ddf5456-0cdf-481b-a378-6fad6482ccff
md"""## Introduction

### About this Short Course

This short course provides an introduction to the Julia programming language. We will start from the basics and assume little to no background on scientific computing. For example,
  * Concepts such as variables, loops, and functions will be introduced
  * Some basic applications are discussed
  * Discuss how to structure a basic program

"Short" implies that we will only be able to scrape the surface
  * Advanced topics such as parallel or GPU computing will be skipped
  * Other topics (e.g. multiple dispatch) will be only briefly mentioned
  * Goal is to get you started with writing your own Julia programs 

At the end I will provide references for further learning.
"""

# ╔═╡ 99a749a1-4b2a-40e9-b06e-71e378e44fc2
md"""### Why Julia?

Why not learn Matlab, Python, R, Fortran, C or something else? After all, these language have very large communities and maybe you even know one of these languages already. The main reasons for learning Julia are

* High-level + High-performance
  * Fast languages like C and Fortran are "difficult" to use (e.g. they require careful specification of variable types and function inputs)
  * "Easy to use" languages like Matlab, Python and R are slow to execute
  * Julia combines fast execution time with ease of use
* Geared towards scientific computing
* Completely free and open source
* Quickly spreading over professional and scientific communities

"""

# ╔═╡ d2343252-6f80-4a29-9b70-11b323c9deec
md"###  Julia Micro-Benchmarks"

# ╔═╡ c4bcecbb-b068-4ff1-8b1b-27cfe50a7b23
load("Figures/benchmarks.png")

# ╔═╡ e16c0130-ee3f-43eb-9f78-73788a51cf7c
md"""### Installation

You can install Julia ([https://julialang.org/downloads/](https://julialang.org/downloads/)) and use any text editor you like. However, VSCode with the Julia extension offers many IDE features that improve the usability a lot. For example, with VSCode you get
  * a debugger, 
  * a profiler,
  * a list of variables in the workspace (similar to Matlab),
  * git-repository integration,
  * easy access to the Julia documentation,
  * many more features that can be added using VSCode extensions

#### Basic Installation Steps
  * Install Julia: [https://julialang.org/downloads/](https://julialang.org/downloads/)
  * Install VSCode: [https://code.visualstudio.com](https://code.visualstudio.com)
  * Install Julia for VSCode: Go to "View" in VSCode, then click on "Extensions" and type \"julia\" in the search box and hit enter. Install the Julia extension.
  * Julia packages can then be installed using Julia's package manager if necessary
"""

# ╔═╡ f927d9f6-c951-47b5-86f2-151b8f9cb555
md"### Development Environment: Julia for VSCode
	
Once everything is installed VSCode should look similar to this
"

# ╔═╡ 06e11828-2c21-4d03-b598-05f69cebcd51
load("Figures/vscode.png")

# ╔═╡ eaa545df-d2bb-4151-9430-4ad67011602d
md"""### Interacting with Julia

#### The Command-Line: REPL
"""

# ╔═╡ a108df01-11d0-4bd0-ba5b-7f752649ad68
load("Figures/REPL_white_new.png")

# ╔═╡ 995ddb34-a779-40a9-be54-2f159d862e8a
md"""
The REPL (read-eval-print loop) is the main way to interact with Julia. Here you can, for example, execute Julia code and update packages. To start this notebook, you had to run a command in REPL already.
"""			

# ╔═╡ fa070ccb-0751-4f31-b130-46ded46cf83d
"""
Different REPL modes can be activated by typing the characters below</li>
<ul>
  <li><span style="color:grey">?</span>: Shows basic documentation for functions (Prompt: <span style="color:yellow">help?</span>)</li>
  <li><span style="color:grey">]</span>: Package manager (Prompt: <span style="color:grey">(@v1.7) pkg></span>)</li>
  <li><span style="color:grey">;</span>: Execute system commands (Prompt:  <span style="color:green">shell></span>)</li>
  <li>Pressing "backspace" brings you  back to the default "Julian" mode (Prompt:  <span style="color:green">julia></span>)</li>
</ul>
""" |> HTML

# ╔═╡ 66de4aac-9738-4729-aaa0-c3e5491272dd
md"""
We will have a closer look at the REPL, once we discuss the applications towards the end of the course.
"""

# ╔═╡ f3813785-ad23-4b5d-942a-ee6c4ca1b377
md"""
#### Pluto Notebooks

At the beginning we will mainly work within this Pluto notebook. Pluto notebooks are similar to Juypter notebooks with which you might already familiar with if you know Python. However, there are some important differences.

Pluto notebooks provide a reactive interface: when one variable or function is changed, the whole notebook is updated. This can be convenient for the purpose of exploration but it puts some restictions on the code that can be written in the cells such as
* A cell can only contain a single statement
* A variable can only be defined once in a notebook

For this reason, we sometimes encapsulate the multiple lines of code in a `begin` or `let` statement to work around these restrictions. In REPL or in a Julia file, this would not be necessary.

Note that cells can be executed by pressing `shift-enter` or the run button in the bottom right of a cell.
"""

# ╔═╡ 0faed82c-589b-44a1-9ea4-82e3bab492a5
md"""
!!! note "Difference between let and begin" 
    Note that variables created in a `let` block will not be available outside that block, while variables created in a `begin` block will be available outside that block.
"""

# ╔═╡ 1509eff9-3ab2-4dfe-a78f-aff3754da8d8
md"""
## Basics

Let's start with the basics of any programming language. All programs consist of the following
  * Variables,
  * Functions,
  * Loops,
  * Conditionals

We will have a particular look on how Julia implements these concepts.

"""

# ╔═╡ 16033d7b-e4aa-47f4-a79a-897f2599ae4c
md"""
### Variables and Types

Variables are basic elements of any programming language. They
  * store information,
  * can be manipulated by the program, and
  * can be of different types, e.g. integers, floating point numbers (floats), strings (sequences of characters), or booleans (`true` or `false`)

Julia is dynamically typed, which means
  * it can infer the type of a variable from its assigned value, and
  * a programmer does not need to explicitly specify the type

For example, assigning a value of `1` to a variable called `myvar` can be done as follows
"""

# ╔═╡ 2b6cda5e-442c-4880-820b-a58d333ba307
myvar = 1

# ╔═╡ edf7dfc5-8325-418b-b3cd-23f568f061d1
typeof(myvar)

# ╔═╡ 8d0125b6-4c83-43e2-8e69-86ac69d5e511
md"""
Note that the variable name to which we assign a value is always on the left of the equal sign, while the value itself is (computed) on the right. In this case, we have created a variable of type Integer (`Int64`). Some additional examples
"""

# ╔═╡ 97b45c4f-b527-4b07-99e6-b3c6c76c58f5
let 
	a = 1			# a is of type Integer
	b = 2.0			# b is of type Float 
	c = "Hello!"	# c is of type String
	d = true		# d is of type Bool
end;

# ╔═╡ 353435cb-2f85-475f-93ba-eb1d170b2956
md"""
 Everything after `#` is a "comment" and is ignored by Julia.
"""

# ╔═╡ abc20cde-f4bd-41ef-bcc1-60371e99829d
md"""
#### Mathematical Operations

Mathematical operations can be performed as you would expect

"""

# ╔═╡ 05291062-9836-4f9b-a4b1-8a5e88ae17b3
let 
	x = 5.0			# Assign to variable x
	y = 2.0			# Assign to variable y
	z = x + y		# Perform addition
	z = x - y		# Perform subtraction
	z = x * y		# Perform multiplication
	z = x / y		# Perform division
	z = x ^ y		# Raise x to the yth power
	z = x % y		# Remainder, equivalent to rem(x,y)
end;

# ╔═╡ f5bab507-5a8f-4248-83f3-5556b2fbf771
md"""Each line above uses variables `x` and `y` to perform an operation, and assign the result to variable `z`. These operators can have alternative meanings if they are applied to variables other than integers and floats. For example, `*` can be used to join two strings 
"""

# ╔═╡ 8962a0a1-f4ce-42ec-bb2e-5439f2580ff8
"Hello " * "World"

# ╔═╡ 0f2c526c-e3b9-403b-994e-a25caa721c6c
md"""
#### Variable Names

A valid variable name must satisfy the following
  * First character: letter (a-z; A-Z), an underscore, or a subset of unicode characters (for details see the documentation)	
  * After the first char.: numbers (0-9), !, and few others are allowed

Note that some names are reserved (e.g. `if` and `function`). Such names cannot be used as variable names. There are also some stylistic conventions
  * Write variable names in lowercase letters: `myvariablename`
  * Use underscores if the variable name would be hard to read otherwise: `hard_to_read_variable_name`
  * Personally, I like to use camelcase: `myVariableName`. However, this is not proper Julia style

* Use descriptive variable names not just letters and symbols
			
"""

# ╔═╡ 01b4311f-9aad-473a-8c70-b29bd5fbe4dd
md"""#### Examples: Creating Variables and Operating on Them"""

# ╔═╡ c83a9563-68bf-4d3b-a3d0-fdcad4375bd7
md"""
##### Strings

The following creates two variables of type `String` and combines to a new string
"""

# ╔═╡ 57451b78-1e52-4c8e-b788-7727ca9c6d3f
begin
	greet = "Hello"
	whom = "Madrid"
	greeting = "$greet $whom" # Interpolation of strings
end

# ╔═╡ 1b604817-7c07-4ae5-b59c-ad50296deac4
md"""We can also check the type of a variable after we have created it"""

# ╔═╡ 0864432a-f480-434e-92c2-48d1b4cc10bf
typeof(greeting)

# ╔═╡ 921af1b7-8085-4fd7-923a-d0d0ec97356c
md"""
As mentioned before, we could have created the same string using the string joining operator `*`

"""

# ╔═╡ e9e194eb-2055-496b-b7f1-a69e62574164
greet * " " * whom

# ╔═╡ 25d84f26-8ae7-461d-90ef-eb9b6fb07634
md"""
##### Integers and Floats

The mathematical operations that we mentioned above can be used on both `Float`
 and `Integer` variables. Consider the following example

"""

# ╔═╡ 3b08597e-b7a4-4a36-aa43-9fea5070acb7
x = 1;

# ╔═╡ 91d52680-2cac-4fd8-a17d-d00747c85573
y = 2;

# ╔═╡ 6d95f769-0055-43e2-aeaa-f6211e362ff0
z = x + y

# ╔═╡ c809d6a2-8652-460c-8c9d-339abd566948
typeof(z)

# ╔═╡ 5c9a809a-515e-463a-9d1e-7666f2610aac
z2 = x * y

# ╔═╡ ecd25386-30cc-4e8a-9ceb-296964b71079
typeof(z2)

# ╔═╡ 59058628-99c4-43f6-a0b3-772335068230
z3 = x / y

# ╔═╡ ef5b5829-2903-4d76-a485-73e5511c7570
typeof(z3)

# ╔═╡ f6b9a619-7924-4e17-9c75-6a0dbcadebcb
md"""
!!! note "Mini-Exercise"
	Change the value of x from 1 to 1.0 (i.e. from `Integer` to `Float`) and check how the types of z, z2 and z3 change.	
"""

# ╔═╡ cb422498-6157-46e8-950b-dae6b08c1aa8
md"""
##### Bool

Variables of type `Bool` can only take values `true` or `false`.

"""

# ╔═╡ e4807864-de53-404f-8971-4a13576c430b
A = true

# ╔═╡ c73e40e9-3696-4231-a1f1-c40b089bea37
B = false

# ╔═╡ e862bdb6-3b89-4a95-89b9-78ab30a39c80
md"""The supported boolean operaters are"""

# ╔═╡ d0c5d2f9-cb54-4b8f-9237-f040db3f1a09
!A # negation

# ╔═╡ 0a775b8e-7143-415b-880f-be79884e45e6
A && B # and

# ╔═╡ 03b39733-be43-4dcc-91b8-b439b9f50822
A || B # or

# ╔═╡ 4fa57fe3-7114-4615-83d9-6a33e120a383
md"""
Note that further up in the notebook we have defined x = $(x) and y = $(y). We can do comparisons of these values, which returns a `Bool`

    ==		# equality
    !=, ≠	# inequality
    <		# less than
    <=, ≤	# less than or equal to
    >		# greater than
    >=, ≥	# greater than or equal to

"""

# ╔═╡ a498562c-3542-49bc-a2c9-142897a2f9e4
x == y

# ╔═╡ 8c0e1df2-eca2-4eac-8595-055b8130484f
x != y

# ╔═╡ 7c036167-a628-46ab-a8ff-64e78438558e
x >= y

# ╔═╡ 23a53a42-064b-4657-885b-93a4699a837c
x > y

# ╔═╡ 39fd6d11-d3e1-496f-aa8b-343b91a9e090
x < y

# ╔═╡ c8ce0148-9b17-4899-aa8a-0b2dc3672053
x <= y

# ╔═╡ 1153ea92-3507-4672-af3a-692a7279912d
md"""These can also be assigned to variables, e.g."""

# ╔═╡ e6784ffc-7db4-49f2-9090-958551bfdf2a
comp = (x == y)

# ╔═╡ cbb10de9-c111-4f70-9709-5125b90f90cf
typeof(comp)

# ╔═╡ 23590679-4453-4382-996d-30b6b5af746b
md"""Note that the parenthesis are not stricly required but make it more readable."""

# ╔═╡ 458cc84d-91c6-477b-aa65-bfa56023ccb3
md"""
##### Built-in constants and functions
Julia also has some built-in constants. For example
"""

# ╔═╡ 535bd639-766d-40e4-bb76-cfaff7457bbf
pi

# ╔═╡ 941fcc71-12aa-419e-bf3c-1e4255b78760
ℯ # type "\euler" and then press the tab key

# ╔═╡ acb51f91-c5b4-4cfe-ab61-2cf78e11102c
md"""For other constants, check the documentation for `Base.MathConstants`"""

# ╔═╡ 33e4adb5-9ffc-4355-9d76-9a6869ef6dbb
Base.MathConstants

# ╔═╡ fece6ca3-c2e0-44f0-ab9c-7a1f8b119692
md"""Common functions are also available without loading additional packages"""

# ╔═╡ be077f6d-9318-4499-ae21-867041989049
log(10) # Natural logarithm

# ╔═╡ 87211e9a-c3b6-4813-b330-35b478369c69
log10(10) # Base 10 logarithm

# ╔═╡ f51c52c3-014d-4f17-be98-9c10f40becec
exp(3.4) # Exponential

# ╔═╡ aa46c7da-bdbd-433f-b3f4-e83254da3e84
sqrt(2) # Square root

# ╔═╡ f2743122-45a8-427b-af69-080274b461d6
md"""
##### Unicode Symbols

Julia is fully unciode compatible and any symbol can be used as variable or function names. In VSCode, Pluto, and REPL you can type unicode characters by typing the corresponding latex command and pressing tab key.

For example: \alpha + tab becomes `α`

"""

# ╔═╡ bcdd8f0f-cfd0-4672-bbaf-62bf8610cfc7
β = 5

# ╔═╡ d652cece-cf1c-49cb-95a8-d738c09bb72e
γ = 4

# ╔═╡ 902af321-3d57-471a-bac4-6f8cb623cc56
β * γ

# ╔═╡ 4d5fd367-2e24-48e9-ae6e-19db2bfd4ae9
😄 = 2.0

# ╔═╡ ceb5c742-50bd-4b5c-a602-a04409a6609e
😎 = 3.0

# ╔═╡ 5572fc27-5309-457b-a1d0-e5de40480b61
😱😱😱 = 0.5

# ╔═╡ b7ac799b-089e-4ce1-b500-43ad7ca24651
😄/😎 - 😱😱😱

# ╔═╡ f53b054a-1e48-48b2-8d32-98e6c13f649b
md"""
!!! note "Mini-Exercise"
	The golden ratio is defined as
	$$\varphi = \frac{1+\sqrt{5}}{2}$$. Define a variable that contains this value in the empty cell below (if you want the greek symbol use the LaTeX command: `\varphi`).
"""

# ╔═╡ eef1613d-71d8-4b8f-9da6-3d823544cca8
# Define the variable here


# ╔═╡ bc0ee0b7-d7c9-4bfc-a939-272a5b92dfa4
md"""
!!! hint "Mini-Exercise: Solution"
	`φ = (1 + sqrt(5)) / 2`
"""

# ╔═╡ 2c4c92f2-6d33-4fc7-bacf-22827d8425ae
md"""
### If-else Statements

If-else statements are important to execute different parts of your program depending on whether certain conditions are met. They can have a single branch (this example) or multiple (see below)
"""

# ╔═╡ 7150fcb2-a663-4476-9eaa-d8686b4e91d6
begin
	julia_is_cool = true
	if julia_is_cool
		println("It sure is cool!")
	end
end

# ╔═╡ 4ffc9ba7-3aa3-4503-b976-c15479a18e1a
md"""
The code in a branch is only evaluated if the condition is `true`. The following code checks the sign of `x` and prints the result (in REPL).

Note that further up in the notebook we have defined x = $(x).
"""

# ╔═╡ 8df55f4f-4858-4c9e-b5c4-56c4ad5547e1
if x < 0
	println("x is negative")
elseif x > 0
	println("x is positive")
else
	println("x is zero")
end

# ╔═╡ 00a70c0a-c86f-46a4-9cff-3692c870a2c0
md"""
Note that if you want to check equality you need to use `==` not  just `=`. A single `=` is just for assigning values to variables.
"""

# ╔═╡ d025c063-8ce2-4862-9f0b-535a41e22729
if x == 0
	println("x is zero")
else
	println("x is not zero")
end

# ╔═╡ dfaf4d63-13cf-471c-b17c-2b3ded20f345
md"""
If you want to negate a statement you can use `!`
"""

# ╔═╡ 9a9a004e-7a3b-4a1a-a4e7-c4d6940e84cf
if x != 2
	println("x is not equal 2")
end

# ╔═╡ 1c2b5bf7-b82e-461b-a572-e3cb4b45b645
md"""
or this works too
"""

# ╔═╡ e9a30b8b-d6d9-498a-8b7d-b22533a63073
if !julia_is_cool
	println("Julia is not cool!")
end

# ╔═╡ 2f417def-0ea8-4ae5-896a-032b8ca0186e
Markdown.parse("""Note that the println line was not executed because Julia is cool... We have defined that `julia_is_cool = $(julia_is_cool)` further up in the notebook.""")

# ╔═╡ d14c2328-604f-4c6f-9afa-cb1879da4ef2
md"""
We have seen the comparison types when discussing Bools already. Here is the overview again
   
    ==		# equality
    !=, ≠	# inequality
    <		# less than
    <=, ≤	# less than or equal to
    >		# greater than
    >=, ≥	# greater than or equal to

Chaining comparisons is also possible
"""

# ╔═╡ a519fbae-c8b1-4d80-9a8a-7061e7df802c
if 0 < x < 3
	println("x is between 0 and 3")
end

# ╔═╡ 762d32eb-3802-409d-bba5-96a7cae78b41
md"""
We can also use the Boolean operators from the previous section
"""

# ╔═╡ 391a3da6-1a7d-4a33-bd6a-eada07bb4d2b
if 0 < x  && x != 3
	println("x is positive and not 3")
elseif x == -4  || x == -5
	println("x is is -4 or -5")
end

# ╔═╡ 7cc27fce-ea4f-47b2-a68f-f199b841b979
md"""
or check whether `x` is an element in a set
"""

# ╔═╡ 64f0751f-30af-4baf-b3c2-44a41a79d42c
if x in 1:10
  println("x is in range 1 to 10")
end

# ╔═╡ 89d9cdb0-4897-4909-ad15-eceffef84b7f
if x ∉ [2, 4, 7]
  println("x is not in the array")
end

# ╔═╡ 6196fcb4-8fff-426d-8426-0f15b7f8e056
md"""
### Ranges
Ranges or sequences of numbers can be defined as follows
"""

# ╔═╡ 2b7bfe8f-56f7-4697-a44d-a1d9781310af
let
	x = 1:10 	# Numbers from 1 to 10
	x = 10:-1:1 # Numbers from 10 to 1
end;

# ╔═╡ 6008ba43-bd57-4169-ac12-c7cfd351d5c2
md"""Ranges can also be defined as follows"""

# ╔═╡ 93bc41f8-2c44-4be2-9a3e-ababdec9bac4
let
	# 12 numbers equally spaced from 1 to 100
	x = range(1, length=12, stop=100)
	
	# Steps of size 10, starting from 1 stopping at or before 100
	x = range(1, stop=100, step=10)
end;

# ╔═╡ 8a883a8e-6816-4885-bac7-955a77595396
md"""Ranges are particularly convenient in `for` loops, which we will see next. They can also be used for array indexing which we will see later on."""

# ╔═╡ d1acb5b6-e4fa-4d6b-86b6-491e10a3dd24
md"""
### Loops

Loops repeat the same operations several times. Julia offers `for` loops and `while` loops
  * `for` loops go over each element of an iterable object (i.e. a range such as `1:10` or `["Julia", "Python", "Matlab"]`)
  * `while` loops execute the same code until the condition for their execution is not true anymore
  * Ultimately, both can be used to achieve the same results

The following goes over all integers from 1 to 10 and adds them to `x`

"""

# ╔═╡ 09b83b13-8f15-47d2-a9c7-0468e5daa04d
let 
	x = 0
	for i in 1:10
		x = x + i
	end
	x
end

# ╔═╡ eabd93e6-b91b-4b53-87fa-4fb00760f86c
md"""Mathematically, this corresponds to 

$$x = \sum_{i=1}^{10} i$$"""

# ╔═╡ 2930f321-9c3a-4d34-b010-1b8909072c49
md"""
But you can not only loop over numbers, e.g.
"""	

# ╔═╡ c15fee9d-551e-4428-ab7a-d61b3886bf07
let 
	programming_languages = ["Julia", "Python", "Matlab"]
	for x in programming_languages
		println(x)
	end
end

# ╔═╡ 84fec98b-dec0-45d9-a819-418b13ee1da4
md"""
`while` loops have a slightly different syntax

    while julia_is_cool
    	println("Yep, Julia is still cool. I just checked it.")
    end

Note the loop above would continue indefinitely.
"""

# ╔═╡ f8030e34-be48-466e-aebe-b021b68cf3cb
md"""There are also keywords which can be used to stop a loop prematurely (`break`) or skip iterations (`continue`)."""

# ╔═╡ 7b8d3b0f-a9f2-4d31-b401-9e576eb4a29f
for ii in 1:10
	
	if ii == 3
		continue
	end

	if ii == 8
		break
	end
	
	println(ii)

end

# ╔═╡ 25c225ce-006d-499c-bda2-5bb4a74df5e3
md"""Loops can also be nested"""		

# ╔═╡ ecc7a67f-2b85-4907-9f28-8eb219bec2f4
for i in 1:3
	for j in 1:3
		println("$i, $j") 
	end
end

# ╔═╡ 3d5f0217-a380-48fb-b6a7-20764ca9d34d
md"""or in a more compact way"""

# ╔═╡ 7705bb49-0769-4d20-8d89-7821a7331846
for i in 1:3, j in 1:3
    println("$i, $j") 
end

# ╔═╡ f5d3327f-430e-4144-9026-2c895c48d275
md"""A nested loop executes the whole inner loop (the one that loops over `j`) for each time the outer loop is executed."""

# ╔═╡ 6e07afd9-51c1-41d9-9aef-b65a74e843a8
md"""Some useful iteration utilities are given by the following example. But there are many more!"""

# ╔═╡ 530fa12c-f481-4304-a5e6-e89c93bfd4a5
let
	someArray = [3, 4, 5, 6, 7, 8, 9, 10]
	someArray2 = someArray.^2

	# Iterate through arrays of tuples using zipe
	for (elem, elem2) in zip(someArray,someArray2)
		println("$elem^2 is $elem2")
	end

	# Iterate through arrays and their indices using enumerate
	for (jj, elem) in enumerate(someArray)
		println("$elem^2 is $(someArray2[jj])")
	end
	
end

# ╔═╡ b50451f2-6e37-4ba3-a710-70a4c4d76987
md"""
!!! note "Mini-Exercise"
	Write a loop (either `for` or `while`) that prints 
	```
	1: Julia is cool!
	2: Julia is cool!
	3: Julia is cool!
	4: Julia is cool!
	5: Julia is cool!
	6: Julia is cool!
	7: Julia is cool!
	8: Julia is cool!
	9: Julia is cool!
	10: Julia is cool!
	```
	i.e. prints "Julia is cool!" with the number of the current iteration for 10 times.
"""

# ╔═╡ e077059d-9d49-4bb9-a149-5c6521fc6e03
let
	# Write your loop inside this let statement

end

# ╔═╡ f1fd9296-7e56-41c1-aeb1-8480ffc6e289
md"""
!!! hint "Mini-Exercise: Solution"

	A possible solution using a `while` loop could look as follows
	```
	ii = 1
	julia_is_cool = true

	while julia_is_cool
		
		println("$ii: Julia is cool!")

		if ii == 10
			julia_is_cool = false
		end

		ii += 1

	end
	```

	or like this
	```
	ii = 1

	while julia_is_cool
		
		println("$ii: Julia is cool!")

		if ii == 10
			break
		end

		ii += 1

	end
	```

	Using a `for` loop a possible solution could look as follows
	```
	for ii in 1:10		
		println("$ii: Julia is cool!")
	end
	```

"""

# ╔═╡ e970deb5-ac5c-4e7c-aa67-9179034440bf
md"""
### Functions

Functions return some output for given inputs. They are very useful to run small code sections that you need repeatedly in different parts of you program. 

The following defines a function that adds 2 to the input and returns the result
"""

# ╔═╡ 75e25f68-4528-497c-a67d-ff0361ffc6cb
function f(x)
	x + 2
end

# ╔═╡ bf6b53bf-4176-4a74-943a-cd16d9189e1c
md"""Simple functions as the one above could also be defined as follows"""

# ╔═╡ 447a7b0b-d73f-4996-a6c1-0b2c20624abe
f2(x) = x + 2

# ╔═╡ f4760bf4-005d-4aeb-ac68-7a75f2545e5b
md"""So, the function received input 4, added 2 and returned 6."""

# ╔═╡ a031c7d6-2b88-4c92-a6c2-f977f250bc8d
md"""Functions can also have multiple inputs and outputs"""

# ╔═╡ ded072f9-7ecd-4036-9159-e1a31e45bca4
function f(x, y)
	a = x + y
	b = x - y
	return a, b
end

# ╔═╡ f440de63-3b02-4c2c-b7d2-f07cac35428c
Markdown.parse("""
Once we have executed the code above, f(x) can be called in REPL or anywhere in your program. For example, in REPL we would get the following output

    julia>f(4)
    $(f(4))

Or in this Pluto notebook, we get
""")

# ╔═╡ 05f601af-8bc1-4d64-a9dd-015a9bb39123
f(4)

# ╔═╡ 0258a629-33c1-4179-8cb7-69db6017dd4c
md"""Note here we explicitly used the `return` keyword. If no `return` keyword is used, the function returns the result of the last line. In this case it would return `b` only. Consider the following example"""

# ╔═╡ 3914f52e-a80f-463d-9751-983cd39957c3
function functionWithReturn(x)
	a = x^2
	b = x
	return a, b
end

# ╔═╡ c1beed77-ecc6-4d6d-8754-f2c5dbddfdb0
function functionWithoutReturn(x)
	a = x^2
	b = x
end

# ╔═╡ d8bdf8c9-abed-4700-addd-3acfd2381ab2
functionWithReturn(4)

# ╔═╡ 3af480c9-fea2-443f-9509-22687ffda887
functionWithoutReturn(4)

# ╔═╡ ad429462-1492-4dfc-a740-434c81ac6984
md"""We can also assign the output of the function to separate variables"""

# ╔═╡ e6e0dfdc-3e3e-4a0d-9faa-c14d3207a835
a, b = f(4, 2)

# ╔═╡ e48641e0-d9ac-4661-a570-421c1b56c4e8
a

# ╔═╡ ba21bc85-f4a3-40b0-a656-51c2ca7b4969
b

# ╔═╡ 46f0f6f7-bbce-4ce8-ba53-4b361c1951c7
md"""If you don't need all function outputs, you can use underscore as a place holder"""

# ╔═╡ a268554a-e2a5-4707-8313-fa3aa06d6428
_, c = f(4, 2)

# ╔═╡ 9ef74a99-3ee9-45c7-b99d-8105de2e6d8c
c

# ╔═╡ ae9f6624-6ed8-488c-bb76-e34215fe541f
md"""Functions can have optional arguments"""

# ╔═╡ 8b3fc2c8-6eb0-4132-baac-355ebcefebe8
function fopt(x, y = 2)
  x + y
end

# ╔═╡ 25ae6f62-70bf-4216-9dc3-902def9421a3
md"""Keyword arguments are also supported"""

# ╔═╡ 133118b2-e417-48b7-9bd9-981c200502b1
function fkey(x; y = 2)
  x + y
end

# ╔═╡ fbfb8d54-4cd8-4d17-83bf-c08ef3028e1c
md"""
Whats the difference? Calling the functions in REPL you get

    julia>fopt(4)
    6
    julia>fopt(4,5)
    9
    julia>fkey(4)
    6
    julia>fkey(4; y=5)
    9
    julia>fkey(4,5)
    ERROR: MethodError: no method matching fkey(::Int64, ::Int64)

Keyword arguments always need the keyword (but multiple keywords can be specified in any order) while optional arguments do not require the variable name (but multiple optional aruments need to be supplied in the correct order).
"""

# ╔═╡ e492b961-f633-4368-b965-a47c9d65eea6
md"""Functions can refer to variables that are in the scope when the function is called. For example,
"""

# ╔═╡ 84a9374e-867b-434e-8d73-12178e0661b5
let
	add_a(x) = x + a
	a = 5
	println(add_a(2))
	a = 10
	println(add_a(2))
end

# ╔═╡ f0106275-ff20-478f-9834-f531bc53eb9a
md"""Note that `a` does not need to be defined when the function is defined, only when the function is called. Furthermore, `a` needs to be defined in the same scope as the function.

We will have closer look at scoping rules later in the course"""

# ╔═╡ f6864464-e641-49be-afa6-5088f1a66102
md"""
!!! note "Mini-Exercise"
	Write a function named `fibonacci` that takes argument `n`. The function should print all the numbers of the Fibonacci series up to the `n`th number.

	The Fibonacci series is defined as $x_n=x_{n-1} + x_{n-2}$ with initial values $x_1=0$ and $x_2=1$.
"""

# ╔═╡ 89343aa4-926f-4690-9357-08fb897e9f6e
function fibonacci(n)
	# Write your code here
end

# ╔═╡ d3e505bb-2e2e-490f-bfcd-513cae530d7a
fibonacci(10) # Test your code here

# ╔═╡ e9162052-70dc-4dfd-a9b9-fad1a556d4ca
md"""
!!! hint "Mini-Exercise: Solution"
	One way to solve the exercise is as follows
	```
	function fibonacci(n)
	
		# Define the initial values
		a1 = 0
		a2 = 1
	
		# Print the initial values
		println(a1)
		if n >= 2
			println(a2)
		end

		# For n > 2, we use a loop to compute the elements of the series
		for ii in 3:n
	
			# Compute and print the next value in the series
			nextValue = a1 + a2
			println(nextValue)
	
			# Update the current summands
			a1 = a2
			a2 = nextValue
			
		end
		
	end
	```
"""

# ╔═╡ bc2c1fa6-377c-4400-a557-674d9d45b994
md"""
## Data Structures

### Arrays
In principle, you know enough already to represent (almost) any kind of data in your program. However, it would be very tedious to do so using only primitive types (Integers, Floats, etc.) for large amounts of data.

A convenient way to represent large amounts of data in code are arrays. They can have an arbitrary number of dimensions
  * A one-dimensional array is also called a vector:  `x = [1, 2, 3]`

    Mathematically, we would write this as $x=\begin{pmatrix}1 \\2\\3\\\end{pmatrix}$
  * A two-dimensional array is also called a matrix: `x = [1 2; 3 4]`

    Mathematically, we would write this as $x=\begin{pmatrix}1 & 2\\3 & 4\\\end{pmatrix}$
  * An $N$-dimensional array is most easily constructed using loops

"""

# ╔═╡ e675d2bb-18ef-40e8-a64e-d04db73ee1b4
md"""
Technically, a vector in Julia is neither a column nor a row vector. However, in certain situations (e.g. matrix multiplication) in can act as a column vector. Note that a matrix can have dimension $1\times 3$ but it would not be a vector in Julia.

For example

    x = [1, 2, 3] 	# vector
    y = [1 2 3] 	# 1x3 matrix
    z = [1 2 3]' 	# 3x1 matrix
		
You can see this when calling the typeof(x) function

    julia>typeof(x)
    Array{Int64,1}

    julia>typeof(y)
    Array{Int64,2}

    julia>typeof(z)
    Array{Int64,2}
	
`y` and `z` are matrices, while `x` is a vector. This is different from Matlab where essentially everything is a matrix.

Try it for yourself
"""

# ╔═╡ 1120b98d-4895-4181-b8f2-8f9bebdecad9
let 
	x = [1, 2, 3] # Try changing the definition of the vector
	typeof(x)
end

# ╔═╡ 4106b5ca-8a2d-4ce3-8f97-99ee35235bf2
md"""Accessing the elements of an array can be done in multiple ways. Consider the following matrix"""

# ╔═╡ 5cbfbbd7-8416-411f-9256-d81ee776e1ab
X = [1 2; 3 4]

# ╔═╡ 88313219-165c-463d-93c3-9327bf5fb8d6
X[1, 2] # element in the first row and second column

# ╔═╡ be5aa897-45ec-44b7-9cdd-9e307d19eecb
X[2] # second element when all columns are stacked on top of each other

# ╔═╡ 45c1a4b1-e7e5-4746-bef1-ac7cd23799e3
md"""The way you access arrays is quite important for speed when you loop over arrays (Linear indexing `X[2]` is faster, in general, because it takes into account how the arrays are represented in memory). 

However, linear indexing is not suitable in some applications. Note that this is generally faster"""

# ╔═╡ 94e6baf1-8c63-49ab-a177-d984345f93da
function fastloop(X)
	for j = 1:size(X, 2), i = 1:size(X, 1)
  		X[i, j] = i + j
	end
end

# ╔═╡ e81af480-6dc9-43f6-8e27-cc0c3038ac6f
md"""than this"""

# ╔═╡ ece90524-ea14-42f7-a1d0-550e35b4cca6
function slowloop(X)
	for i = 1:size(X, 1), j = 1:size(X, 2)
		X[i, j] = i + j
	end
end

# ╔═╡ 39f3226d-7b31-4b5b-81e5-08e01603b0b4
let 
	N = 10 # Note you might need to increase N to 1000 or more to see substantial differences
	x = zeros(N, N)
	@btime fastloop($x)
	@btime slowloop($x)
end

# ╔═╡ f66bfeb6-129f-488e-8044-048446c74119
md"""This is because Julia is using column-major order to store arrays in memory."""

# ╔═╡ 0b46913d-fdcf-4ff0-8bab-e4835799d55c
md"""

#### Mathematical Operations on Arrays

Mathematical operations are similar to those for primitive types. However, `*` does matrix multiplication for 2 dimensional arrays.
"""

# ╔═╡ 579ebaf4-cfb2-44f1-8765-c9800233ab06
[1 2; 3 4] * [2 3; 4 5]

# ╔═╡ e50fb2e8-eab7-491f-ab96-2ea3c27e3184
md"""
Note if you need to transpose a matrix or a vector you can use `x'`.
"""

# ╔═╡ 7c3bab34-afab-41d1-bfe0-8705473f8302
[1 2; 3 4]'

# ╔═╡ 456f9d2e-7383-4aec-a472-fe64ee592359
md"""Elementwise operations are possible by using the dot-notation e.g., `.*`""" 

# ╔═╡ 7ce559f7-69b2-4b23-aa3c-93206c0d0b92
[1 2; 3 4] .* [2 3; 4 5]

# ╔═╡ 72663333-9693-418e-bb05-0317f496d531
[1 2; 3 4] .+ [2 3; 4 5]

# ╔═╡ c6f8e7a4-f9b5-4fb5-8a14-5d244e49a417
[1 2; 3 4] ./ [2 3; 4 5]

# ╔═╡ aed9b174-7d5d-4078-96d8-ea86a738519e
[1 2; 3 4] .^2

# ╔═╡ 6dec3c28-e609-4054-bcb6-e9fcea8da548
md"""Generally, dots are used to apply operations or even functions elementwise. For example"""

# ╔═╡ 5cc953a2-20f6-4ebe-8e00-71ff88772f42
log.([1 2; 3 4])

# ╔═╡ 76f00652-bf7c-46bc-b953-69d9f5bf8f05
md"""We will see how it works for functions more generally later on."""

# ╔═╡ 58148875-b8f4-42ab-b813-be9ab3e8ea17
md"""
#### Initialize Arrays
Often times you will need to Initialize arrays in your code. You can do this in several ways
"""

# ╔═╡ 1198b520-0f74-4cfb-9207-78b662a72316
zeros(3, 2) # Array of zeros with dimensions 3x2

# ╔═╡ 6f0e4929-c08b-45f5-b62e-9c90b0f5f941
ones(10)	# Works analogous to zeros()

# ╔═╡ bf63372b-dd34-47fb-beb6-bb098282d243
fill(2, 3)	# Vector with 3 elements and fills it with 2

# ╔═╡ e9a0a938-76fb-4adb-887f-9bb3f66799a8
Array{Float64}(undef, 2, 2) # 2x2 matrix with undefined elements of Float64

# ╔═╡ 87b4621b-9059-47b1-aa39-8216345e32d2
md"""
Copying or making similar arrays can be done as follows
"""

# ╔═╡ 402d2bab-43ec-4cd0-974e-cebfabfc9be8
let 
	x = zeros(2, 2)
	z = similar(x) # Array with same dimensions and type as x
end

# ╔═╡ 8c5c2454-82ed-4fbf-85bb-0ef7074db1ad
md"""Note that z does not contian the same numbers as x in this case. Just the type and dimensions are the same. If you need an exact copy you can use"""

# ╔═╡ ef752a5f-32c2-46dc-a21e-fae1bfcde738
let 
	x = zeros(2, 2)
	z = copy(x) # Creates exact copy of y
end

# ╔═╡ 418d8d90-4dcd-45d5-930f-f7ee41190b90
md"""Be careful, the following does not create a copy of an array"""

# ╔═╡ 9ea74934-91a8-4f7e-8227-19f4d7f79cf2
let 
	x = zeros(2, 2)
	y = x # This does not make a copy! x and y refer to the same object in memory
	y[1] = 3.0 # This changes the first element of both x and y
	
	display(x)
	println("")
	display(y)
end

# ╔═╡ d2269b8a-17d8-4b1b-9d73-a7c561e8935f
md"""
!!! note "Mini-Exercise"
	Let a Markov chain transition matrix be defined as

	$$\Pi = \begin{pmatrix} 0.9 & 0.1\\ 0.1 & 0.9\end{pmatrix}\,.$$

	The stationary distribution of a Markov chain can be computed by iterating on

	$$P_{n+1} = \Pi' P_n$$

	until convergence with $P_0$ being a $2\times 1$ vector with elemnts that sum up to 1.

	Suppose $P_0=(0.1, 0.9)'$. Write a loop to compute $P_{100}$ which should be close to the stationary distribution.
"""

# ╔═╡ d92784a6-1c18-484e-929b-90cbb09e5e74
let 
	# Write your code inside this let statement
end

# ╔═╡ 2f27b2b1-5b5e-486c-80b1-0821b1a2f201
md"""
!!! hint "Mini-Exercise: Solution"
	One way to solve the exercise is as follows
	```
	P = [0.1, 0.9]
	Π = [0.9 0.1; 0.1 0.9]
	for ii in 1:100
		P .= Π' * P
	end
	P
	```
	The stationary distribution of the Markov chain is $P_\infty=(0.5,0.5)'$.
"""

# ╔═╡ 508c3e77-f5f0-4af7-9653-ebe10b9c967f
md"""
#### Tuples

Tuples are another important data structure

    x = (1, 2, 3)

Contrary to arrays they are immutable and always unidimensional
  * Once they are created, you cannot change them anymore
  * Elements can be accessed as follows x[2]

Functions inputs and outputs are technically tuples. We have seen them before.

You can unpack tuples 

    a, b, c = x	# Now, a has value 1
    			# b has value 2, and
    			# c has value 3

if it's more convenient to work with the individual values. This is what we have been doing for functions with multiple return values
"""

# ╔═╡ d75ecae9-eb7c-4db7-8fb1-43bee603ab29
let
	x = (1, 2, 3)
	a, b, c = x
	x[1] + c
end

# ╔═╡ bb04286d-93a8-4db8-96b5-d1731e8d6a76
md"""
### Named Tuples

Named tuples are an extension to the basic tuple

	x = (a = 1,  b = 2, c = 3)

Named tuples can be accessed in two ways

	julia>x[2]
	2

	julia>x.b
	2

Particularly convenient to collect program settings into a single variable
"""

# ╔═╡ b316eb5c-5dac-402e-8cfc-165a5a51287e
let
	x = (a = 1,  b = 2, c = 3)
	x[1] + x.c
end

# ╔═╡ f91ec02d-406c-4beb-ba72-10997fbf644e
md"""
### Dictionary
A dictionary is an unordered collection of keys and values
"""

# ╔═╡ 7b79d4f7-a56d-4001-8dcb-f83b515dd155
mydict = Dict("Name" => "Paul", 
	 "Phone" => 1235, 
	 "Job" => "Economist")

# ╔═╡ 9382e8d6-4add-4a8f-ac54-2e98b874ad5e
md"""`"Name"`, `"Phone"`, and `"Job"` are the keys. `"Paul"`, `1235`, and `"Economist"` are the values. Note that the keys in a Dictionary must be unique. The values don't have to be unique, however. They can be accessed as follows
"""

# ╔═╡ 604645f8-7eae-4dff-bd58-e77677c00712
mydict["Name"]

# ╔═╡ de324773-9e8d-4acd-9697-80833700229a
mydict["Job"]

# ╔═╡ 459d0320-8e18-43da-a16e-6477ce7d53bd
md"""You can add new entries and change existing ones"""

# ╔═╡ 662ca890-9441-4970-b26a-2d0d6a07118b
mydict["Phone"] = 4536 	# Updated the phone number

# ╔═╡ 8fb85b52-07ee-4822-9c61-9fdd58d0c1d2
mydict["Age"] = 50		# Adds new key-value pair

# ╔═╡ 2598c920-212f-4d5c-8072-d1b0234158bf
mydict

# ╔═╡ 16fc50da-188c-4870-8ba8-c2b20a83b11d
md"""
Things to keep in mind
* To access the keys of a dictionary you can use `keys(x)`
* A dictionary is similar to a named tuple in a sense. However, dictionaries are mutable while named tuples are not
* Thus, if you need to be able to add new keys and change values, dictionaries are the right choice
* Also, always remember that the dictionary is unordered. You cannot count on the key-value pairs being in the same order as at the time you created the dictionary
"""

# ╔═╡ aa70a868-0ecb-41c7-89b0-224e434a776e
md"""
### Comprehensions

Comprehensions can be used to generate new arrays or dictionaries from iterables. For example, the following generates the vector $[2, 4, 6, 8]$
"""

# ╔═╡ 71597e9b-5fe7-4f18-8657-c4b6845af3b4
[2*i for i in 1:4]

# ╔═╡ c6986e34-16e5-4b55-8679-a742ca25abc7
md"""This is shorthand for the following"""

# ╔═╡ 570c355b-a26a-4ee3-be12-672f7afd1a4c
let
	x = zeros(Int64, 4)
	for i in 1:4
		x[i] = 2*i
	end
	x
end

# ╔═╡ 5f121bbc-3e4c-49b4-a29d-48640c41e385
md"""Some more examples"""

# ╔═╡ 16b75163-3dae-4213-8e56-52a1314bd3c3
let 
	animals = ["dog", "cat", "bird"]
	plurals = [animal * "s" for animal in animals]
end

# ╔═╡ ede5dfb3-a0ce-4367-aa34-8fd5e964cefb
Dict(string(i) => i for i in 1:3)

# ╔═╡ 4f6ee5f4-ed15-4a56-b847-c59c4ce7d26b
md"""
## Digging Deeper

### Variable Scope

Variable scope determines where variables are accessible. For example, a function creates a new local scope: Variables created there are not be accessible outside the function.

Variables created in REPL are available globally (global scope). These variables are accessible everywhere in your program. Global variables may seem convenient, but they have drawbacks
  * Huge performance costs because the compiler cannot specialize the code related to that variable anymore (type might change any time)
  * Code becomes harder to understand
  * More difficult to track down bugs

The the performance cost can be remedied by using the `const` keyword in front of variable definitions in global scope. However, it remains advisable to avoid global variables if possible.
"""

# ╔═╡ 333886ef-34b5-445a-b365-ac04db35edf0
md"""

The following create local scopes
  * `for`, `while`, `try-catch-finally`, `let`
  * `function`
  * (mutable) `struct`, `macro`
  * comprehensions, broadcast-fusing

Consider the following example of a loop
"""

# ╔═╡ 17c64615-d704-48f3-b5c4-59209265dbaf
let 
	for i in 1:10
		zz = i
	end
	zz
end

# ╔═╡ 825b252e-de2a-47a6-aabc-aa79e01c33a8
md"""`zz` was created inside the local scope of the loop. It is not accessible outside this scope. However, if we create the variable before the loop, we can access it after the loop has finished."""

# ╔═╡ 12807fbb-7d63-4d11-8364-fc74294c9fb8
let 
	zz = 1
	for i in 1:10
		zz = i
	end
	zz
end

# ╔═╡ 19c9aeab-78b8-48ef-b582-09d170468a3a
md"""This works analogously for functions, etc."""

# ╔═╡ 72c02726-a582-47d6-bf61-cba00eee7821
md"""

### Modules

Modules are libraries (or packages) that extend the functionality of Julia.
		
You can use a module in your program with the `using` keyword. For example,

	using Plots # provides plotting functionality
	using Interpolations # provides functions for interpolation

Once a module is loaded you can use the functions which it provides.
"""

# ╔═╡ 98713afb-56d2-4171-95a0-7352ee5b5fb0
plot(1:3, title = "My Plot")

# ╔═╡ 7681d446-72ed-47fa-90b8-a40548ccba60
md"""
Alternatively, there is the `import` keyword, which also makes the functions accessible but you need to use the module name in front of the function

	Plots.plot(x, title = "My Plot")

It is more common to use `using`. However, there might be situations where modules provide functions that conflict (i.e. have the same name and inputs). In such cases you need to use `import`.	
"""

# ╔═╡ a7f82af2-6800-47f2-ac4d-bf6b2b9e8ced
md"""
How can you install new modules? One way is to load the `Pkg` 
module first

	using Pkg
	Pkg.add("Plots")

Alternatively, you can switch the REPL into the package manager mode

	julia>]
	(@v1.7) pkg>add Plots

Which one you use is mainly a matter of preference. 

It is also possible to write your own modules but this goes beyond the scope of this course.
"""

# ╔═╡ 4f13846b-ac51-4b12-ae50-adf60be86b89
md"""

### Random Numbers

Julia can also generate random numbers (or, more accurately, pseudo-random numbers).
		
Uniform random numbers

	x = rand()			# random scalar between 0 and 1
	y = rand(3,2)		# random matrix with iid elem. between 0 and 1
	z = rand(3)			# random vector with iid elem. between 0 and 1
	
Random integers in a certain range

	x = rand(1:5)		# random integer from 1 to 5 

Normally distributed random numbers

	x = randn()	    	# random scalar x ~ N (0, 1)
	y = randn(3,2)	    # random matrix with iid z_i ~ N (0, 1)
	z = m + s * randn() # random scalar z ~ N(m, s^2)
		    			# mean m and standard deviation s

To get the same random numbers everytime you run your program, use

	using Random        # Load the Random module
	Random.seed!(1234)  # Set the random seed to 1234

"""

# ╔═╡ 1ed4b714-fa4f-4978-9f8c-c2cd6b34db59
rand(5, 5)

# ╔═╡ 5097f20e-ab19-4fed-b380-08d851d0710c
randn(5, 5)

# ╔═╡ d3ff91e8-2186-4aa7-9fe8-6d4f163c2c21
rand(1:10, 5, 5)

# ╔═╡ 0b4e8789-ff6d-401c-b5b4-867c4d83c542
md"""

### Broadcasting

Often you want to apply a function to each element of an array. Julia provides an easy way to "broadcast" any function
"""

# ╔═╡ f9f328cf-4411-42b9-bcd2-8e257ca646dc
sin.([2, 3, 4])

# ╔═╡ 6f9a0393-ccf1-4831-90bf-4b0644cb8b6a
md"""The code applies the  `sin` function to each element of the array. Any function that works on scalars can be broadcast using the dot notation."""


# ╔═╡ 4e222e1e-6e38-446d-9d07-84b9f4da638a
md"""
With multiple inputs you need to be careful that the input arrays have the same dimensions or they are compatible with each other. Consider the following example
"""

# ╔═╡ 12f243bd-c7af-46ff-9e38-f4aa08d86cf8
g(x, y) = x + y

# ╔═╡ 8c5b34fe-5920-43d3-bf1a-bfe824132971
aa = [2 3 4 5] # 1x4 matrix

# ╔═╡ 77bbee9d-6d7d-47fb-a1d0-ea2a17fc3d7e
bb = [5, 1, 4] # 3 element vector

# ╔═╡ ee49888c-7e7a-4c12-80b7-ae5fe79e89c5
md"""i.e. we have a row vector and a column vector. Broadcasting on them yields a 3x4 matrix"""

# ╔═╡ 684bcd7d-3d3c-4285-a721-630bec7c07ee
g.(aa, bb)

# ╔═╡ a3743464-295d-4dba-8c97-1a1a0b9fa7c1
md"""

## Recap

Now, you know enough to write almost any program you can imagine. However, there is still much more to get to know about Julia. For example, we have skipped
* `try-catch-finally` blocks,
* (mutable) `struct`,
* `macro`s,
* multiple dispatch,
* parallel computing,
* and many more that even I don't know about

Some of them make Julia stand apart from other languages. We will have quick look at some of them in Advanced.jl later on if time allows.
"""	

# ╔═╡ c6aa0cd7-abbe-4de1-8440-011e5d1037f7
md"""

## Structuring Your Program

Organizing your program is essential to good programming. Julia does not impose much structure. However, as your program grows, it makes sense to 
* collect similar functions in separate Julia files and load them from your main file (or from a script) using `include("myfunctions.jl")`, or 
* build your own modules that provide the functionality you need

For the people familiar with Matlab, note that
* it is uncommon to have a separate files for each of your functions, 
* there is no built-in functionality to load all files from a directory, and
* to automatically reload edited functions you need to use Revise.jl

"""

# ╔═╡ 5a175020-eb3a-49da-866d-eb0d77d7b4b3
md"""
Generally, it is good practice to
* Make sure the program reflects the underlying Economics of the problem
* Plan the code structure before typing it into the editor
* Increase code readability by means of comments (`#`) and indentation 

When planning your code, it is helpful to think about the following
* What are the inputs (e.g. data, settings) and outputs (e.g. estimated parameters) of your program?
* How can the inputs and outputs be represented in Julia?
* Which steps are required to get from the inputs to the outputs?
* What do these steps have in common?
* How can the steps (or parts of them) be represented by functions, etc.?

> "Weeks of programming can save you hours of planning." -- Unknown
"""

# ╔═╡ 1b9c0bd7-82ff-4a62-b5a9-6e5c86a489e5
md"""

Particularly useful to take advantage of some more advanced concepts
* Types and their constructors
  * Simple vs. composite types
  * Concrete vs. abstract types
  * Parametrized types
* Methods and multiple dispatch
* Advanced.jl contains some examples
		
While these concepts can be important for fast and easily maintainable code, don't get overwhelmed. You can go a long way with the basics. Learning to program well is something that cannot be learned in just a few hours. It requires a lot of practice and experience.

"""

# ╔═╡ b78484d2-8c6e-4305-8553-9e87abdfa0e7
md"""

## Applications

In the following we will have a look at some longer codes that apply what we have seen before. When starting to program, it can be very useful to start from someone else's code and experiment with it. In addition to learning how to apply our freshly acquired knowledge, we will learn how to
* create plots using Plots.jl, 
* save and load results using BSON.jl,
* load real data with CSV.jl

The focus of these applications is on the programming part and not the economics.
"""

# ╔═╡ b9e8dee5-326c-4daf-b41b-c49f11577994
md"""
### AR(1) Process - Simulation

Consider an AR(1) process of the form

$$x_t = \rho x_{t-1} + \varepsilon_t \qquad t=2,...,T$$
		
where $\varepsilon_t ~\sim N(0, \sigma^2)$ and initial value $x_1 = 0$
		
Our goal is to
* write a function that simulates an AR(1) process for given $\rho$, $\sigma$, and $T$,
* compute some statistics related to the simulation, 
* plot the results, and
* save the simulated data

Don't worry if you haven't studied autoregressive processes yet. You don't need to understand any of the theory behind it.

The code can be found in `ApplicationAR1Process.jl`.
"""

# ╔═╡ b8b3aeec-2211-4158-8975-3c2ea9755105
md"""
### AR(1) Process - Estimation

The formula for the process looks very similar to a typical linear regression

$$x_t = \rho x_{t-1} + \varepsilon \qquad t=2,...,T$$

Regressing $x_t$ on $x_{t-1}$ indeed yields a consistent (but biased) estimate for $\rho$.

Our goal is to
* load the simulated data,
* estimate the coefficient $\rho$, and
* compare the results to our true values

To familiarize ourselves with arrays, we will not use any external packages for OLS in this example. If you are interested in running more complex regressions have a look GLM.jl which provides an easy interface.

The code can be found in `Applications/AR1Process.jl`.
"""

# ╔═╡ 832d81b2-7484-4e81-83a1-37984bf3ce3d
md"""

### Hodrick–Prescott Filter

In macroeconomics we are often interested in extracting the cyclical component of a time series. The Hodrick–Prescott filter does this in a purely statistical way

$$\min _{\tau}\left(\sum_{t=1}^{T}\left(y_{t}-\tau_{t}\right)^{2}+\lambda \sum_{t=2}^{T-1}\left[\left(\tau_{t+1}-\tau_{t}\right)-\left(\tau_{t}-\tau_{t-1}\right)\right]^{2}\right)$$
	
where $\tau_t$ is the unobserved trend component and $y_t$ is the observed series.
					
Our goal is to
* load the real data on output (i.e. GDP),
* filter the series using the Hodrick–Prescott filter, and
* display the results

The first order conditions of the minimization problem can be written as

$$\underbrace{\begin{pmatrix}
1+\lambda & -2\lambda & \lambda & & & & \\
-2\lambda & 1+5\lambda & -2\lambda & \lambda & & & \\
\lambda & -2\lambda  & 1+6\lambda 	& -2\lambda & \lambda & &  \\
 	& \ddots  		 & \ddots			& \ddots		 & \ddots  & \ddots & \\
 	& & \lambda & -2\lambda  & 1+6\lambda 	& -2\lambda & \lambda \\
 	& & & \lambda & -2\lambda & 1+5\lambda & -2\lambda \\
 	& & & & \lambda & -2\lambda & 1+\lambda
\end{pmatrix}}_{\Gamma} \underbrace{ \begin{pmatrix}
\tau_1 \\
\tau_2 \\
\tau_3 \\
\vdots \\
\tau_{T-2} \\
\tau_{T-1} \\
\tau_{T} \\
\end{pmatrix}}_{\tau} = \underbrace{ \begin{pmatrix}
y_1 \\
y_2 \\
y_3 \\
\vdots \\
y_{T-2} \\
y_{T-1} \\
y_{T} \\
\end{pmatrix}}_{ y}$$

Note that most elements of $\Gamma$ are zero, i.e. $\Gamma$  is sparse. There are very efficient routines to solve large linear systems of equations with sparse matrices.

The code can be found in `Applications/HPFilter.jl`.
"""

# ╔═╡ 6363098f-7810-43ad-8d5d-76901a24a0d0
md"""
## Basic Advice for Programming in Julia

* Julia is only fast within functions. If possible, avoid global scope
* Write type-stable functions for best performance 
  * `@code_warntype` is a useful macro to check for type stability
  * Somewhat related: Time your functions (with the `@time` macro) and watch out for high numbers of allocations. This can be a performance killer too
* Define composite types as logically needed
* Take advantage of multiple dispatch to write code that resembles math
* Add methods to existing functions for your custom types
* While it is easy to translate Matlab code to Julia 1:1, you need take special care of type stability, etc. to get code that is actually faster than Matlab

"""

# ╔═╡ be04e7a7-2955-4100-853c-cecba54019b3
md"""

## Concluding Comments

You know how to write basic programs in Julia now. Congratulations!
		
There is still a lot left to learn and to become good at programming requires a lot of practice. However, I think that programming is one of the most useful skills that you can acquire in your studies (no matter whether you want to do a PhD or work in the industry).

"""


# ╔═╡ 9b02f32d-aa48-4c7f-8984-d998735e4187
md"""

## Additional Resources

* TechyTok!: [https://techytok.com/from-zero-to-julia/](https://techytok.com/from-zero-to-julia/)
  * Excellent tutorial that goes into more detail than we will be able to
* QuantEcon: [https://julia.quantecon.org/](https://julia.quantecon.org/)
  * Provides great lectures that start from the very basics of Julia
  * Many economic applications
* Julia Documentation:  [https://docs.julialang.org/](https://docs.julialang.org/)
  * Very clear and well organized
  * Performance tips: [https://docs.julialang.org/en/v1/manual/performance-tips/](https://docs.julialang.org/en/v1/manual/performance-tips/)
  * Noteworthy Differences from other Languages: [https://docs.julialang.org/en/v1/manual/noteworthy-differences/](https://docs.julialang.org/en/v1/manual/noteworthy-differences/)
    * If you have experience in either Matlab, R, Python or C/C++, it's a good idea to have a look at the respective section
* Plotting with Julia
  * Plots.jl: [http://docs.juliaplots.org/](http://docs.juliaplots.org/)

"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"

[compat]
BenchmarkTools = "~1.3.1"
FileIO = "~1.14.0"
ImageIO = "~0.6.6"
ImageShow = "~0.3.6"
Plots = "~1.31.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.3"
manifest_format = "2.0"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "69f7020bd72f069c219b5e8c236c1fa90d2cb409"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.2.1"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "4c10eee4af024676200bc7752e536f858c6b8f93"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.1"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "2dd813e5f2f7eec2d1268c57cf2373d3ee91fcea"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.1"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "924cdca592bc16f14d2f7006754a621735280b74"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.1.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Contour]]
git-tree-sha1 = "a599cfb8b1909b0f97c5e1b923ab92e1c0406076"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.1"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "9267e5f50b0e12fdfd5a2455534345c4cf2c7f7a"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.14.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "c98aea696662d09e215ef7cda5296024a9646c75"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.4"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "3a233eeeb2ca45842fe100e0413936834215abf5"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.4+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "342f789fd041a55166764c351da1710db97ce0e0"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.6"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "b563cf9ae75a635592fc73d3eb78b86220e55bd8"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.6"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "891d3b4e8f8415f53108b4918d0183e61e18015b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "1ea784113a6aa054c5ebd95945fa5e52c2f378e7"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.7"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9a36165cf84cff35851809a40a928e1103702013"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.16+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "e925a64b8585aa9f4e3047b8d2cdc3f0e79fd4e4"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.16"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "9888e59493658e476d3073f1ce24348bdc086660"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "93e82cebd5b25eb33068570e3f63a86be16955be"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.31.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "9f8a5dc5944dc7fbbe6eb4180660935653b0a9d9"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.0"

[[deps.StaticArraysCore]]
git-tree-sha1 = "66fe9eb253f910fe8cf161953880cfdaef01cdf0"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.0.1"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "2c11d7290036fe7aac9038ff312d3b3a2a5bf89e"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.4.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "48598584bacbebf7d30e20880438ed1d24b7c7d6"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.18"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "ec47fb6069c57f1cee2f67541bf8f23415146de7"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.11"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "Mmap", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "fcf41697256f2b759de9380a7e8196d6516f0310"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.6.0"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78736dab31ae7a53540a6b752efc61f77b304c5b"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.8.6+1"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─186958e8-dbd1-4bbf-94d1-10f9de56b083
# ╠═ab1cffca-efd5-11ec-1d46-67a055f03758
# ╟─1ddf5456-0cdf-481b-a378-6fad6482ccff
# ╟─99a749a1-4b2a-40e9-b06e-71e378e44fc2
# ╟─d2343252-6f80-4a29-9b70-11b323c9deec
# ╟─c4bcecbb-b068-4ff1-8b1b-27cfe50a7b23
# ╟─e16c0130-ee3f-43eb-9f78-73788a51cf7c
# ╟─f927d9f6-c951-47b5-86f2-151b8f9cb555
# ╟─06e11828-2c21-4d03-b598-05f69cebcd51
# ╟─eaa545df-d2bb-4151-9430-4ad67011602d
# ╟─a108df01-11d0-4bd0-ba5b-7f752649ad68
# ╟─995ddb34-a779-40a9-be54-2f159d862e8a
# ╟─fa070ccb-0751-4f31-b130-46ded46cf83d
# ╟─66de4aac-9738-4729-aaa0-c3e5491272dd
# ╟─f3813785-ad23-4b5d-942a-ee6c4ca1b377
# ╟─0faed82c-589b-44a1-9ea4-82e3bab492a5
# ╟─1509eff9-3ab2-4dfe-a78f-aff3754da8d8
# ╟─16033d7b-e4aa-47f4-a79a-897f2599ae4c
# ╠═2b6cda5e-442c-4880-820b-a58d333ba307
# ╠═edf7dfc5-8325-418b-b3cd-23f568f061d1
# ╟─8d0125b6-4c83-43e2-8e69-86ac69d5e511
# ╠═97b45c4f-b527-4b07-99e6-b3c6c76c58f5
# ╟─353435cb-2f85-475f-93ba-eb1d170b2956
# ╟─abc20cde-f4bd-41ef-bcc1-60371e99829d
# ╠═05291062-9836-4f9b-a4b1-8a5e88ae17b3
# ╟─f5bab507-5a8f-4248-83f3-5556b2fbf771
# ╠═8962a0a1-f4ce-42ec-bb2e-5439f2580ff8
# ╟─0f2c526c-e3b9-403b-994e-a25caa721c6c
# ╟─01b4311f-9aad-473a-8c70-b29bd5fbe4dd
# ╟─c83a9563-68bf-4d3b-a3d0-fdcad4375bd7
# ╠═57451b78-1e52-4c8e-b788-7727ca9c6d3f
# ╟─1b604817-7c07-4ae5-b59c-ad50296deac4
# ╠═0864432a-f480-434e-92c2-48d1b4cc10bf
# ╟─921af1b7-8085-4fd7-923a-d0d0ec97356c
# ╠═e9e194eb-2055-496b-b7f1-a69e62574164
# ╟─25d84f26-8ae7-461d-90ef-eb9b6fb07634
# ╠═3b08597e-b7a4-4a36-aa43-9fea5070acb7
# ╠═91d52680-2cac-4fd8-a17d-d00747c85573
# ╠═6d95f769-0055-43e2-aeaa-f6211e362ff0
# ╠═c809d6a2-8652-460c-8c9d-339abd566948
# ╠═5c9a809a-515e-463a-9d1e-7666f2610aac
# ╠═ecd25386-30cc-4e8a-9ceb-296964b71079
# ╠═59058628-99c4-43f6-a0b3-772335068230
# ╠═ef5b5829-2903-4d76-a485-73e5511c7570
# ╟─f6b9a619-7924-4e17-9c75-6a0dbcadebcb
# ╟─cb422498-6157-46e8-950b-dae6b08c1aa8
# ╠═e4807864-de53-404f-8971-4a13576c430b
# ╠═c73e40e9-3696-4231-a1f1-c40b089bea37
# ╟─e862bdb6-3b89-4a95-89b9-78ab30a39c80
# ╠═d0c5d2f9-cb54-4b8f-9237-f040db3f1a09
# ╠═0a775b8e-7143-415b-880f-be79884e45e6
# ╠═03b39733-be43-4dcc-91b8-b439b9f50822
# ╟─4fa57fe3-7114-4615-83d9-6a33e120a383
# ╠═a498562c-3542-49bc-a2c9-142897a2f9e4
# ╠═8c0e1df2-eca2-4eac-8595-055b8130484f
# ╠═7c036167-a628-46ab-a8ff-64e78438558e
# ╠═23a53a42-064b-4657-885b-93a4699a837c
# ╠═39fd6d11-d3e1-496f-aa8b-343b91a9e090
# ╠═c8ce0148-9b17-4899-aa8a-0b2dc3672053
# ╟─1153ea92-3507-4672-af3a-692a7279912d
# ╠═e6784ffc-7db4-49f2-9090-958551bfdf2a
# ╠═cbb10de9-c111-4f70-9709-5125b90f90cf
# ╟─23590679-4453-4382-996d-30b6b5af746b
# ╟─458cc84d-91c6-477b-aa65-bfa56023ccb3
# ╠═535bd639-766d-40e4-bb76-cfaff7457bbf
# ╠═941fcc71-12aa-419e-bf3c-1e4255b78760
# ╟─acb51f91-c5b4-4cfe-ab61-2cf78e11102c
# ╠═33e4adb5-9ffc-4355-9d76-9a6869ef6dbb
# ╟─fece6ca3-c2e0-44f0-ab9c-7a1f8b119692
# ╠═be077f6d-9318-4499-ae21-867041989049
# ╠═87211e9a-c3b6-4813-b330-35b478369c69
# ╠═f51c52c3-014d-4f17-be98-9c10f40becec
# ╠═aa46c7da-bdbd-433f-b3f4-e83254da3e84
# ╟─f2743122-45a8-427b-af69-080274b461d6
# ╠═bcdd8f0f-cfd0-4672-bbaf-62bf8610cfc7
# ╠═d652cece-cf1c-49cb-95a8-d738c09bb72e
# ╠═902af321-3d57-471a-bac4-6f8cb623cc56
# ╠═4d5fd367-2e24-48e9-ae6e-19db2bfd4ae9
# ╠═ceb5c742-50bd-4b5c-a602-a04409a6609e
# ╠═5572fc27-5309-457b-a1d0-e5de40480b61
# ╠═b7ac799b-089e-4ce1-b500-43ad7ca24651
# ╟─f53b054a-1e48-48b2-8d32-98e6c13f649b
# ╠═eef1613d-71d8-4b8f-9da6-3d823544cca8
# ╟─bc0ee0b7-d7c9-4bfc-a939-272a5b92dfa4
# ╟─2c4c92f2-6d33-4fc7-bacf-22827d8425ae
# ╠═7150fcb2-a663-4476-9eaa-d8686b4e91d6
# ╟─4ffc9ba7-3aa3-4503-b976-c15479a18e1a
# ╠═8df55f4f-4858-4c9e-b5c4-56c4ad5547e1
# ╟─00a70c0a-c86f-46a4-9cff-3692c870a2c0
# ╠═d025c063-8ce2-4862-9f0b-535a41e22729
# ╟─dfaf4d63-13cf-471c-b17c-2b3ded20f345
# ╠═9a9a004e-7a3b-4a1a-a4e7-c4d6940e84cf
# ╟─1c2b5bf7-b82e-461b-a572-e3cb4b45b645
# ╠═e9a30b8b-d6d9-498a-8b7d-b22533a63073
# ╟─2f417def-0ea8-4ae5-896a-032b8ca0186e
# ╟─d14c2328-604f-4c6f-9afa-cb1879da4ef2
# ╠═a519fbae-c8b1-4d80-9a8a-7061e7df802c
# ╟─762d32eb-3802-409d-bba5-96a7cae78b41
# ╠═391a3da6-1a7d-4a33-bd6a-eada07bb4d2b
# ╟─7cc27fce-ea4f-47b2-a68f-f199b841b979
# ╠═64f0751f-30af-4baf-b3c2-44a41a79d42c
# ╠═89d9cdb0-4897-4909-ad15-eceffef84b7f
# ╟─6196fcb4-8fff-426d-8426-0f15b7f8e056
# ╠═2b7bfe8f-56f7-4697-a44d-a1d9781310af
# ╟─6008ba43-bd57-4169-ac12-c7cfd351d5c2
# ╠═93bc41f8-2c44-4be2-9a3e-ababdec9bac4
# ╟─8a883a8e-6816-4885-bac7-955a77595396
# ╟─d1acb5b6-e4fa-4d6b-86b6-491e10a3dd24
# ╠═09b83b13-8f15-47d2-a9c7-0468e5daa04d
# ╟─eabd93e6-b91b-4b53-87fa-4fb00760f86c
# ╟─2930f321-9c3a-4d34-b010-1b8909072c49
# ╠═c15fee9d-551e-4428-ab7a-d61b3886bf07
# ╟─84fec98b-dec0-45d9-a819-418b13ee1da4
# ╟─f8030e34-be48-466e-aebe-b021b68cf3cb
# ╠═7b8d3b0f-a9f2-4d31-b401-9e576eb4a29f
# ╟─25c225ce-006d-499c-bda2-5bb4a74df5e3
# ╠═ecc7a67f-2b85-4907-9f28-8eb219bec2f4
# ╟─3d5f0217-a380-48fb-b6a7-20764ca9d34d
# ╠═7705bb49-0769-4d20-8d89-7821a7331846
# ╟─f5d3327f-430e-4144-9026-2c895c48d275
# ╟─6e07afd9-51c1-41d9-9aef-b65a74e843a8
# ╠═530fa12c-f481-4304-a5e6-e89c93bfd4a5
# ╟─b50451f2-6e37-4ba3-a710-70a4c4d76987
# ╠═e077059d-9d49-4bb9-a149-5c6521fc6e03
# ╟─f1fd9296-7e56-41c1-aeb1-8480ffc6e289
# ╟─e970deb5-ac5c-4e7c-aa67-9179034440bf
# ╠═75e25f68-4528-497c-a67d-ff0361ffc6cb
# ╟─bf6b53bf-4176-4a74-943a-cd16d9189e1c
# ╠═447a7b0b-d73f-4996-a6c1-0b2c20624abe
# ╟─f440de63-3b02-4c2c-b7d2-f07cac35428c
# ╠═05f601af-8bc1-4d64-a9dd-015a9bb39123
# ╟─f4760bf4-005d-4aeb-ac68-7a75f2545e5b
# ╟─a031c7d6-2b88-4c92-a6c2-f977f250bc8d
# ╠═ded072f9-7ecd-4036-9159-e1a31e45bca4
# ╟─0258a629-33c1-4179-8cb7-69db6017dd4c
# ╠═3914f52e-a80f-463d-9751-983cd39957c3
# ╠═c1beed77-ecc6-4d6d-8754-f2c5dbddfdb0
# ╠═d8bdf8c9-abed-4700-addd-3acfd2381ab2
# ╠═3af480c9-fea2-443f-9509-22687ffda887
# ╟─ad429462-1492-4dfc-a740-434c81ac6984
# ╠═e6e0dfdc-3e3e-4a0d-9faa-c14d3207a835
# ╠═e48641e0-d9ac-4661-a570-421c1b56c4e8
# ╠═ba21bc85-f4a3-40b0-a656-51c2ca7b4969
# ╟─46f0f6f7-bbce-4ce8-ba53-4b361c1951c7
# ╠═a268554a-e2a5-4707-8313-fa3aa06d6428
# ╠═9ef74a99-3ee9-45c7-b99d-8105de2e6d8c
# ╟─ae9f6624-6ed8-488c-bb76-e34215fe541f
# ╠═8b3fc2c8-6eb0-4132-baac-355ebcefebe8
# ╟─25ae6f62-70bf-4216-9dc3-902def9421a3
# ╠═133118b2-e417-48b7-9bd9-981c200502b1
# ╟─fbfb8d54-4cd8-4d17-83bf-c08ef3028e1c
# ╟─e492b961-f633-4368-b965-a47c9d65eea6
# ╠═84a9374e-867b-434e-8d73-12178e0661b5
# ╟─f0106275-ff20-478f-9834-f531bc53eb9a
# ╟─f6864464-e641-49be-afa6-5088f1a66102
# ╠═89343aa4-926f-4690-9357-08fb897e9f6e
# ╠═d3e505bb-2e2e-490f-bfcd-513cae530d7a
# ╟─e9162052-70dc-4dfd-a9b9-fad1a556d4ca
# ╟─bc2c1fa6-377c-4400-a557-674d9d45b994
# ╟─e675d2bb-18ef-40e8-a64e-d04db73ee1b4
# ╠═1120b98d-4895-4181-b8f2-8f9bebdecad9
# ╟─4106b5ca-8a2d-4ce3-8f97-99ee35235bf2
# ╠═5cbfbbd7-8416-411f-9256-d81ee776e1ab
# ╠═88313219-165c-463d-93c3-9327bf5fb8d6
# ╠═be5aa897-45ec-44b7-9cdd-9e307d19eecb
# ╟─45c1a4b1-e7e5-4746-bef1-ac7cd23799e3
# ╠═94e6baf1-8c63-49ab-a177-d984345f93da
# ╟─e81af480-6dc9-43f6-8e27-cc0c3038ac6f
# ╠═ece90524-ea14-42f7-a1d0-550e35b4cca6
# ╠═39f3226d-7b31-4b5b-81e5-08e01603b0b4
# ╟─f66bfeb6-129f-488e-8044-048446c74119
# ╟─0b46913d-fdcf-4ff0-8bab-e4835799d55c
# ╠═579ebaf4-cfb2-44f1-8765-c9800233ab06
# ╟─e50fb2e8-eab7-491f-ab96-2ea3c27e3184
# ╠═7c3bab34-afab-41d1-bfe0-8705473f8302
# ╟─456f9d2e-7383-4aec-a472-fe64ee592359
# ╠═7ce559f7-69b2-4b23-aa3c-93206c0d0b92
# ╠═72663333-9693-418e-bb05-0317f496d531
# ╠═c6f8e7a4-f9b5-4fb5-8a14-5d244e49a417
# ╠═aed9b174-7d5d-4078-96d8-ea86a738519e
# ╟─6dec3c28-e609-4054-bcb6-e9fcea8da548
# ╠═5cc953a2-20f6-4ebe-8e00-71ff88772f42
# ╟─76f00652-bf7c-46bc-b953-69d9f5bf8f05
# ╟─58148875-b8f4-42ab-b813-be9ab3e8ea17
# ╠═1198b520-0f74-4cfb-9207-78b662a72316
# ╠═6f0e4929-c08b-45f5-b62e-9c90b0f5f941
# ╠═bf63372b-dd34-47fb-beb6-bb098282d243
# ╠═e9a0a938-76fb-4adb-887f-9bb3f66799a8
# ╟─87b4621b-9059-47b1-aa39-8216345e32d2
# ╠═402d2bab-43ec-4cd0-974e-cebfabfc9be8
# ╟─8c5c2454-82ed-4fbf-85bb-0ef7074db1ad
# ╠═ef752a5f-32c2-46dc-a21e-fae1bfcde738
# ╟─418d8d90-4dcd-45d5-930f-f7ee41190b90
# ╠═9ea74934-91a8-4f7e-8227-19f4d7f79cf2
# ╟─d2269b8a-17d8-4b1b-9d73-a7c561e8935f
# ╠═d92784a6-1c18-484e-929b-90cbb09e5e74
# ╟─2f27b2b1-5b5e-486c-80b1-0821b1a2f201
# ╟─508c3e77-f5f0-4af7-9653-ebe10b9c967f
# ╠═d75ecae9-eb7c-4db7-8fb1-43bee603ab29
# ╟─bb04286d-93a8-4db8-96b5-d1731e8d6a76
# ╠═b316eb5c-5dac-402e-8cfc-165a5a51287e
# ╟─f91ec02d-406c-4beb-ba72-10997fbf644e
# ╠═7b79d4f7-a56d-4001-8dcb-f83b515dd155
# ╟─9382e8d6-4add-4a8f-ac54-2e98b874ad5e
# ╠═604645f8-7eae-4dff-bd58-e77677c00712
# ╠═de324773-9e8d-4acd-9697-80833700229a
# ╟─459d0320-8e18-43da-a16e-6477ce7d53bd
# ╠═662ca890-9441-4970-b26a-2d0d6a07118b
# ╠═8fb85b52-07ee-4822-9c61-9fdd58d0c1d2
# ╠═2598c920-212f-4d5c-8072-d1b0234158bf
# ╟─16fc50da-188c-4870-8ba8-c2b20a83b11d
# ╟─aa70a868-0ecb-41c7-89b0-224e434a776e
# ╠═71597e9b-5fe7-4f18-8657-c4b6845af3b4
# ╟─c6986e34-16e5-4b55-8679-a742ca25abc7
# ╠═570c355b-a26a-4ee3-be12-672f7afd1a4c
# ╟─5f121bbc-3e4c-49b4-a29d-48640c41e385
# ╠═16b75163-3dae-4213-8e56-52a1314bd3c3
# ╠═ede5dfb3-a0ce-4367-aa34-8fd5e964cefb
# ╟─4f6ee5f4-ed15-4a56-b847-c59c4ce7d26b
# ╟─333886ef-34b5-445a-b365-ac04db35edf0
# ╠═17c64615-d704-48f3-b5c4-59209265dbaf
# ╟─825b252e-de2a-47a6-aabc-aa79e01c33a8
# ╠═12807fbb-7d63-4d11-8364-fc74294c9fb8
# ╟─19c9aeab-78b8-48ef-b582-09d170468a3a
# ╟─72c02726-a582-47d6-bf61-cba00eee7821
# ╠═a8e4672d-2889-4813-a986-9604659b8096
# ╠═98713afb-56d2-4171-95a0-7352ee5b5fb0
# ╟─7681d446-72ed-47fa-90b8-a40548ccba60
# ╟─a7f82af2-6800-47f2-ac4d-bf6b2b9e8ced
# ╟─4f13846b-ac51-4b12-ae50-adf60be86b89
# ╠═1ed4b714-fa4f-4978-9f8c-c2cd6b34db59
# ╠═5097f20e-ab19-4fed-b380-08d851d0710c
# ╠═d3ff91e8-2186-4aa7-9fe8-6d4f163c2c21
# ╟─0b4e8789-ff6d-401c-b5b4-867c4d83c542
# ╠═f9f328cf-4411-42b9-bcd2-8e257ca646dc
# ╟─6f9a0393-ccf1-4831-90bf-4b0644cb8b6a
# ╟─4e222e1e-6e38-446d-9d07-84b9f4da638a
# ╠═12f243bd-c7af-46ff-9e38-f4aa08d86cf8
# ╠═8c5b34fe-5920-43d3-bf1a-bfe824132971
# ╠═77bbee9d-6d7d-47fb-a1d0-ea2a17fc3d7e
# ╟─ee49888c-7e7a-4c12-80b7-ae5fe79e89c5
# ╠═684bcd7d-3d3c-4285-a721-630bec7c07ee
# ╟─a3743464-295d-4dba-8c97-1a1a0b9fa7c1
# ╟─c6aa0cd7-abbe-4de1-8440-011e5d1037f7
# ╟─5a175020-eb3a-49da-866d-eb0d77d7b4b3
# ╟─1b9c0bd7-82ff-4a62-b5a9-6e5c86a489e5
# ╟─b78484d2-8c6e-4305-8553-9e87abdfa0e7
# ╟─b9e8dee5-326c-4daf-b41b-c49f11577994
# ╟─b8b3aeec-2211-4158-8975-3c2ea9755105
# ╟─832d81b2-7484-4e81-83a1-37984bf3ce3d
# ╟─6363098f-7810-43ad-8d5d-76901a24a0d0
# ╟─be04e7a7-2955-4100-853c-cecba54019b3
# ╟─9b02f32d-aa48-4c7f-8984-d998735e4187
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
