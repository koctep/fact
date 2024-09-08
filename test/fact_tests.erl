-module(fact_tests).

-include_lib("eunit/include/eunit.hrl").

calc_test() ->
  [?assertEqual(1, fact:calc(0)),
   ?assertEqual(1, fact:calc(1)),
   ?assertEqual(2, fact:calc(2)),
   ?assertEqual(6, fact:calc(3)),
   ?assertEqual(120, fact:calc(5)),
   ?assertEqual(126886932185884164103433389335161480802865516174545192198801894375214704230400000000000000, fact:calc(64))
  ].

type_test() ->
  [?assertEqual({error, badarg}, fact:calc(-1)),
   ?assertEqual({error, badarg}, fact:calc(atop))
  ].
