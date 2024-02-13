@testset "Utilities" begin
    @testset "Crossover/Crossunder" begin
        Random.seed!(SEED)
        x = cumsum(randn(N)) .+ X0
        y = x + randn(N)
        cxo = crossover(x, y)
        cxu = crossunder(x, y)
        @test any(cxo)
        @test any(cxu)
        @test !any(cxo .* cxu)  # ensure crossovers and crossunders never coincide
    end
end

