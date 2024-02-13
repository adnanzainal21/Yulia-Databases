# workspace()
using Indicators
using PyPlot
using Dates
using Temporal

aapl = yahoo("AAPL")
aapl = aapl["2015"]

t = aapl.index
aapl = aapl.values
Open = aapl[:,1]
High = aapl[:,2]
Low = aapl[:,3]
Close = aapl[:,4]
Volume = aapl[:,5]
HLC = [High Low Close]

subplot(411)
plot(t, Close, lw=2, c="k", label="AAPL")
plot(t, kama(Close), c="b", label="Kaufman AMA")
plot(t, trima(Close), c="g", label="Triangula MA")
plot(t, hma(Close), c="r", label="Hull MA")
grid(ls="-", c=[0.8,0.8,0.8])
legend(loc="best", frameon=false)

subplot(412)
plot(t, kst(Close), c="m", label="KST")
plot(t, sma(kst(Close),n=9), c="c", label="Signal")
plot([t[1],t[end]], [0,0], ls="--", c=[0.4,0.4,0.4])
grid(ls="-", c=[0.8,0.8,0.8])
legend(loc="best", frameon=false)

subplot(413)
plot(t, wpr(HLC), c=[1,0.5,0], label="Williams %R")
plot([t[1],t[end]], [-20,-20], c="r", ls="--")
plot([t[1],t[end]], [-80,-80], c="g", ls="--")
grid(ls="-", c=[0.8,0.8,0.8])
legend(loc="best", frameon=false)

subplot(414)
plot(t, cci(HLC), c="c", label="CCI")
plot([t[1],t[end]], [-100,-100], c="g", ls="--")
plot([t[1],t[end]], [100,100], c="r", ls="--")
grid(ls="-", c=[0.8,0.8,0.8])
legend(loc="best", frameon=false)

tight_layout()
