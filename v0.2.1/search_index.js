var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"    CurrentModule = ImplicitArrays","category":"page"},{"location":"#ImplicitArrays.jl","page":"Home","title":"ImplicitArrays.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The ImplicitArrays.jl package provides multiple implicit array types for the Julia programming language. In many situations, the implicit array types can be used as drop-in replacements for regular Julia arrays, while carrying a smaller memory footprints as their explicit counterparts.","category":"page"},{"location":"#Block-matrices","page":"Home","title":"Block matrices","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This section presents a block matrix type for equally-sized blocks (sharing a common element type). The BlockMatrix type can be used to encapsulate and mix different matrix blocks, e.g., regular matrices and implicit matrices at the same time.","category":"page"},{"location":"","page":"Home","title":"Home","text":"    BlockMatrix","category":"page"},{"location":"#ImplicitArrays.BlockMatrix","page":"Home","title":"ImplicitArrays.BlockMatrix","text":"BlockMatrix{T} <: AbstractArray{T, 2}\n\nImplicit block matrix of equally-sized matrices with elements of type T.\n\nConstructors\n\nBlockMatrix(blocks)\nBlockMatrix{T}(blocks)\nBlockMatrix{T}(rows, cols[, blocks...])\nBlockMatrix(rows, cols, first_block[, more_blocks...])\n\nCreate a new block matrix from the given matrix of matrices. Alternatively, create the block matrix from a sequence of matrices, given the number of rows and cols.\n\nExamples\n\njulia> A = [1 2; 3 4]; B = zeros(Int, 2, 2);\n\njulia> C = [x * y for x in 2:3, y in 3:4];\n\njulia> BlockMatrix(1, 4, A, B, B, C)\n2×8 BlockMatrix{Int64}:\n 1  2  0  0  0  0  6   8\n 3  4  0  0  0  0  9  12\n\nnote: Note\nThis type is not suitable for high-performance purposes, as matrix blocks are stored in an abstract container to allow the composition of arbitrary matrix types. For more details, please refer to the performance tips in the official Julia documentation.\n\n\n\n\n\n","category":"type"},{"location":"#Fixed-value-arrays","page":"Home","title":"Fixed-value arrays","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Fixed-value arrays \"replicate\" a single value across arbitrary array dimensions. The resulting arrays have a constant memory footprint (i.e., the represented value and the array dimensions) and can only be read from.","category":"page"},{"location":"","page":"Home","title":"Home","text":"    FixedValueArray","category":"page"},{"location":"#ImplicitArrays.FixedValueArray","page":"Home","title":"ImplicitArrays.FixedValueArray","text":"FixedValueArray{T, N} <: AbstractArray{T, N}\n\nImplicit and arbitrarily-sized array with a common value of type T for all elements.\n\nConstructors\n\nFixedValueArray(val, dims)\nFixedValueArray(val, dims...)\n\nCreate a new matrix of the given dimensions dims, where each element is represented by the given value val.\n\nExamples\n\njulia> FixedValueArray(0, (2, 5))\n2×5 FixedValueArray{Int64,2}:\n 0  0  0  0  0\n 0  0  0  0  0\n\njulia> FixedValueArray(\"(^_^) Hi!\", 1, 2)\n1×2 FixedValueArray{String,2}:\n \"(^_^) Hi!\"  \"(^_^) Hi!\"\n\njulia> FixedValueArray(FixedValueArray(5.0, (1, 2)), (1, 3))\n1×3 FixedValueArray{FixedValueArray{Float64,2},2}:\n [5.0 5.0]  [5.0 5.0]  [5.0 5.0]\n\njulia> length(FixedValueArray(1, 1_000_000_000, 1_000_000_000))\n1000000000000000000\n\n\n\n\n\n","category":"type"},{"location":"#Interaction-matrices","page":"Home","title":"Interaction matrices","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"An interaction matrix M of size n × m consist of a list of n elements rᵢ ∈ R (row elements), a list of m elements cⱼ ∈ C (column elements), and a interaction function f: R × C → T, such that each element Mᵢⱼ of the matrix can be computed as f(rᵢ, cⱼ).","category":"page"},{"location":"#Interaction-functions","page":"Home","title":"Interaction functions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"    InteractionFunction\n    ConstInteractionFunction\n    GenericInteractionFunction","category":"page"},{"location":"#ImplicitArrays.InteractionFunction","page":"Home","title":"ImplicitArrays.InteractionFunction","text":"InteractionFunction{R, C, T}\n\nAbstract base type of all interaction functions R × C → T.\n\n\n\n\n\n","category":"type"},{"location":"#ImplicitArrays.ConstInteractionFunction","page":"Home","title":"ImplicitArrays.ConstInteractionFunction","text":"struct ConstInteractionFunction{R, C, T} <: InteractionFunction{R, C, T}\n\nInteraction function R × C → T that ignores its arguments and returns a fixed value.\n\nConstructor\n\nConstInteractionFunction{R, C, T}(val)\n\nCreate a constant interaction function that always returns val.\n\nExamples\n\njulia> f = ConstInteractionFunction{Float64, Float64, Int64}(42);\n\njulia> f(1.0, 1.5)\n42\n\n\n\n\n\n","category":"type"},{"location":"#ImplicitArrays.GenericInteractionFunction","page":"Home","title":"ImplicitArrays.GenericInteractionFunction","text":"GenericInteractionFunction{R, C, T} <: InteractionFunction{R, C, T}\n\nInteraction function R × C → T acting as a type-safe wrapper for a given function.\n\nConstructor\n\nGenericInteractionFunction{R, C, T}(fun)\n\nCreate an interaction function from the given function fun.\n\nExamples\n\njulia> f = GenericInteractionFunction{Int64, Int64, Int64}(+); f(9, 3)\n12\n\njulia> g = GenericInteractionFunction{Int64, Int64, Float64}(/); g(9, 3)\n3.0\n\njulia> h = GenericInteractionFunction{String, Int64, String}(repeat); h(\"abc\", 3)\n\"abcabcabc\"\n\nnote: Note\nThe interaction function can only be evaluated if there is a method fun(::R, ::C) that returns a value of type T. Otherwise, a MethodError or TypeError is thrown.\n\n\n\n\n\n","category":"type"},{"location":"#Interaction-matrices-2","page":"Home","title":"Interaction matrices","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"    InteractionMatrix","category":"page"},{"location":"#ImplicitArrays.InteractionMatrix","page":"Home","title":"ImplicitArrays.InteractionMatrix","text":"InteractionMatrix{T, R, C, F <: InteractionFunction{R, C, T}} <: AbstractArray{T, 2}\n\nInteraction matrix with elements of type T, generated from row elements of type R, column elements of type C, and an interaction function F: R × C → T.\n\nConstructors\n\nInteractionMatrix(rowelems, colelems, interact)\nInteractionMatrix{T}(rowelems, colelems, interact)\n\nCreate an interaction matrix for the given row and column element arrays as well as an interaction  function.\n\nInteractionMatrix(rowelems, colelems, val)\n\nCreate an interaction matrix for the given (yet unused) row and column element arrays and a constant interaction function always returning val. In this form, the interaction matrix acts as a replacement for a two-dimensional FixedValueArray.\n\nExamples\n\njulia> InteractionMatrix{Int64}([1, 2, 3], [10, 20, 30], +)\n3×3 InteractionMatrix{Int64,Int64,Int64,GenericInteractionFunction{Int64,Int64,Int64}}:\n 11  21  31\n 12  22  32\n 13  23  33\n\njulia> InteractionMatrix([1, 2, 3], [10, 20, 30], 42)\n3×3 InteractionMatrix{Int64,Int64,Int64,ConstInteractionFunction{Int64,Int64,Int64}}:\n 42  42  42\n 42  42  42\n 42  42  42\n\njulia> struct DivFun <: InteractionFunction{Int, Int, Float64} end\n\njulia> (::DivFun)(x::Int, y::Int) = x / y\n\njulia> InteractionMatrix([10, 20, 30], [5, 2, 1], DivFun())\n3×3 InteractionMatrix{Float64,Int64,Int64,DivFun}:\n 2.0   5.0  10.0\n 4.0  10.0  20.0\n 6.0  15.0  30.0\n\n\n\n\n\n","category":"type"},{"location":"#Row-projection-arrays","page":"Home","title":"Row-projection arrays","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Row-projection arrays represent views on existing vectors or matrices, where the projections are created from a sequence of valid row indices corresponding to the vector or matrix. Row indices can occur multiple times and at arbitrary positions in the sequence.","category":"page"},{"location":"","page":"Home","title":"Home","text":"    RowProjectionVector\n    RowProjectionMatrix","category":"page"},{"location":"#ImplicitArrays.RowProjectionVector","page":"Home","title":"ImplicitArrays.RowProjectionVector","text":"RowProjectionVector{T} <: AbstractArray{T, 1}\n\nImplicit vector projecting a sequence of rows of a given vector with elements of type T.\n\nConstructors\n\nRowProjectionVector(base, rows)\nRowProjectionVector(base, rows...)\nRowProjectionVector{T}(base, rows)\n\nCreate a new row-projected vector from the given base vector and a list or sequence of rows corresponding to it. Rows can be used multiple times and in any order.\n\nExamples\n\njulia> v = [10, 20, 30, 40, 50];\n\njulia> RowProjectionVector(v, [1, 3, 5])\n3-element RowProjectionVector{Int64}:\n 10\n 30\n 50\n\njulia> RowProjectionVector(v, 2, 3, 2)\n3-element RowProjectionVector{Int64}:\n 20\n 30\n 20\n\nnote: Note\nChanging an element through RowProjectionVector actually changes the element in the underlying array. The changes are still reflected in the RowProjectionVector. Thus, caution is advised when changing elements of rows that are contained multiple times in the projection, in order to avoid unwanted side effects.\n\n\n\n\n\n","category":"type"},{"location":"#ImplicitArrays.RowProjectionMatrix","page":"Home","title":"ImplicitArrays.RowProjectionMatrix","text":"RowProjectionMatrix{T} <: AbstractArray{T, 2}\n\nImplicit matrix projecting a sequence of rows of a given matrix with elements of type T.\n\nConstructors\n\nRowProjectionMatrix(base, rows)\nRowProjectionMatrix(base, rows...)\nRowProjectionMatrix{T}(base, rows)\n\nCreate a new row-projected matrix from the given base matrix and a list or sequence of rows corresponding to it. Rows can be used multiple times and in any order.\n\nExamples\n\njulia> M = [10 20 30; 40 50 60; 70 80 90];\n\njulia> RowProjectionMatrix(M, [1, 3])\n2×3 RowProjectionMatrix{Int64}:\n 10  20  30\n 70  80  90\n\njulia> RowProjectionMatrix(M, 2, 3, 2)\n3×3 RowProjectionMatrix{Int64}:\n 40  50  60\n 70  80  90\n 40  50  60\n\nnote: Note\nChanging an element through RowProjectionMatrix actually changes the element in the underlying array. The changes are still reflected in the RowProjectionMatrix. Thus, caution is advised when changing elements of rows that are contained multiple times in the projection, in order to avoid unwanted side effects.\n\n\n\n\n\n","category":"type"}]
}
