# moving regressions
@testset "Regressions" begin
    Random.seed!(SEED)
    @testset "Array" begin
        x = cumsum(randn(N))
        tmp = mlr_beta(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 2
        @test sum(isnan.(tmp)) != N
        tmp = mlr_slope(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = mlr_intercept(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = mlr(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = mlr_se(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = mlr_ub(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = mlr_lb(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = mlr_bands(tmp)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 3
        @test sum(isnan.(tmp)) != N
        tmp = mlr_rsq(x, adjusted=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
        tmp = mlr_rsq(x, adjusted=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        @test sum(isnan.(tmp)) != N
    end
    @testset "Temporal" begin
        x = TS(cumsum(randn(N)))
        # moving regressions
        tmp = mlr_beta(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 2
        tmp = mlr_slope(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = mlr_intercept(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = mlr(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = mlr_se(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = mlr_ub(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = mlr_lb(x)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = mlr_bands(tmp)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 3
        tmp = mlr_rsq(x, adjusted=true)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
        tmp = mlr_rsq(x, adjusted=false)
        @test size(tmp, 1) == N
        @test size(tmp, 2) == 1
    end
end
