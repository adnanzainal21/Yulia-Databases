using Indicators
using PyPlot
using Dates
using Random

# Generate some toy sample data
Random.seed!(1)
n = 250
Open = 100.0 .+ cumsum(randn(n))
High = Open .+ rand(n)
Low = Open .- rand(n)
Close = 100.0 .+ cumsum(randn(n))
for i = 1:n
	if Close[i] > High[i]
		Close[i] = High[i]
	elseif Close[i] < Low[i]
		Close[i] = Low[i]
	end
end
OHLC = [Open High Low Close]
HLC = [High Low Close]
HL = [High Low]
t = collect(today():Day(1):today()+Day(n-1))

# Overlays
subplot(411)
plot(t, Close, lw=2, c="k", label="Random Walk")
grid(ls="-", c=[0.8,0.8,0.8])
plot(t, sma(Close,n=40), c=[1,0.5,0], label="SMA (40)")
plot(t, ema(Close,n=10), c=[0,1,1], label="EMA (10)")
plot(t, wma(Close,n=20), c=[1,0,1], label="WMA (20)")
plot(t, psar(HL),   "bo", label="Parabolic SAR")
legend(loc="best", frameon=false)

# MACD
subplot(412)
plot(t, macd(Close)[:,1], label="MACD", c=[1,0.5,1])
plot(t, macd(Close)[:,2], label="Signal", c=[0.5,0.25,0.5])
bar(t, macd(Close)[:,3], align="center", label="Histogram", color=[0,0.5,0.5], alpha=0.25)
plot([t[1],t[end]], [0,0], ls="--", c=[0.5,0.5,0.5])
grid(ls="-", c=[0.8,0.8,0.8])
legend(loc="best", frameon=false)

# RSI
subplot(413)
plot(t, rsi(Close), c=[0.5,0.5,0], label="RSI")
grid(ls="-", c=[0.8,0.8,0.8])
plot([t[1],t[end]], [30,30], c="g")
plot([t[1],t[end]], [70,70], c="r")
legend(loc="best", frameon=false)

# ADX
subplot(414)
plot(t, adx(HLC)[:,1], "g-", label="DI+")
plot(t, adx(HLC)[:,2], "r-", label="DI-")
plot(t, adx(HLC)[:,3], c=[0,0,1], lw=2, label="ADX")
grid(ls="-", c=[0.8,0.8,0.8])
legend(loc="best", frameon=false)

tight_layout()
