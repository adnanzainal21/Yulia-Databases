@testset "Running Calculations" begin
    Random.seed!(SEED)
    @testset "Array" begin
        x = cumsum(randn(N))
        X = cumsum(randn(N, 4), dims=1)
        tmp = diffn(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = diffn(X)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == size(X,2)
        @test sum(isnan.(tmp)) != N
        tmp = runmean(x, cumulative=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runmean(x, cumulative=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runsum(x, cumulative=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = wilder_sum(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runmad(x, cumulative=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runmad(x, cumulative=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runvar(x, cumulative=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runvar(x, cumulative=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runsd(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runcov(x, x.*rand(N), cumulative=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runcov(x, x.*rand(N), cumulative=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runcor(x, x.*rand(N), cumulative=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runcor(x, x.*rand(N), cumulative=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runmin(x, cumulative=true, inclusive=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runmin(x, cumulative=true, inclusive=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runmin(x, cumulative=false, inclusive=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runmin(x, cumulative=false, inclusive=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runmax(x, cumulative=true, inclusive=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runmax(x, cumulative=true, inclusive=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runmax(x, cumulative=false, inclusive=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = runmax(x, cumulative=false, inclusive=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = mode(map(xi->round(xi), x))
        @test size(tmp, 1) == 1
        @test size(tmp, 2) == 1
        @test !isnan(tmp)
        tmp = runquantile(x, cumulative=true)
        @test !isnan(tmp[2]) && isnan(tmp[1])
        @test tmp[10] == quantile(x[1:10], 0.05)
        tmp = runquantile(x, cumulative=false)
        @test tmp[10] == quantile(x[1:10], 0.05)
        n = 20
        tmp = runacf(x, n=n, maxlag=15, cumulative=true)
        @test all(tmp[n:end,1] .== 1.0)
        tmp = runacf(x, n=n, maxlag=15, cumulative=false)
        @test all(tmp[n:end,1] .== 1.0)
    end
    @testset "Temporal" begin
        # running calculations
        x = TS(cumsum(randn(N)))
        X = TS(cumsum(randn(N, 4), dims=1))
        tmp = runmean(x, cumulative=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runmean(x, cumulative=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runsum(x, cumulative=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = wilder_sum(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runmad(x, cumulative=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runmad(x, cumulative=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runvar(x, cumulative=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runvar(x, cumulative=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runsd(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runcov(X[:,1], X[:,4], cumulative=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runcov(X[:,1], X[:,4], cumulative=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runcor(X[:,1], X[:,4], cumulative=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runcor(X[:,1], X[:,4], cumulative=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runmin(x, cumulative=true, inclusive=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runmin(x, cumulative=true, inclusive=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runmin(x, cumulative=false, inclusive=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runmin(x, cumulative=false, inclusive=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runmax(x, cumulative=true, inclusive=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runmax(x, cumulative=true, inclusive=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runmax(x, cumulative=false, inclusive=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runmax(x, cumulative=false, inclusive=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = runquantile(x, cumulative=true)
        @test !isnan(tmp.values[2,1]) && isnan(tmp.values[1,1])
        @test tmp.values[10,1] == quantile(x.values[1:10,1], 0.05)
        tmp = runquantile(x, cumulative=false)
        @test tmp.values[10,1] == quantile(x.values[1:10,1], 0.05)
        n = 20
        tmp = runacf(x, n=n, maxlag=15, cumulative=true)
        @test all(tmp.values[n:end,1] .== 1.0)
        tmp = runacf(x, n=n, maxlag=15, cumulative=false)
        @test all(tmp.values[n:end,1] .== 1.0)
    end
end
