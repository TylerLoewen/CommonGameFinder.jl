module CommonGameFinder

using Memento
using YAML

const LOGGER = getlogger(@__MODULE__)
const SECRETS = YAML.load_file("./secrets.yaml")

function __init__()
    return Memento.register(LOGGER)
end

include("Model.jl")
using .Model

include("Service.jl")
using .Service

include("Client.jl")
using .Client

include("Resource.jl")
using .Resource

# Get common appids of games between multiple accounts
owned_games_1 = owned_games(Int64(SECRETS["STEAM_ACCOUNT_ID_1"]))
# owned_games_2 = owned_games(Int64(SECRETS["STEAM_ACCOUNT_ID_2"]))
# owned_games_3 = owned_games(Int64(SECRETS["STEAM_ACCOUNT_ID_3"]))
# owned_games_4 = owned_games(Int64(SECRETS["STEAM_ACCOUNT_ID_4"]))

for game in owned_games_1.games
    println(game)
end

friends1 = friends(Int64(SECRETS["STEAM_ACCOUNT_ID_1"]))

for friend in friends1.friends
    println(friend)
end

end # module
