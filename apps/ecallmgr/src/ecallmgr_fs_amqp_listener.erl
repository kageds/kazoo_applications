%%%-----------------------------------------------------------------------------
%%% @copyright (C) 2025, Kage Design Service Ltd
%%% @doc
%%% @end
%%%-----------------------------------------------------------------------------
-module(ecallmgr_fs_amqp_listener).
-behaviour(gen_listener).

-export([
    start_link/0,
    handle_message/2
]).

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    handle_event/2,
    terminate/2,
    code_change/3
]).

-include("ecallmgr.hrl").
-include("fs_amqp.hrl").

-define(SERVER, ?MODULE).

-record(state, {}).
-type state() :: #state{}.

%% By convention, we put the options here in macros, but not required.
-define(BINDINGS, [
    {'freeswitch', []}
]).

-define(RESPONDERS, [{{?MODULE, 'handle_message'}, [{<<"*">>, <<"*">>}]}]).

-define(QUEUE_NAME, <<>>).
-define(QUEUE_OPTIONS, []).
-define(CONSUME_OPTIONS, []).

%%%=============================================================================
%%% API
%%%=============================================================================

%%------------------------------------------------------------------------------
%% @doc Starts the server.
%% @end
%%------------------------------------------------------------------------------
-spec start_link() -> kz_types:startlink_ret().
start_link() ->
    gen_listener:start_link(
        ?SERVER,
        [
            {'bindings', ?BINDINGS},
            {'responders', ?RESPONDERS},
            % optional to include
            {'queue_name', ?QUEUE_NAME},
            % optional to include
            {'queue_options', ?QUEUE_OPTIONS},
            % optional to include
            {'consume_options', ?CONSUME_OPTIONS}
            %%,{basic_qos, 1}                % only needed if prefetch controls
        ],
        []
    ).

%%%=============================================================================
%%% gen_server callbacks
%%%=============================================================================

