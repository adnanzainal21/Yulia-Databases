# chart patterns functions
@testset "Chart Patterns" begin
    Random.seed!(SEED)
    @testset "Array" begin
        X = cumsum(randn(N, 3), dims=1)
        tmp = renko(X, use_atr=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = renko(X, use_atr=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
    end
end
