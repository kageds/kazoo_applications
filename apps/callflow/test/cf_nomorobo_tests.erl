%%%-----------------------------------------------------------------------------
%%% @copyright (C) 2014-2021, 2600Hz
%%% @doc
%%% @end
%%%-----------------------------------------------------------------------------
-module(cf_nomorobo_tests).

-include_lib("eunit/include/eunit.hrl").

nomorobo_branch_test_() ->
    ScoreBranch = [
        {0, <<"0">>},
        {1, <<"0">>},
        {2, <<"0">>},
        {3, <<"3">>},
        {4, <<"3">>},
        {5, <<"3">>},
        {6, <<"6">>},
        {7, <<"6">>},
        {8, <<"6">>},
        {9, <<"6">>},
        {10, <<"10">>}
    ],
    Keys = cf_nomorobo:nomorobo_branches({'branch_keys', [<<"0">>, <<"10">>, <<"3">>, <<"6">>]}),

    [
        ?_assertEqual(Branch, cf_nomorobo:nomorobo_branch(Score, Keys))
     || {Score, Branch} <- ScoreBranch
    ].
