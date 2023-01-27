-module(miningServer).
-export([server/1]).
%-export([loop/6, bitCoinOutput/0,start/0,start/1]).

bitCoinOutput()->
    receive
        {Finished,T} ->
            io:format("Completed BitCoin Mining ~w~n",[T]),
            bitCoinOutput();
        {Ping_Id, BitCoin, Hash, Condition} ->
            io:fwrite("~w\t~ts\t~ts~n",[Condition,BitCoin,Hash]),
            bitCoinOutput()
    end.

server(K) ->
    io:fwrite("server call invoked..~n"),
    Ser = spawn(bitCoin_server, bitCoinOutput,[]),
    CoreCount=erlang:system_info(logical_processors_available),
    loop(Ser, K, 0, 10000000, CoreCount, 5).

start(Ser)->
    CoreCount=erlang:system_info(logical_processors_available),
    loop(Ser, 5, 0, 1000000, CoreCount, 5).

% CPU_time = T/ 1000,
% Run_time = T2 / 1000,
% T3 = CPU_time / Run_time,
% io:format("CPU time: ~p seconds\n", [CPU_time]),
% io:format("Real time: ~p seconds\n", [Run_time]),
% io:format("Ratio is ~p \n", [T3]).

loop(Pong_pid,LeadingZeros,Start_iter,End_iter,CoreCount,SpawnCount) ->
    if(SpawnCount < CoreCount)->
        %io:format("Completed ~w~n",[SpawnCount]),
        spawn(bitCoin_worker,getBitCoins,[Pong_pid, LeadingZeros, Start_iter, End_iter,SpawnCount]),
        %loop(Pong_pid, LeadingZeros, End_iter, End_iter+1000000,CoreCount,SpawnCount+1);
        loop(Pong_pid, LeadingZeros, Start_iter, End_iter,CoreCount,SpawnCount+1);
    true ->
        io:format("Done with all BitCoin Mining~n")
end.
