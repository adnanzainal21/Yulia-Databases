# analytical
@testset "Chaos" begin
    Random.seed!(SEED)
    @testset "Array" begin
        x = randn(252)
        # helpers
        a, b = Indicators.divide(x)
        @test [a; b] == x
        x = randn(101)
        a, b = Indicators.divide(x)
        @test [a; b] == x
        # workhorses
        h = hurst(x, n=100)
        @test size(h) == size(x)
        rs = rsrange(x)
        @test size(rs) == size(x)
        x = randn(100)
    end
    @testset "Temporal" begin
        # chaos indicators
        x = TS(randn(N))
        tmp = hurst(x)
        @test size(tmp,1) == size(x,1)
        @test size(tmp,2) == 1
        tmp = rsrange(x)
        @test size(tmp,1) == size(x,1)
        @test size(tmp,2) == 1
    end
end
