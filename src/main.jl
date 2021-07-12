function common_games_appids(games::Tuple{Vararg{JSON3.Object}})::Set{Integer}

    games_appids = map(game_appids, games)
    common_game_appids = intersect(games_appids...)

    return common_game_appids

end

function owned_games(steam_account_id::Integer)::JSON3.Object

    api_key = secrets["API_KEY"]

    r = HTTP.request("GET", "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$api_key&steamid=$steam_account_id&format=$format&include_appinfo=true")
    info(LOGGER, "Status: $(r.status)" )
    owned_games = JSON3.read(r.body).response

    return owned_games

end

function game_appids(owned_games::JSON3.Object)::Set{Integer}

    game_appids = Set{Integer}()
    for game in owned_games.games
        push!(game_appids, game.appid)
    end

    return game_appids

end

function main()

    owned_games_1 = owned_games(Integer(secrets["STEAM_ACCOUNT_ID_1"]))
    owned_games_2 = owned_games(Integer(secrets["STEAM_ACCOUNT_ID_2"]))
    owned_games_3 = owned_games(Integer(secrets["STEAM_ACCOUNT_ID_3"]))
    owned_games_4 = owned_games(Integer(secrets["STEAM_ACCOUNT_ID_4"]))

    common_appids = common_games_appids(
        (owned_games_1, owned_games_2, owned_games_3, owned_games_4)
    )

    for appid in common_appids
        println(appid)
    end

end
