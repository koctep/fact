-module(fact).

-export([start/0]).
-export([calc/1]).

start() ->
  fact_mgr:start().

calc(N) when is_integer(N) andalso  N >= 0 ->
  fact_mgr ! {get_workers, self()},
  receive
    {workers, State} ->
      TotalCores = distribute(State, N),
      recv_parts(TotalCores, 1)
  end;
calc(_N) ->
  {error, badarg}.

distribute(State, N) ->
  Self = self(),
  Step = maps:fold(fun(_, Cores, Acc) -> Acc + Cores end, 0, State),
  maps:fold(fun(Node, Cores, Start) ->
                {fact_mgr, Node} ! {calc, Self, Start, Step},
                Start - Cores
            end, N, State),
  Step.

recv_parts(0, Acc) -> Acc;
recv_parts(N, Acc) ->
  receive
    {part, Result} ->
      recv_parts(N - 1, Acc * Result)
  end.
