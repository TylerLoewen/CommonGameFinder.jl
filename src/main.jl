function get_owned_games()

    api_key = secrets["API_KEY"]
    steam_account_id = secrets["STEAM_ACCOUNT_ID"]

    r = HTTP.request("GET", "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$api_key&steamid=$steam_account_id&format=$format")
    println(r.status)
    println(JSON3.read(r.body))

end
