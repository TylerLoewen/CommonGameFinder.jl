module Service

using ..Model

function createGames(steamid, obj)::Games
    return if !isempty(obj) && !isempty(obj.games)
        games = Dict{Int64,Game}()

        for game in obj.games
            games[game.appid] = Game(game.appid, game.name, game.playtime_forever)
        end

        return Games(steamid, games)
    else
        return Games(steamid)
    end
end

function createFriends(steamid, obj)::Friends
    friends = Vector{Friend}()

    for friend in obj
        steamid = parse(Int64, friend.steamid)
        push!(friends, Friend(steamid, friend.personaname))
    end

    return Friends(steamid, friends)
end

end # module
