module Client

using HTTP
using JSON3
using YAML

using ..Service
using ..Model

const SECRETS = YAML.load_file("./secrets.yaml")
const RESPONSE_FORMAT = "json"

function getOwnedGames(steamid::Int64)
    api_key = SECRETS["API_KEY"]

    res = HTTP.request(
        "GET",
        "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$api_key&steamid=$steamid&format=$RESPONSE_FORMAT&include_appinfo=true",
    )

    # We only care about the body, not any headers
    return JSON3.read(res.body).response
end

function get_friend_list(steamid::Int64)::JSON3.Array
    api_key = SECRETS["API_KEY"]

    r = HTTP.request(
        "GET",
        "http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=$api_key&steamid=$steamid&relationship=friend",
    )

    friends = JSON3.read(r.body).friendslist.friends

    # println("Friends: $friends")
    return friends
end

function get_player_summaries(steamids::Vector{Int64})::JSON3.Array
    api_key = SECRETS["API_KEY"]

    r = HTTP.request(
        "GET",
        "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=$api_key&steamids=$(join(steamids, ","))",
    )

    player_summaries = JSON3.read(r.body).response.players

    # println("player_summaries: $player_summaries")
    return player_summaries
end



end # module
