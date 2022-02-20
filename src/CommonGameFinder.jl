module CommonGameFinder

using HTTP
using JSON3
using Memento
using YAML

const LOGGER = getlogger(@__MODULE__)
const SECRETS = YAML.load_file("./secrets.yaml")
const RESPONSE_FORMAT = "json"

function __init__()
    return Memento.register(LOGGER)
end

include("Model.jl")
using .Model

include("main.jl")

# TODO? Use GetFriendList to get steam ids of all friends and then use GetPlayerSummaries to
# get the persona names of all friends. Display these names to user so they can choose which
# friends to find common games for

# Get common appids of games between multiple accounts
owned_games_1 = get_owned_games(Int64(SECRETS["STEAM_ACCOUNT_ID_1"]))
owned_games_2 = get_owned_games(Int64(SECRETS["STEAM_ACCOUNT_ID_2"]))
owned_games_3 = get_owned_games(Int64(SECRETS["STEAM_ACCOUNT_ID_3"]))
owned_games_4 = get_owned_games(Int64(SECRETS["STEAM_ACCOUNT_ID_4"]))

end # module
