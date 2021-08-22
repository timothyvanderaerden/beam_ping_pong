%%%-------------------------------------------------------------------
%% @doc ping_pong public API
%% @end
%%%-------------------------------------------------------------------

-module(ping_pong_app).

-behaviour(application).

-export([start/2, stop/1,  ping/1, pong/0]).

start(_StartType, _StartArgs) ->
    register(pong_process, spawn(ping_pong_app, pong, [])),
    register(ping_process, spawn(ping_pong_app, ping, [3])),
    ping_pong_sup:start_link().

stop(_State) ->
    ok.

%% internal functions

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
