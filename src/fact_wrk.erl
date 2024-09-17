-module(fact_wrk).

-export([start/3]).

start(Parent, Start, Step) ->
  Result = calc_part(Start, Step, 1),
  Parent ! {part, Result}.

calc_part(N, _Step, Acc) when N =< 1 -> Acc;
calc_part(N, Step, Acc) ->
  calc_part(N - Step, Step, Acc * N).
