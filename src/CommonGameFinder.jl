module CommonGameFinder

using HTTP
using Memento

const LOGGER = getlogger(@__MODULE__)

export hello

include("main.jl")

end # module
