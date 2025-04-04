%%%-----------------------------------------------------------------------------
%%% @copyright (C) 2012-2022, 2600Hz
%%% @doc
%%% @end
%%%-----------------------------------------------------------------------------
-module(ecallmgr_fs_event_stream).
-behaviour(gen_server).

-export([start_link/3]).
-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-include("ecallmgr.hrl").

-define(SERVER, ?MODULE).

-type bindings() :: atom() | [atom(), ...] | kz_term:ne_binary() | kz_term:ne_binaries().
-type event_packet_type() :: 1 | 2 | 4.

-export_type([event_packet_type/0]).

-record(state, {
    node :: atom(),
    bindings :: bindings(),
    ip :: inet:ip_address() | 'undefined',
    port :: inet:port_number() | 'undefined',
    socket :: inet:socket() | 'undefined',
    idle_alert = 'infinity' :: timeout(),
    switch_url :: kz_term:api_ne_binary(),
    switch_uri :: kz_term:api_ne_binary(),
    switch_info = 'false' :: boolean(),
    packet :: event_packet_type()
}).
-type state() :: #state{}.

%%%=============================================================================
%%% API
%%%=============================================================================

%%------------------------------------------------------------------------------
%% @doc Starts the server.
%% @end
%%------------------------------------------------------------------------------
-spec start_link(atom(), bindings(), event_packet_type()) -> kz_types:startlink_ret().
start_link(Node, Bindings, Packet) ->
    gen_server:start_link(?SERVER, [Node, Bindings, Packet], []).

%%%=============================================================================
%%% gen_server callbacks
%%%=============================================================================

%%------------------------------------------------------------------------------
%% @doc Initializes the server.
%% @end
%%------------------------------------------------------------------------------
-spec init([atom() | bindings() | event_packet_type()]) -> {'ok', state()} | {'stop', any()}.
init([Node, Bindings, Packet]) ->
    process_flag('trap_exit', 'true'),
    kz_util:put_callid(list_to_binary([kz_term:to_binary(Node), <<"-eventstream">>])),
    %%    request_event_stream(#state{
    %%        node = Node,
    %%        bindings = Bindings,
    %%        packet = Packet,
    %%        idle_alert = idle_alert_timeout()
    %%    }).
    #state{
        node = Node,
        bindings = Bindings,
        packet = Packet,
        idle_alert = idle_alert_timeout()
    }.

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
handle_cast(_Msg, #state{socket = 'undefined'} = State) ->
    lager:debug("unhandled cast: ~p", [_Msg]),
    {'noreply', State};
handle_cast(_Msg, #state{idle_alert = Timeout} = State) ->
    lager:debug("unhandled cast: ~p", [_Msg]),
    {'noreply', State, Timeout}.

%%------------------------------------------------------------------------------
%% @doc Handling all non call/cast messages.
%% @end
%%------------------------------------------------------------------------------
-spec handle_info(any(), state()) -> kz_types:handle_info_ret_state(state()).
handle_info({'EXIT', _, 'noconnection'}, State) ->
    {'stop', {'shutdown', 'noconnection'}, State};
handle_info({'EXIT', _, Reason}, State) ->
    {'stop', {'shutdown', Reason}, State};
handle_info(_Msg, #state{socket = 'undefined'} = State) ->
    lager:debug("unhandled message: ~p", [_Msg]),
    {'noreply', State};
handle_info(_Msg, #state{idle_alert = Timeout} = State) ->
    lager:debug("unhandled message: ~p", [_Msg]),
    {'noreply', State, Timeout}.

%%------------------------------------------------------------------------------
%% @doc This function is called by a `gen_server' when it is about to
%% terminate. It should be the opposite of `Module:init/1' and do any
%% necessary cleaning up. When it returns, the `gen_server' terminates
%% with Reason. The return value is ignored.
%%
%% @end
%%------------------------------------------------------------------------------
-spec terminate(any(), state()) -> 'ok'.
terminate(_Reason, _State) ->
    ok.

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

-spec idle_alert_timeout() -> timeout().
idle_alert_timeout() ->
    case kapps_config:get_integer(?APP_NAME, <<"event_stream_idle_alert">>, 0) of
        Timeout when Timeout =< 30 -> 'infinity';
        Else -> Else * ?MILLISECONDS_IN_SECOND
    end.
