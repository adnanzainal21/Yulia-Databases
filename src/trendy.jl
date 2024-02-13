# Functions supporting trendline identification (support/resistance, zigzag, elliot waves, etc.)

"""
```
maxima(x::Array{T}; threshold::T=0.0, order::Int=1) where {T<:Real}
```

Estimate local maxima of a time series
"""
function maxima(x::AbstractArray{T}; threshold::T=0.0, order::Int=1) where {T<:Real}
    @assert threshold >= 0.0 "threshold must be positive"
    @assert order > 0 "order must be a positive integer"
    n = size(x,1)
    crit = falses(n)
    @inbounds for i=2:n-1
        if (x[i]-x[i-1] >= threshold) && (x[i]-x[i+1] >= threshold)
            crit[i] = true
        end
    end
    while order > 1
        idx = findall(crit)
        crit[idx[.!maxima(x[crit], threshold=threshold)]] .= false
        order -= 1
    end
    return crit
end

"""
```
minima(x::Array{T}; threshold::T=0.0, order::Int=1) where {T<:Real}
```

Estimate local minima of a time series
"""
function minima(x::AbstractArray{T}; threshold::T=0.0, order::Int=1) where {T<:Real}
    @assert threshold <= 0.0 "threshold must be negative"
    @assert order > 0 "order must be a positive integer"
    n = size(x,1)
    crit = falses(n)
    @inbounds for i=2:n-1
        if (x[i]-x[i-1] <= threshold) && (x[i]-x[i+1] <= threshold)
            crit[i] = true
        end
    end
    while order > 1
        idx = findall(crit)
        crit[idx[.!minima(x[crit], threshold=threshold)]] .= false
        order -= 1
    end
    return crit
end

function interpolate(x1::Int, x2::Int, y1::T, y2::T) where {T<:Real}
	m = (y2-y1)/(x2-x1)
	b = y1 - m*x1
	x = collect(x1:1.0:x2)
	y = m*x .+ b
	return y
end

"""
```
resistance(x::Array{T}; order::Int=1, threshold::T=0.0) where {T<:Real}
```

Estimate resistance lines of a financial time series
"""
function resistance(x::AbstractArray{T}; order::Int=1, threshold::T=0.0) where {T<:Real}
    out = zeros(size(x))
    crit = maxima(x, threshold=threshold, order=order)
    out[.!crit] .= NaN
    idx = findall(crit)
    @inbounds for i=2:length(idx)
        out[idx[i-1]:idx[i]] .= interpolate(idx[i-1], idx[i], x[idx[i-1]], x[idx[i]])
    end
    return out
end

"""
```
support(x::Array{T}; order::Int=1, threshold::T=0.0) where {T<:Real}
```

Estimate support lines of a financial time series
"""
function support(x::AbstractArray{T}; order::Int=1, threshold::T=0.0) where {T<:Real}
    out = zeros(size(x))
    crit = minima(x, threshold=threshold, order=order)
    out[.!crit] .= NaN
    idx = findall(crit)
    @inbounds for i=2:length(idx)
        out[idx[i-1]:idx[i]] .= interpolate(idx[i-1], idx[i], x[idx[i-1]], x[idx[i]])
    end
    return out
end
