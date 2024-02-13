# moving average functions
@testset "Moving Averages" begin
    Random.seed!(SEED)
    @testset "Array" begin
        x = cumsum(randn(N))
        X = cumsum(randn(N, 2), dims=1)
        tmp = sma(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = mama(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 2
        @test sum(isnan.(tmp)) != N
        tmp = ema(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = wma(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = hma(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = trima(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = mma(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = tema(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = dema(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = swma(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = kama(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = alma(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = zlema(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = vwma(X)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1        
        tmp = vwap(X)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1  
        tmp = hama(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1           
    end
    @testset "Temporal" begin
        x = TS(cumsum(randn(N)))
        X = TS(cumsum(randn(N, 2), dims=1))
        # moving average functions
        tmp = sma(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = mama(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 2
        tmp = ema(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = wma(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = hma(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = trima(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = mma(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = tema(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = dema(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = swma(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = kama(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = alma(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = zlema(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = vwma(X)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1  
        tmp = vwap(X)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1  
        tmp = hama(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1           
    end
end
