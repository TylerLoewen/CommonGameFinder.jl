function get_owned_games(steamid::Integer)::JSON3.Object

    api_key = secrets["API_KEY"]

    r = HTTP.request("GET", "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$api_key&steamid=$steamid&format=$format&include_appinfo=true")
    info(LOGGER, "Status: $(r.status)" )
    owned_games = JSON3.read(r.body).response

    return owned_games

end

function get_friend_list(steamid::Integer)::JSON3.Array

    api_key = secrets["API_KEY"]

    r = HTTP.request("GET", "http://api.steampowered.com/ISteamUser/GetFriendList/v0001/?key=$api_key&steamid=$steamid&relationship=friend")
    info(LOGGER, "Status: $(r.status)" )
    friends = JSON3.read(r.body).friendslist.friends

    return friends

end

common_games_appids(games::Tuple{Vararg{JSON3.Object}})::Set{Integer} = intersect(map(games_appids, games)...)

function games_appids(games::JSON3.Object)::Set{Integer}

    game_appids = Set{Integer}()
    for game in games.games
        push!(game_appids, game.appid)
    end

    return game_appids

end

function friend_steamids(friend_list::JSON3.Array)

    friend_steamids = Vector{Integer}()
    for friend in friend_list
        push!(friend_steamids, parse(Int64, friend.steamid))
    end

    return friend_steamids

end


function main()

    # Get common appids of games between multiple accounts
    owned_games_1 = get_owned_games(Integer(secrets["STEAM_ACCOUNT_ID_1"]))
    owned_games_2 = get_owned_games(Integer(secrets["STEAM_ACCOUNT_ID_2"]))
    owned_games_3 = get_owned_games(Integer(secrets["STEAM_ACCOUNT_ID_3"]))
    owned_games_4 = get_owned_games(Integer(secrets["STEAM_ACCOUNT_ID_4"]))

    common_appids = common_games_appids(
        (owned_games_1, owned_games_2, owned_games_3, owned_games_4)
    )

    for appid in common_appids
        println(appid)
    end


    # Get list of friends steamids
    friends = get_friend_list(Integer(secrets["STEAM_ACCOUNT_ID_1"]))

    println(friends)

    friend_steamids_list = friend_steamids(friends)

    for friend_steamid in friend_steamids_list
        println(friend_steamid)
    end

end
