module Resource

using ..Client
using ..Model
using ..Service

export owned_games

function owned_games(steamid::Int64)::Games
    res = Client.getOwnedGames(steamid)
    games = Service.createGames(steamid, res)
    return games
end

end # module
