module CommonGameFinder

using Base: Integer
using HTTP
using JSON3
using Memento
using YAML

const LOGGER = getlogger(@__MODULE__)
const secrets = YAML.load_file("secrets.yaml")
const format = "json"

include("main.jl")

main()

end # module
