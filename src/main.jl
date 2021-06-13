calculate_shared_games(game_ids::Tuple{Vararg{Set{Integer}}}) = intersect(game_ids...)

function get_owned_game_ids(steam_account_id::Integer)::Set{Integer}

    api_key = secrets["API_KEY"]

    r = HTTP.request("GET", "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$api_key&steamid=$steam_account_id&format=$format")
    info(LOGGER, "Status: $(r.status)" )
    response = JSON3.read(r.body).response

    owned_games = Set{Integer}()
    for game in response.games
        push!(owned_games, game.appid)
    end

    return owned_games

end

function main()

    acc_1 = get_owned_game_ids(Integer(secrets["STEAM_ACCOUNT_ID_1"]))
    acc_2 = get_owned_game_ids(Integer(secrets["STEAM_ACCOUNT_ID_2"]))
    acc_3 = get_owned_game_ids(Integer(secrets["STEAM_ACCOUNT_ID_3"]))
    acc_4 = get_owned_game_ids(Integer(secrets["STEAM_ACCOUNT_ID_4"]))

    common_games = calculate_shared_games((acc_1, acc_2, acc_3, acc_4))

    println("Shared games:")

    for game in common_games
        println(game)
    end

end
