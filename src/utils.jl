# Miscellaneous utilities

"""
```
crossover(x::Array{T}, y::Array{T}) where {T<:Real}
```

Find where `x` crosses over `y` (returns boolean vector where crossover occurs)
"""
function crossover(x::AbstractArray{T}, y::AbstractArray{T}) where {T<:Real}
    @assert size(x,1) == size(y,1)
    out = falses(size(x))
    @inbounds for i in 2:size(x,1)
        out[i] = ((x[i] > y[i]) && (x[i-1] < y[i-1]))
    end
    return out
end

"""
```
crossunder(x::Array{T}, y::Array{T}) where {T<:Real}
```

Find where `x` crosses under `y` (returns boolean vector where crossunder occurs)
"""
function crossunder(x::AbstractArray{T}, y::AbstractArray{T}) where {T<:Real}
    @assert size(x,1) == size(y,1)
    out = falses(size(x))
    @inbounds for i in 2:size(x,1)
        out[i] = ((x[i] < y[i]) && (x[i-1] > y[i-1]))
    end
    return out
end

"""
```
wilder_sum(x::Vector{T}; n::Int=10)::Vector{T}
```

Welles Wilder summation of an array
"""
function wilder_sum(x::AbstractVector{T}; n::Int=10)::Vector{T} where {T<:Real}
    @assert n<size(x,1) && n>0 "Argument n is out of bounds."
    nf = float(n)  # type stability -- all arithmetic done on floats
    out = zeros(size(x))
    out[1] = x[1]
    @inbounds for i = 2:size(x,1)
        out[i] = x[i] + out[i-1]*(nf-1.0)/nf
    end
    return out
end
wilder_sum(X::AbstractMatrix; n::Int=10)::Matrix = hcat((wilder_sum(X[:,j], n=n) for j in 1:size(X,2))...)

"""
(Adapted from StatsBase: https://raw.githubusercontent.com/JuliaStats/StatsBase.jl/master/src/scalarstats.jl)

Compute the mode of an arbitrary array::Array{T}
"""
function mode(a::AbstractArray{T}) where {T<:Real}
    isempty(a) && error("mode: input array cannot be empty.")
    cnts = Dict{T,Int}()
    # first element
    mc = 1
    mv = a[1]
    cnts[mv] = 1
    # find the mode along with table construction
    @inbounds for i = 2 : length(a)
        x = a[i]
        if haskey(cnts, x)
            c = (cnts[x] += 1)
            if c > mc
                mc = c
                mv = x
            end
        else
            cnts[x] = 1
            # in this case: c = 1, and thus c > mc won't happen
        end
    end
    return mv
end

"""
```
diffn(x::Vector{T}; n::Int=1)::Vector{T} where {T<:Real}
diffn(X::Matrix; n::Int=1)::Matrix = hcat([diffn(X[:,j], n=n) for j in 1:size(X,2)]...)
```

Lagged differencing
"""
function diffn(x::AbstractVector{T}; n::Int=1)::Vector{T} where {T<:Real}
    @assert n<size(x,1) && n>0 "Argument n out of bounds."
    dx = zeros(size(x))
    dx[1:n] .= NaN
    @inbounds for i=n+1:size(x,1)
        dx[i] = x[i] - x[i-n]
    end
    return dx
end
diffn(X::AbstractMatrix; n::Int=1)::Matrix = hcat([diffn(X[:,j], n=n) for j in 1:size(X,2)]...)
