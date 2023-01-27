-module(findBitcoin).
-import(lists,[sum/1]).
-export([getBitCoins/5, randomStr/2 ]).

randomStr(Len, Chars) ->
    lists:foldl(fun(_, Counter) ->
                        [lists:nth(rand:uniform(length(Chars)),
                                   Chars)]
                            ++ Counter
                end, [], lists:seq(1, Len)).

getBitCoins(Pid, LeadingZeros, Start_iter, End_iter,Condition) ->
    if

      Start_iter < End_iter ->
        NumberList = lists:seq(48,57),
        LowerAlphabets = lists:seq($a,$z),
        UpperAlphabets = lists:seq($A,$Z),
        TotalSequence = LowerAlphabets ++ NumberList ++ UpperAlphabets,
        Rand = randomStr(10,TotalSequence),
        Random_string = "sadhvithula;" ++ Rand,
         Hash = binary:encode_hex(crypto:hash(sha256, Random_string)),
         {Zeros, _} = split_binary(Hash,LeadingZeros),
         ZerosList = bitstring_to_list(Zeros),
         Sum = sum(ZerosList),
         Value = LeadingZeros * 48,
         if
            Sum == Value ->
                Pid ! {self(),Random_string,Hash,Condition},
               getBitCoins(Pid, LeadingZeros, Start_iter+1, End_iter,Condition);
            true ->
               getBitCoins(Pid,LeadingZeros, Start_iter+1, End_iter,Condition)

         end;
      true ->
        Pid ! {self(),Condition}
   end.
