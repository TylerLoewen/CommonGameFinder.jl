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

function get_app_ids(games::AbstractArray)
    games_appids = Vector{Int64}()

    for game in games
        push!(games_appids, game.appid)
    end

    return games_appids
end

function get_common_games_appids(users_games...)
    # println(users_games)
    games_appids = Set{Vector{Int64}}()

    # TODO: Change this to intersect on entire game objects no only appids
    # TODO: Return list of Game objects, not only appids
    # TODO FUTURE FUTURE: Store a local "database" (json file) of Games objects to read from
    # for user in users_games
    #     for game in user.games
    #         push!(games_appids, game.appid)
    #     end
    # end

    return intersect(games_appids...)
end

function friend_steamids(friend_list::JSON3.Array)::Vector{Int64}
    friend_steamids = Vector{Int64}()
    for friend in friend_list
        push!(friend_steamids, parse(Int64, friend.steamid))
    end

    return friend_steamids
end

function friend_names(friend_list::JSON3.Array)::Vector{AbstractString}
    friend_names = Vector{AbstractString}()
    for friend in friend_list
        push!(friend_names, friend.personaname)
    end

    return friend_names
end
