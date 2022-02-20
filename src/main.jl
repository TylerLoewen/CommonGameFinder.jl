using .Model

function get_owned_games(steamid::Int64)::Games
    api_key = SECRETS["API_KEY"]

    r = HTTP.request(
        "GET",
        "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$api_key&steamid=$steamid&format=$RESPONSE_FORMAT&include_appinfo=true",
    )
    info(LOGGER, "Status: $(r.status)")

    response = JSON3.read(r.body).response

    # Handle an account with no games
    games = if !isempty(response) && !isempty(response.games)
        tmp_games = Dict{Int64,Game}()

        for game in response.games
            tmp_games[game.appid] = Game(game.appid, game.name, game.playtime_forever)
        end

        return Games(steamid, tmp_games)
    else
        return Games(steamid)
    end

    return games
end

function get_friend_list(steamid::Int64)::JSON3.Array
    api_key = SECRETS["API_KEY"]

    r = HTTP.request(
        "GET",
        "http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=$api_key&steamid=$steamid&relationship=friend",
    )
    info(LOGGER, "Status: $(r.status)")
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
    info(LOGGER, "Status: $(r.status)")
    player_summaries = JSON3.read(r.body).response.players

    # println("player_summaries: $player_summaries")
    return player_summaries
end
