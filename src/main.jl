function get_owned_games(steamid::Integer)::JSON3.Array
    api_key = SECRETS["API_KEY"]

    r = HTTP.request(
        "GET",
        "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$api_key&steamid=$steamid&format=$RESPONSE_FORMAT&include_appinfo=true",
    )
    info(LOGGER, "Status: $(r.status)")
    owned_games = JSON3.read(r.body).response.games

    return owned_games
end

function get_friend_list(steamid::Integer)::JSON3.Array
    api_key = SECRETS["API_KEY"]

    r = HTTP.request(
        "GET",
        "http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=$api_key&steamid=$steamid&relationship=friend",
    )
    info(LOGGER, "Status: $(r.status)")
    friends = JSON3.read(r.body).friendslist.friends

    return friends
end

function get_player_summaries(steamids::Vector{Integer})::JSON3.Array
    api_key = SECRETS["API_KEY"]

    r = HTTP.request(
        "GET",
        "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=$api_key&steamids=$(join(steamids, ","))",
    )
    info(LOGGER, "Status: $(r.status)")
    player_summaries = JSON3.read(r.body).response.players
    return player_summaries
end

function get_app_ids(games::AbstractArray)::Vector{Integer}
    games_appids = Vector{Integer}()

    for game in games
        push!(games_appids, game.appid)
    end

    return games_appids
end

function get_common_games_appids(users_games::Tuple{Vararg{JSON3.Array}})::Vector{Integer}
    games_appids = Set{Vector{Integer}}()

    for games in users_games
        push!(games_appids, get_app_ids(games))
    end

    return intersect(games_appids...)
end

function friend_steamids(friend_list::JSON3.Array)::Vector{Integer}
    friend_steamids = Vector{Integer}()
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
