module CommonGameFinder

using HTTP
using JSON3
using Memento
using YAML

const LOGGER = getlogger(@__MODULE__)
const secrets = YAML.load_file("secrets.yaml")
const format = "json"

export get_owned_games

include("main.jl")

get_owned_games()

end # module
