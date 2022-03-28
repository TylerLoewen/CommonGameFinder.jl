module CommonGameFinder

using Memento
using YAML

export owned_games, friends, main

const LOGGER = getlogger(@__MODULE__)
const SECRETS = YAML.load_file("./secrets.yaml")

function __init__()
    return Memento.register(LOGGER)
end

include("Model.jl")
using .Model

include("Client.jl")
using .Client

function owned_games(steamid::Int64)::Games
    res = Client._getOwnedGames(steamid)
    games = _createGames(steamid, res)
    return games
end

function friends(steamid::Int64)::Friends
    friends_list = Client._getFriendList(steamid)

    steamids = Vector{Int64}()
    for friend in friends_list
        push!(steamids, parse(Int64, friend.steamid))
    end

    player_summaries = Client._getPlayerSummaries(steamids)
    friends = _createFriends(steamid, player_summaries)

    return friends
end

function _createGames(steamid, obj)::Games
    games = Dict{Int64,Game}()

    for game in obj
        games[game.appid] = Game(game.appid, game.name, game.playtime_forever)
    end

    return Games(steamid, games)
end

function _createFriends(steamid, obj)::Friends
    friends = Vector{Friend}()

    for friend in obj
        f = Friend(
            parse(Int64, friend.steamid),
            friend.personaname,
        )
        push!(friends, f)
    end

    return Friends(steamid, friends)
end

function main()
    # Get common appids of games between multiple accounts
    owned_games_1 = owned_games(Int64(SECRETS["STEAM_ACCOUNT_ID_1"]))
    # owned_games_2 = owned_games(Int64(SECRETS["STEAM_ACCOUNT_ID_2"]))
    # owned_games_3 = owned_games(Int64(SECRETS["STEAM_ACCOUNT_ID_3"]))
    # owned_games_4 = owned_games(Int64(SECRETS["STEAM_ACCOUNT_ID_4"]))

    for game in owned_games_1.games
        println(game)
    end

    friends1 = friends(Int64(SECRETS["STEAM_ACCOUNT_ID_1"]))
    friends2 = friends(Int64(SECRETS["STEAM_ACCOUNT_ID_2"]))

    for friend in friends1.friends
        println(friend)
    end

    # TODO: friend selector, get games of all selected friends, get common games between selected friends.
end

end # module
