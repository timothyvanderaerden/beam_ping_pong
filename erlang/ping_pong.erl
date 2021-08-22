-module(ping_pong).

-export([start/0, ping/1, pong/0]).

ping(0) ->
    pong_process ! finished,
    io:format("Ping finished~n", []);

ping(N) ->
    pong_process ! ping,
    receive
        pong ->
            io:format("Ping received pong~n", [])

    end,
    ping(N - 1).

pong() ->
    receive
        finised ->
            io:format("Pong finised~n", []);

        ping ->
            io:format("Pong received~n", []),
            ping_process ! pong,
            pong()
    end.

start() ->
    register(pong_process, spawn(ping_pong, pong, [])),
    register(ping_process, spawn(ping_pong, ping, [3])).