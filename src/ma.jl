"""
```
sma(x::Array{T}; n::Int64=10)::Array{T}
```

Simple moving average (SMA)
"""
function sma(x::AbstractArray{T}; n::Int64=10)::Array{Float64} where {T<:Real}
    return runmean(x, n=n, cumulative=false)
end

"""
```
trima(x::Array{T}; n::Int64=10, ma::Function=sma, args...)::Array{Float64}
```


Triangular moving average (TRIMA)
"""
function trima(x::AbstractArray{T}; n::Int64=10, ma::Function=sma)::Array{Float64} where {T<:Real}
    return ma(ma(x, n=n), n=n)
end

"""
```
wma(x::Array{T}; n::Int64=10, wts::Array{T}=collect(1:n)/sum(1:n))::Array{Float64}
```

Weighted moving average (WMA)
"""
function wma(x::AbstractArray{T}; n::Int64=10, wts::AbstractArray{T}=collect(1:n)/sum(1:n)) where {T<:Real}
    @assert n<size(x,1) && n>0 "Argument n out of bounds"
    out = fill(NaN, size(x,1))
    @inbounds for i = n:size(x,1)
        out[i] = (wts' * x[i-n+1:i])[1]
    end
    return out
end

function first_valid(x::AbstractArray{T})::Int where {T<:Real}
    if !isnan(x[1])
        return 1
    else
        @inbounds for i in 2:length(x)
            if !isnan(x[i])
                return i
            end
        end
    end
    return 0
end

"""
```
ema(x::Array{T}; n::Int64=10, alpha::T=2.0/(n+1.0), wilder::Bool=false)::Array{Float64}
```

Exponential moving average (EMA)
"""
function ema(x::AbstractArray{T}; n::Int64=10, alpha::T=2.0/(n+1), wilder::Bool=false) where {T<:Real}
    @assert n<size(x,1) && n>0 "Argument n out of bounds."
    if wilder
        alpha = 1.0/n
    end
    out = zeros(size(x))
    i = first_valid(x)
    out[1:n+i-2] .= NaN
    out[n+i-1] = mean(x[i:n+i-1])
    @inbounds for i = n+i:size(x,1)
        out[i] = alpha * (x[i] - out[i-1]) + out[i-1]
    end
    return out
end

"""
```
mma(x::Array{T}; n::Int64=10)::Array{Float64}
```

Modified moving average (MMA)
"""
function mma(x::AbstractArray{T}; n::Int64=10) where {T<:Real}
    return ema(x, n=n, alpha=1.0/n)
end

"""
```
dema(x::Array{T}; n::Int64=10, alpha=2.0/(n+1), wilder::Bool=false)::Array{Float64}
```

Double exponential moving average (DEMA)
"""
function dema(x::AbstractArray{T}; n::Int64=10, alpha=2.0/(n+1), wilder::Bool=false) where {T<:Real}
    return 2.0 * ema(x, n=n, alpha=alpha, wilder=wilder) - 
        ema(ema(x, n=n, alpha=alpha, wilder=wilder),
            n=n, alpha=alpha, wilder=wilder)
end

"""
```
tema(x::Array{T}; n::Int64=10, alpha=2.0/(n+1), wilder::Bool=false)::Array{Float64}
```

Triple exponential moving average (TEMA)
"""
function tema(x::AbstractArray{T}; n::Int64=10, alpha=2.0/(n+1), wilder::Bool=false) where {T<:Real}
    return 3.0 * ema(x, n=n, alpha=alpha, wilder=wilder) - 
        3.0 * ema(ema(x, n=n, alpha=alpha, wilder=wilder),
                  n=n, alpha=alpha, wilder=wilder) +
        ema(ema(ema(x, n=n, alpha=alpha, wilder=wilder),
                n=n, alpha=alpha, wilder=wilder),
            n=n, alpha=alpha, wilder=wilder)
end

"""
```
mama(x::Array{T}; fastlimit::T=0.5, slowlimit::T=0.05)::Matrix{Float64}
```

MESA adaptive moving average (MAMA)
"""
function mama(x::AbstractArray{T}; fastlimit::T=0.5, slowlimit::T=0.05)::Matrix{Float64} where {T<:Real}
    n = size(x,1)
    out = zeros(T, n, 2)
    #smooth = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    smooth_1 = 0.0
    smooth_2 = 0.0
    smooth_3 = 0.0
    smooth_4 = 0.0
    smooth_5 = 0.0
    smooth_6 = 0.0
    smooth_7 = 0.0
    #detrend = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    detrend_1 = 0.0
    detrend_2 = 0.0
    detrend_3 = 0.0
    detrend_4 = 0.0
    detrend_5 = 0.0
    detrend_6 = 0.0
    detrend_7 = 0.0
    #Q1 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    Q1_1 = 0.0
    Q1_2 = 0.0
    Q1_3 = 0.0
    Q1_4 = 0.0
    Q1_5 = 0.0
    Q1_6 = 0.0
    Q1_7 = 0.0
    #I1 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    I1_1 = 0.0
    I1_2 = 0.0
    I1_3 = 0.0
    I1_4 = 0.0
    I1_5 = 0.0
    I1_6 = 0.0
    I1_7 = 0.0
    #I2 = [0.0, 0.0]
    I2_1 = 0.0
    I2_2 = 0.0
    #Q2 = [0.0, 0.0]
    Q2_1 = 0.0
    Q2_2 = 0.0
    #Re = [0.0, 0.0]
    Re_1 = 0.0
    Re_2 = 0.0
    #Im = [0.0, 0.0]
    Im_1 = 0.0
    Im_2 = 0.0
    #per = [0.0, 0.0]
    per_1 = 0.0
    per_2 = 0.0
    #sper = [0.0, 0.0]
    sper_1 = 0.0
    sper_2 = 0.0
    #phase = [0.0, 0.0]
    phase_1 = 0.0
    phase_2 = 0.0
    jI = 0.0
    jQ = 0.0
    dphase = 0.0
    alpha = 0.0
    a = 0.0962
    b = 0.5769
    @inbounds for i = 13:n
        # Smooth and detrend price movement ====================================
        smooth_7 = (4*x[i] + 3*x[i-1] + 2*x[i-2] + x[i-3]) * 0.1
        detrend_7 = (0.0962*smooth_7+0.5769*smooth_5-0.5769*smooth_3-0.0962*smooth_1) * (0.075*per_1+0.54)
        # Compute InPhase and Quandrature components ===========================
        Q1_7 = (0.0962*detrend_7+0.5769*detrend_5-0.5769*detrend_3-0.0962*detrend_1) * (0.075*per_1+0.54)
        I1_7 = detrend_4
        # Advance phase of I1 and Q1 by 90 degrees =============================
        jQ = (0.0962*Q1_7+0.5769*Q1_5-0.5769*Q1_3-0.0962*Q1_1) * (0.075*per_1+0.54)
        jI = (0.0962*I1_7+0.5769*I1_5-0.5769*I1_3-0.0962*I1_1) * (0.075*per_1+0.54)
        # Phasor addition for 3 bar averaging ==================================
        Q2_2 = Q1_7 + jI
        I2_2 = I1_7 - jQ
        # Smooth I & Q components before applying the discriminator ============
        Q2_2 = 0.2 * Q2_2 + 0.8 * Q2_1
        I2_2 = 0.2 * I2_2 + 0.8 * I2_1
        # Homodyne discriminator ===============================================
        Re_2 = I2_2 * I2_1 + Q2_2*Q2_1
        Im_2 = I2_2 * Q2_1 - Q2_2*I2_1
        Re_2 = 0.2 * Re_2 + 0.8*Re_1
        Im_2 = 0.2 * Im_2 + 0.8*Im_1
        if (Im_2 != 0.0) & (Re_2 != 0.0)
            per_2 = 360.0/atan(Im_2/Re_2)
        end
        if per_2 > 1.5 * per_1
            per_2 = 1.5*per_1
        elseif per_2 < 0.67 * per_1
            per_2 = 0.67 * per_1
        end
        if per_2 < 6.0
            per_2 = 6.0
        elseif per_2 > 50.0
            per_2 = 50.0
        end
        per_2 = 0.2*per_2 + 0.8*per_1
        sper_2 = 0.33*per_2 + 0.67*sper_1
        if I1_7 != 0.0
            phase_2 = atan(Q1_7/I1_7)
        end
        dphase = phase_1 - phase_2
        if dphase < 1.0
            dphase = 1.0
        end
        alpha = fastlimit / dphase
        if alpha < slowlimit
            alpha = slowlimit
        end
        out[i,1] = alpha*x[i] + (1.0-alpha)*out[i-1,1]
        out[i,2] = 0.5*alpha*out[i,1] + (1.0-0.5*alpha)*out[i-1,2]
        # Reset/increment array variables
        # smooth
        smooth_1 = smooth_2
        smooth_2 = smooth_3
        smooth_3 = smooth_4
        smooth_4 = smooth_5
        smooth_5 = smooth_6
        smooth_6 = smooth_7
        # detrend
        detrend_1 = detrend_2
        detrend_2 = detrend_3
        detrend_3 = detrend_4
        detrend_4 = detrend_5
        detrend_5 = detrend_6
        detrend_6 = detrend_7
        # Q1
        Q1_1 = Q1_2
        Q1_2 = Q1_3
        Q1_3 = Q1_4
        Q1_4 = Q1_5
        Q1_5 = Q1_6
        Q1_6 = Q1_7
        # I1
        I1_1 = I1_2
        I1_2 = I1_3
        I1_3 = I1_4
        I1_4 = I1_5
        I1_5 = I1_6
        I1_6 = I1_7
        # I2
        I2_1 = I2_2
        # Q2
        Q2_1 = Q2_2
        # Re
        Re_1 = Re_2
        # Im
        Im_1 = Im_2
        # per
        per_1 = per_2
        # sper
        sper_1 = sper_2
        # phase
        phase_1 = phase_2
    end
    out[1:32,:] .= NaN
    return out
end


"""
```
hma(x::Array{T}; n::Int64=20)::Array{Float64}
```

Hull moving average (HMA)
"""
function hma(x::AbstractArray{T}; n::Int64=20) where {T<:Real}
    return wma(2 * wma(x, n=Int64(round(n/2.0))) - wma(x, n=n), n=Int64(trunc(sqrt(n))))
end

"""
Sine-weighted moving average
"""
function swma(x::AbstractArray{T}; n::Int64=10) where {T<:Real}
    @assert n<size(x,1) && n>0 "Argument n out of bounds."
    w = sin.(collect(1:n) * 180.0/6.0)  # numerator weights
    d = sum(w)  # denominator = sum(numerator weights)
    out = zeros(size(x))
    out[1:n-1] .= NaN
    @inbounds for i = n:size(x,1)
        out[i] = sum(w .* x[i-n+1:i]) / d
    end
    return out
end

"""
Kaufman adaptive moving average (KAMA)
"""
function kama(x::AbstractArray{T}; n::Int64=10, nfast::T=0.6667, nslow::T=0.0645) where {T<:Real}
    @assert n<size(x,1) && n>0 "Argument n out of bounds."
    @assert nfast>0.0 && nfast<1.0 "Argument nfast out of bounds."
    @assert nslow>0.0 && nslow<1.0 "Argument nslow out of bounds."
    dir = diffn(x, n=n)  # price direction := net change in price over past n periods
    vol = runsum(abs.(diffn(x,n=1)), n=n, cumulative=false)  # volatility/noise
    er = abs.(dir) ./ vol  # efficiency ratio
    ssc = er * (nfast-nslow) .+ nslow  # scaled smoothing constant
    sc = ssc .^ 2  # smoothing constant
    # initiliaze result variable
    out = zeros(size(x))
    i = ndims(x) > 1 ? findfirst(.!isnan.(x)).I[1] : findfirst(.!isnan.(x))
    out[1:n+i-2] .= NaN
    out[n+i-1] = mean(x[i:n+i-1])
    @inbounds for i = n+1:size(x,1)
        out[i] = out[i-1] + sc[i]*(x[i]-out[i-1])
    end
    return out
end

"""
```
alma{T}(x::Array{T}; n::Int64=9, offset::T=0.85, sigma::T=6.0)::Array{Float64}
```

Arnaud-Legoux moving average (ALMA)
"""
function alma(x::AbstractArray{T}; n::Int64=9, offset::T=0.85, sigma::T=6.0)::Array{Float64} where {T<:Real}
    @assert n<size(x,1) && n>0 "Argument n out of bounds."
    @assert sigma>0.0 "Argument sigma must be greater than 0."
    @assert offset>=0.0 && offset<=1 "Argument offset must be in (0,1)."
    out = zeros(size(x))
    out[1:n-1] .= NaN
    m = floor(offset*(float(n)-1.0))
    s = float(n) / sigma
    w = exp.(-(((0.0:-1.0:-float(n)+1.0) .- m) .^ 2.0) / (2.0*s*s))
    wsum = sum(w)
    if wsum != 0.0
        w = w ./ wsum
    end
    @inbounds for i = n:length(x)
        out[i] = sum(x[i-n+1] .* w)
    end
    return out
end

function lagged(x::AbstractArray{T}, n::Int=1)::Array{Float64} where {T<:Real}
    if n > 0
        return [fill(NaN,n); x[1:end-n]]
    elseif n < 0
        return [x[(-n+1):end]; fill(NaN,-n)]
    else
        return x
    end
end

"""
```
zlema(x::Array{T}; n::Int=10, ema_args...)::Array{Float64}
```

Zero-lag exponential moving average (ZLEMA)
"""
function zlema(x::AbstractArray{T}; n::Int=10, ema_args...)::Array{Float64} where {T<:Real}
    return ema(x+(x-lagged(x,round(Int, (n-1)/2.0))), n=n; ema_args...)
end

"""
```
vwma(cv::Matrix{T})::Array{T}
```

Volume weighted moving average (VWMA)
"""
function vwma(cv::AbstractMatrix{T}; n::Int64=10)::Array{Float64} where {T<:Real}
    @assert n<size(cv,1) && n>0 "Argument n out of bounds."
    N = size(cv, 1)
    out = zeros(N)
    close_price = cv[:,1]
    volume = cv[:,2]
    out[1:n-1] .= NaN
    @inbounds for i = n:N
        weight = volume[i-n+1:i]   # get volumes as numerator
        d = sum(weight)  # denominator = sum(numerator weights)
        out[i] = sum(weight .* close_price[i-n+1:i]) / d
    end
    return out
end

"""
```
vwap(cv::Matrix{T})::Array{T}
```

Volume-weighted average price (VWAP)
"""
function vwap(cv::AbstractMatrix{T})::Array{Float64} where {T<:Real}
    out = zeros(size(cv))[1]
    close_price = cv[:,1]
    volume = cv[:,2]
    out = cumsum(close_price .* volume) ./ cumsum(volume)
    return out
end

"""
```
hama(x::Array{T})::Array{T}
```

Hamming moving average (HAMA)
"""
function hama(x::AbstractArray{T}; n::Int=10)::Array{Float64} where {T<:Real}
    hamming_weights = 0.54 .- 0.46 .* cos.(2*pi*(1:n)/n)
    out = wma(x, n=n, wts=hamming_weights)
    return out
end

