# volatility functions
@testset "Volatility" begin
    Random.seed!(SEED)
    @testset "Array" begin
        x = cumsum(randn(N))
        X = cumsum(randn(N, 3), dims=1)
        tmp = bbands(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 3
        @test sum(isnan.(tmp)) != N
        tmp = tr(X)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = atr(X)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = keltner(X)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 3
        @test sum(isnan.(tmp)) != N
    end
    @testset "Temporal" begin
        x = TS(cumsum(randn(N)))
        X = TS(cumsum(randn(N, 3), dims=1))
        tmp = bbands(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 3
        tmp = tr(X)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = atr(X)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = keltner(X)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 3
    end
end
