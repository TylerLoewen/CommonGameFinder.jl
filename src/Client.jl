module Client

using HTTP
using JSON3
using YAML

using ..CommonGameFinder
using ..Model

const SECRETS = YAML.load_file("./secrets.yaml")
const RESPONSE_FORMAT = "json"

function _games(steamid::Int64)
    api_key = SECRETS["API_KEY"]

    res = HTTP.request(
        "GET",
        "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$api_key&steamid=$steamid&format=$RESPONSE_FORMAT&include_appinfo=true",
    )

    # We only care about the body, not any headers
    return JSON3.read(res.body).response.games
end

function _friends(steamid::Int64)
    api_key = SECRETS["API_KEY"]

    r = HTTP.request(
        "GET",
        "http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=$api_key&steamid=$steamid&relationship=friend",
    )

    return JSON3.read(r.body).friendslist.friends
end

function _players(steamids::Vector{Int64})
    api_key = SECRETS["API_KEY"]

    r = HTTP.request(
        "GET",
        "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=$api_key&steamids=$(join(steamids, ","))",
    )

    return JSON3.read(r.body).response.players
end

end # module
