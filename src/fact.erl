-module(fact).

-export([calc/1]).

calc(N) when is_integer(N) andalso  N >= 0 ->
  calc(N, 1);
calc(_N) ->
  {error, badarg}.

calc(0, Acc) -> Acc;
calc(N, Acc) ->
  calc(N - 1, Acc * N).
