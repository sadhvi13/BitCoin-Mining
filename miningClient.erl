-module(miningClient).
-export([start_pong/0, userInput/0]).

start_pong() ->
    ProcessID = spawn(bitCoin_server,bitCoinOutput,[]),
    io:format("Server id ~p~n",[ProcessID]),
    rpc:call('divya@192.168.0.61',bitCoin_server,start,[ProcessID]),
    io:fwrite("Call Sent \n").

userInput() ->
    {ok, Term} = io:read("Enter a number: "),
    io:format("The number you entered plus one is: ~w~n", [Term + 1]).
