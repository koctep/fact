-module(fact).

-export([calc/1]).

calc(N) when is_integer(N) andalso  N >= 0 ->
  Cores = erlang:system_info(schedulers_online),
  Workers = start_workers(Cores, Cores, N, []),
  recv_parts(Workers, 1);
calc(_N) ->
  {error, badarg}.

start_workers(_Step, 0, _Start, Workers) -> Workers;
start_workers(Step, WorkersN, Start, Workers) ->
  Parent = self(),
  Pid = spawn(worker(Parent, Start, Step)),
  start_workers(Step, WorkersN - 1, Start - 1, [Pid | Workers]).

worker(Parent, Start, Step) ->
  fun() ->
      Result = calc_part(Start, Step, 1),
      Parent ! {self(), Result}
  end.

calc_part(N, _Step, Acc) when N =< 1 -> Acc;
calc_part(N, Step, Acc) ->
  calc_part(N - Step, Step, Acc * N).

recv_parts([], Acc) -> Acc;
recv_parts(Workers, Acc) ->
  receive
    {WorkerPid, Result} ->
      recv_parts(Workers -- [WorkerPid], Acc * Result)
  end.