%%------------------------------------------------------------------------------
%% @doc Initializes the server.
%% @end
%%------------------------------------------------------------------------------
-spec init([]) -> {'ok', state()}.
init([]) ->
    {'ok', #state{}}.

-spec handle_message(kz_json:object(), kz_term:proplist()) -> 'ok'.
handle_message(JObj, _Props) ->
    case kz_json:get_value(<<"section">>, JObj) of
        <<"directory">> -> handle_directory_message(JObj);
        <<"dialplan">> -> handle_dialplan_message(JObj);
        <<"configuration">> -> handle_configuration_message(JObj);
        _ -> handle_event(JObj)
    end.

handle_event(JObj) ->
    Props = kz_json:to_proplist(JObj),
    EventName = props:get_value(
        <<"Event-Subclass">>, Props, props:get_value(<<"Event-Name">>, Props)
    ),
    ID = get_id(Props),
    Node = get_node_name(Props),
    lager:info("send event message ~p", [EventName]),
    case EventName of
        <<"HEARTBEAT">> -> ecallmgr_fs_nodes:add(Node);
        _ -> ok
    end,
    ecallmgr_events:event(EventName, ID, Props, Node).

handle_configuration_message(JObj) ->
    Action = kz_json:get_value(<<"action">>, JObj),
    Conf = kz_json:get_value(<<"key_value">>, JObj),
    FSData = kz_json:to_proplist(kz_json:get_value(<<"variables">>, JObj)),
    FSId = get_id(FSData),
    Node = get_node_name(FSData),

    case Action of
        <<"request">> ->
            _ = kz_util:spawn(fun ecallmgr_fs_config:handle_config_req/4, [Node, FSId, Conf, FSData]);
        _ ->
            lager:info("unknown action: ~p", [Action])
    end.

handle_directory_message(JObj) ->
    Action = kz_json:get_value(<<"action">>, JObj),
    Props = kz_json:to_proplist(kz_json:get_value(<<"variables">>, JObj)),
    case Action of
        <<"request">> ->
            ecallmgr_fs_authn:handle_directory_lookup(get_id(Props), Props, get_node_name(Props));
        _ ->
            lager:info("unknown action: ~p", [Action])
    end.

handle_dialplan_message(JObj) ->
    Action = kz_json:get_value(<<"action">>, JObj),
    Props = kz_json:to_proplist(kz_json:get_value(<<"variables">>, JObj)),
    FSId = get_id(Props),
    Node = get_node_name(Props),
    CallId = get_callid(Props),

    case Action of
        <<"request">> ->
            _ = kz_util:spawn(fun process_route_req/5, [
                'dialplan', Node, FSId, CallId, Props ++ interaction_props(Node, CallId, Props)
            ]);
        _ ->
            lager:info("unknown action: ~p", [Action])
    end.

%%------------------------------------------------------------------------------
%% @doc Handling call messages.
%% @end
%%------------------------------------------------------------------------------
-spec handle_call(any(), kz_term:pid_ref(), state()) -> kz_types:handle_call_ret_state(state()).
handle_call(_Request, _From, State) ->
    {'reply', {'error', 'not_implemented'}, State}.

%%------------------------------------------------------------------------------
%% @doc Handling cast messages.
%% @end
%%------------------------------------------------------------------------------
-spec handle_cast(any(), state()) -> kz_types:handle_cast_ret_state(state()).
handle_cast({'gen_listener', {'created_queue', _QueueNAme}}, State) ->
    {'noreply', State};
handle_cast({'gen_listener', {'is_consuming', _IsConsuming}}, State) ->
    {'noreply', State};
handle_cast(_Msg, State) ->
    {'noreply', State}.

%%------------------------------------------------------------------------------
%% @doc Handling all non call/cast messages.
%% @end
%%------------------------------------------------------------------------------
-spec handle_info(any(), state()) -> kz_types:handle_info_ret_state(state()).
handle_info(_Info, State) ->
    {'noreply', State}.

%%------------------------------------------------------------------------------
%% @doc Allows listener to pass options to handlers.
%% @end
%%------------------------------------------------------------------------------
-spec handle_event(kz_json:object(), kz_term:proplist()) -> gen_listener:handle_event_return().
handle_event(_JObj, _State) ->
    {'reply', []}.

%%------------------------------------------------------------------------------
%% @doc This function is called by a `gen_server' when it is about to
%% terminate. It should be the opposite of `Module:init/1' and do any
%% necessary cleaning up. When it returns, the `gen_server' terminates
%% with Reason. The return value is ignored.
%% @end
%%------------------------------------------------------------------------------
-spec terminate(any(), state()) -> 'ok'.
terminate(_Reason, _State) ->
    lager:debug("listener terminating: ~p", [_Reason]).

%%------------------------------------------------------------------------------
%% @doc Convert process state when code is changed.
%% @end
%%------------------------------------------------------------------------------
-spec code_change(any(), state(), any()) -> {'ok', state()}.
code_change(_OldVsn, State, _Extra) ->
    {'ok', State}.

%%%=============================================================================
%%% Internal functions
%%%=============================================================================
-spec get_node_name(kz_term:proplist()) -> atom().
get_node_name(Props) ->
    props:get_atom_value(<<"Switch-Nodename">>, Props).

-spec get_id(kz_term:proplist()) -> kz_term:ne_binary().
get_id(Props) ->
    props:get_first_defined([<<"Fetch-UUID">>, <<"Unique-ID">>], Props).

-spec get_callid(kz_term:proplist()) -> kz_term:ne_binary().
get_callid(Props) ->
    props:get_first_defined(
        [<<"Unique-ID">>, <<"Channel-Call-UUID">>, <<"variable_sip_call_id">>], Props
    ).

-spec interaction_props(atom(), kz_term:ne_binary(), kz_term:proplist()) -> kz_term:proplist().
interaction_props(Node, CallId, FSData) ->
    case props:get_value(?GET_CCV(<<?CALL_INTERACTION_ID>>), FSData) of
        'undefined' ->
            InterActionId = props:get_value(
                ?GET_CUSTOM_HEADER(<<"Call-Interaction-ID">>), FSData, ?CALL_INTERACTION_DEFAULT
            ),
            kz_util:spawn(fun ecallmgr_fs_command:set/3, [
                Node, CallId, [{<<?CALL_INTERACTION_ID>>, InterActionId}]
            ]),
            [{?GET_CCV(<<?CALL_INTERACTION_ID>>), InterActionId}];
        _InterActionId ->
            []
    end.

-spec process_route_req(
    atom(), atom(), kz_term:ne_binary(), kz_term:ne_binary(), kzd_freeswitch:data()
) -> 'ok'.
process_route_req(Section, Node, FetchId, CallId, Props) ->
    kz_util:put_callid(CallId),
    case kz_term:is_true(props:get_value(<<"variable_recovered">>, Props)) of
        'false' ->
            do_process_route_req(Section, Node, FetchId, CallId, Props);
        'true' ->
            lager:debug("recovered channel already exists on ~s, park it", [Node]),
            JObj = kz_json:from_list([
                {<<"Routes">>, []},
                {<<"Method">>, <<"park">>}
            ]),
            ecallmgr_fs_router_util:reply_affirmative(Section, Node, FetchId, CallId, JObj, Props)
    end.

-spec do_process_route_req(
    atom(), atom(), kz_term:ne_binary(), kz_term:ne_binary(), kzd_freeswitch:data()
) -> 'ok'.
do_process_route_req(Section, Node, FetchId, CallId, Props) ->
    Filtered = ecallmgr_fs_loopback:filter(Node, CallId, Props),
    case ecallmgr_fs_router_util:search_for_route(Section, Node, FetchId, CallId, Filtered) of
        'ok' ->
            lager:debug("xml fetch dialplan ~s finished without success", [FetchId]);
        {'ok', JObj} ->
            lager:debug("route response recv, attempting to start call handling"),
            ecallmgr_fs_channels:update(CallId, #channel.handling_locally, 'true'),
            maybe_start_call_handling(Node, FetchId, CallId, JObj)
    end.

-spec maybe_start_call_handling(atom(), kz_term:ne_binary(), kz_term:ne_binary(), kz_json:object()) ->
    'ok'.
maybe_start_call_handling(Node, FetchId, CallId, JObj) ->
    case kz_json:get_value(<<"Method">>, JObj) of
        <<"error">> -> lager:debug("sent error response to ~s, not starting call handling", [Node]);
        _Else -> start_call_handling(Node, FetchId, CallId, JObj)
    end.

-spec start_call_handling(atom(), kz_term:ne_binary(), kz_term:ne_binary(), kz_json:object()) ->
    'ok'.
start_call_handling(Node, FetchId, CallId, JObj) ->
    ServerQ = kz_json:get_value(<<"Server-ID">>, JObj),
    CCVs =
        kz_json:set_values(
            [
                {<<"Application-Name">>, kz_json:get_value(<<"App-Name">>, JObj)},
                {<<"Application-Node">>, kz_json:get_value(<<"Node">>, JObj)}
            ],
            kz_json:get_json_value(<<"Custom-Channel-Vars">>, JObj, kz_json:new())
        ),
    _Evt = ecallmgr_call_sup:start_event_process(Node, CallId),
    _Ctl = ecallmgr_call_sup:start_control_process(Node, CallId, FetchId, ServerQ, CCVs),

    lager:debug("started event ~p and control ~p processes", [_Evt, _Ctl]),

    _ = ecallmgr_fs_command:set(Node, CallId, kz_json:to_proplist(CCVs)),
    lager:debug("xml fetch dialplan ~s finished with success", [FetchId]).
