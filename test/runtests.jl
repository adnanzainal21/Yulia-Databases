using Indicators
using Temporal
using Test
using Random
using Statistics

const global N = 252
const global X0 = 50.0
const global SEED = 1

TEST_FILES = [
    "util.jl",
    "run.jl",
    "ma.jl",
    "mom.jl",
    "vol.jl",
    "reg.jl",
    "patterns.jl",
    "chaos.jl",
    "trendy.jl",
]

@inbounds for testfile in TEST_FILES
    include(testfile)
end
