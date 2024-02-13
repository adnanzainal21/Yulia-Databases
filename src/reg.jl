using Statistics

"""
```
mlr_beta(y::Array{T}; n::Int64=10, x::Array{T}=collect(1.0:n))::Matrix{Float64} where {T<:Real}
```

Moving linear regression intercept (column 1) and slope (column 2)
"""
function mlr_beta(y::AbstractArray{T}; n::Int64=10, x::AbstractArray{T}=collect(1.0:n))::Matrix{Float64} where {T<:Real}
    @assert n<length(y) && n>0 "Argument n out of bounds."
    @assert size(y,2) == 1
    @assert size(x,1) == n || size(x,1) == size(y,1)
    const_x = size(x,1) == n
    out = zeros(T, (length(y),2))
    out[1:n-1,:] .= NaN
    xbar = mean(x)
    ybar = runmean(y, n=n, cumulative=false)
    @inbounds for i = n:length(y)
        yi = y[i-n+1:i]
        xi = const_x ? x : x[i-n+1:i]
        out[i,2] = cov(xi,yi) / var(xi)
        out[i,1] = ybar[i] - out[i,2]*xbar
    end
    return out
end

"""
```
mlr_slope(y::Array{T}; n::Int64=10, x::Array{T}=collect(1.0:n))::Array{Float64} where {T<:Real}
```

Moving linear regression slope
"""
function mlr_slope(y::AbstractArray{T}; n::Int64=10, x::AbstractArray{T}=collect(1.0:n))::Array{Float64} where {T<:Real}
    @assert n<length(y) && n>0 "Argument n out of bounds."
    @assert size(y,2) == 1
    @assert size(x,1) == n || size(x,1) == size(y,1)
    const_x = size(x,1) == n
    out = zeros(size(y))
    out[1:n-1] .= NaN
    @inbounds for i = n:length(y)
        yi = y[i-n+1:i]
        xi = const_x ? x : x[i-n+1:i]
        out[i] = cov(xi,yi) / var(xi)
    end
    return out
end

"""
```
mlr_intercept(y::Array{T}; n::Int64=10, x::Array{T}=collect(1.0:n))::Array{Float64} where {T<:Real}
```

Moving linear regression y-intercept
"""
function mlr_intercept(y::AbstractArray{T}; n::Int64=10, x::AbstractArray{T}=collect(1.0:n))::Array{Float64} where {T<:Real}
    @assert n<length(y) && n>0 "Argument n out of bounds."
    @assert size(y,2) == 1
    @assert size(x,1) == n || size(x,1) == size(y,1)
    const_x = size(x,1) == n
    out = zeros(size(y))
    out[1:n-1] .= NaN
    xbar = mean(x)
    ybar = runmean(y, n=n, cumulative=false)
    @inbounds for i = n:length(y)
        yi = y[i-n+1:i]
        xi = const_x ? x : x[i-n+1:i]
        out[i] = ybar[i] - xbar*(cov(xi,yi)/var(xi))
    end
    return out
end

"""
```
mlr(y::Array{T}; n::Int64=10)::Array{Float64} where {T<:Real}
```

Moving linear regression predictions
"""
function mlr(y::AbstractArray{T}; n::Int64=10)::Array{Float64} where {T<:Real}
    b = mlr_beta(y, n=n)
    return b[:,1] + b[:,2]*float(n)
end

"""
```
mlr_se(y::Array{T}; n::Int64=10)::Array{Float64} where {T<:Real}
```

Moving linear regression standard errors
"""
function mlr_se(y::AbstractArray{T}; n::Int64=10)::Array{Float64} where {T<:Real}
    yhat = mlr(y, n=n)
    r = zeros(T, n)
    out = zeros(size(y))
    out[1:n-1] .= NaN
    nf = float(n)
    @inbounds for i = n:length(y)
        r = y[i-n+1:i] .- yhat[i]
        out[i] = sqrt(sum(r.^2)/nf)
    end
    return out
end

"""
```
mlr_ub(y::Array{T}; n::Int64=10, se::T=2.0)::Array{Float64} where {T<:Real}
```

Moving linear regression upper bound
"""
function mlr_ub(y::AbstractArray{T}; n::Int64=10, se::T=2.0)::Array{Float64} where {T<:Real}
    return mlr(y, n=n) + se*mlr_se(y, n=n)
end

"""
```
mlr_lb(y::Array{T}; n::Int64=10, se::T=2.0)::Array{Float64} where {T<:Real}
```

Moving linear regression lower bound
"""
function mlr_lb(y::AbstractArray{T}; n::Int64=10, se::T=2.0)::Array{Float64} where {T<:Real}
    return mlr(y, n=n) - se*mlr_se(y, n=n)
end

"""
```
mlr_bands(y::Array{T}; n::Int64=10, se::T=2.0)::Matrix{Float64} where {T<:Real}
```

Moving linear regression bands


*Output:*

Column 1: Lower bound

Column 2: Regression estimate

Column 3: Upper bound
"""
function mlr_bands(y::AbstractArray{T}; n::Int64=10, se::T=2.0)::Matrix{Float64} where {T<:Real}
    out = zeros(T, (length(y),3))
    out[1:n-1,:] .= NaN
    out[:,2] = mlr(y, n=n)
    out[:,1] = mlr_lb(y, n=n, se=se)
    out[:,3] = mlr_ub(y, n=n, se=se)
    return out
end

"""
```
mlr_rsq(y::Array{T}; n::Int64=10, adjusted::Bool=false)::Array{Float64} where {T<:Real}
```

Moving linear regression R-squared or adjusted R-squared
"""
function mlr_rsq(y::AbstractArray{T}; n::Int64=10, adjusted::Bool=false)::Array{Float64} where {T<:Real}
    yhat = mlr(y, n=n)
    rsq = runcor(y, yhat, n=n, cumulative=false) .^ 2.0
    if adjusted
        return rsq .- (1.0.-rsq)*(1.0/(float(n).-2.0))
    else
        return rsq
    end
end

