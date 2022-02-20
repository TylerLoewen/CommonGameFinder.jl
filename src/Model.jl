module Model

export Game, Games

struct Game
    appid::Int64
    name::String
    playtime_forever::Int64 # Minutes
end

Game() = Game(0, "", 0)
Game(appid, name) = Game(appid, name, 0)

struct Games
    account_id::Int64 # Account that owns the games
    games::Dict{Int64,Game}
end

Games() = Games(0, Dict{Int64,Game}())
Games(account_id) = Games(account_id, Dict{Int64,Game}())

end # module
