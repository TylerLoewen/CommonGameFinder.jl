module Resource

using ..Client
using ..Model
using ..Service

export owned_games, friends

function owned_games(steamid::Int64)::Games
    res = Client.getOwnedGames(steamid)
    games = Service.createGames(steamid, res)
    return games
end

function friends(steamid::Int64)::Friends
    friends_list = Client.getFriendList(steamid)

    steamids = Vector{Int64}()
    for friend in friends_list
        push!(steamids, parse(Int64, friend.steamid))
    end

    player_summaries = Client.getPlayerSummaries(steamids)
    friends = Service.createFriends(steamid, player_summaries)

    return friends
end

end # module
