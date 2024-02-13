using Temporal, Indicators, GLMakie

N = 252
X = quandl("CHRIS/CME_GC1", rows=N)
x = rename(cl(X), :Settle => :Gold)

lookback = 20
n_sigma = 2.0
reg = mlr_bands(x, n=lookback, se=n_sigma)
coef = mlr_beta(x, n=lookback)
rsq = mlr_rsq(x, n=lookback)

fig = Figure()
fig[1,1] = Axis(fig, title="Corn Futures")
lines!(fig[1,1], x.values[:,1], label="Price (Observed)", linewidth=3, color=:black)
lines!(fig[1,1], reg[:MLR].values[:], label="Predicted", linewidth=1, color=:blue)
lines!(fig[1,1], reg[:MLRLB].values[:], label="-2 Std Err", linewidth=1, color=:red)
lines!(fig[1,1], reg[:MLRUB].values[:], label="+2 Std Err", linewidth=1, color=:green)
band!(1:N, reg.values[:,1], reg.values[:,3], color="#80800040")
axislegend(bgcolor="#00000040", framecolor="#00000040", position=:cb, orientation=:horizontal)
lines(fig[2,1], 1:N, coef[:Slope].values[:], label="Beta", linewidth=2, color=:purple)
lines!(fig[2,1], 1:N, rsq.values[:], label="R-Squared", linewidth=2, color="#FF8000")
band!(1:N, zeros(N), rsq.values[:], color="#FF800040")
hlines!(current_axis(), [0.0, 1.0], linestyle=:dash, linewidth=1)
axislegend(bgcolor="#00000040", framecolor="#00000040", position=:cb, orientation=:horizontal)
