-module(fact_mgr).

-export([start/0]).

start() ->
  spawn(fun enter_loop/0).

enter_loop() ->
  register(?MODULE, self()),
  Nodes = application:get_env(kernel, nodes, [node()]),
  lists:foreach(fun send_announce/1, Nodes),
  Cores = erlang:system_info(schedulers_online),
  State = #{node() => Cores},
  loop(State).

loop(State) ->
  receive
    {cores, Node, Cores} ->
      NewState = State#{Node => Cores},
      case State of
        #{Node := _} ->
          loop(State);
        _ ->
          send_announce(Node),
          loop(NewState)
      end;
    {get_workers, From} ->
      From ! {workers, State},
      loop(State);
    {calc, Pid, Start, Step} ->
      Cores = erlang:system_info(schedulers_online),
      start_workers(Cores, Pid, Start, Step),
      loop(State)
  end.

send_announce(Node) when Node /= node() ->
  Cores = erlang:system_info(schedulers_online),
  spawn(fun() ->
            {?MODULE, Node} ! {cores, node(), Cores}
        end);
send_announce(_Node) -> ok.

start_workers(0, _, _, _) -> ok;
start_workers(WorkerNumber, AnswerTo, Start, Step) ->
  spawn(fact_wrk, start, [AnswerTo, Start, Step]),
  start_workers(WorkerNumber - 1, AnswerTo, Start - 1, Step).
