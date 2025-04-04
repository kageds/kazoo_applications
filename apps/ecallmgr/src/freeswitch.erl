%%%-----------------------------------------------------------------------------
%%% @copyright (C) 2010-2022, 2600Hz
%%% @doc
%%% @end
%%%-----------------------------------------------------------------------------
-module(freeswitch).

-export([
    version/1,
    version/2
]).
-export([noevents/1]).
-export([close/1]).
-export([
    getpid/1,
    getpid/2
]).
-export([
    bind/2,
    bind/3
]).
-export([
    fetch_reply/4,
    fetch_reply/5
]).
-export([
    api/2,
    api/3,
    api/4
]).
-export([
    bgapi/3,
    bgapi/4,
    bgapi/5,
    bgapi/6
]).
-export([
    ping/1
]).
-export([
    json_api/2,
    json_api/3,
    json_api/4,
    json_api/5
]).
-export([
    event/2,
    event/3
]).
-export([nixevent/2]).
-export([
    sendevent/3,
    sendevent_custom/3
]).
-export([sendmsg/3]).

-export([
    config/1,
    bgapi4/5
]).

-export([event_stream_framing/1, event_stream_framing/2]).
-export([get_option/2, set_option/3]).

-export([async_api/3]).

-include("ecallmgr.hrl").

-define(TIMEOUT, 5 * ?MILLISECONDS_IN_SECOND).
-define(BG_TIMEOUT, 10 * ?MILLISECONDS_IN_SECOND).

-define(FS_MODULE, mod_kazoo).

-type fs_json_api_ok() :: {'ok', kz_json:object()}.
-type fs_api_ok() :: mod_kazoo:fs_api_ok().
-type fs_api_error() :: mod_kazoo:fs_api_error().
-type fs_api_return() :: mod_kazoo:fs_api_return().
-type fs_json_api_return() :: fs_json_api_ok() | fs_api_error().
-export_type([
    fs_api_ok/0,
    fs_api_error/0,
    fs_api_return/0,
    fs_json_api_ok/0,
    fs_json_api_return/0
]).

%%FIXME need to get version from kapi_freeswitch
-spec version(atom()) -> fs_api_return().
version(_Node) -> {'ok', <<"mod_amqp_kageds">>}.

-spec version(atom(), pos_integer()) -> fs_api_return().
version(_Node, _Timeout) -> {'ok', <<"mod_amqp_kageds">>}.

-spec noevents(atom()) -> fs_api_return().
noevents(Node) -> ?FS_MODULE:noevents(Node).

-spec close(atom()) -> 'ok'.
close(Node) -> ?FS_MODULE:close(Node).

-spec getpid(atom()) -> fs_api_return().
getpid(Node) -> ?FS_MODULE:getpid(Node).

-spec getpid(atom(), pos_integer()) -> fs_api_return().
getpid(Node, Timeout) -> ?FS_MODULE:getpid(Node, Timeout).

%% FIXME - ??
-spec bind(atom(), atom()) -> fs_api_return().
bind(_Node, _Type) -> {'ok', <<"mod_amqp_bind">>}.

-spec bind(atom(), atom(), pos_integer()) -> fs_api_return().
bind(_Node, _Type, _Timeout) -> {'ok', <<"mod_amqp_bind">>}.

-spec fetch_reply(atom(), binary(), atom() | binary(), binary() | string()) -> 'ok'.
fetch_reply(Node, FetchID, Section, Reply) ->
    Resp = props:filter_undefined(
        [
            {<<"response">>, Reply},
            {<<"Fetch-UUID">>, FetchID},
            {<<"Switch-Nodename">>, kz_term:to_binary(Node)}
            | kz_api:default_headers(?APP_NAME, ?APP_VERSION)
        ]
    ),
    kapi_freeswitch:publish_fetch_resp(FetchID, Section, Resp).
-spec fetch_reply(
    atom(), binary(), atom() | binary(), binary() | string(), pos_integer() | 'infinity'
) ->
    'ok' | {'error', 'baduuid'}.
fetch_reply(Node, FetchID, Section, Reply, _Timeout) ->
    fetch_reply(Node, FetchID, Section, Reply).

-spec ping(atom()) -> fs_api_return().
ping(Node) ->
    Request = props:filter_undefined(
        [
            {<<"ping">>, <<"01234567890">>},
            {<<"Switch-Nodename">>, kz_term:to_binary(Node)}
            | kz_api:default_headers(?APP_NAME, ?APP_VERSION)
        ]
    ),
    case
        kz_amqp_worker:call(
            props:filter_undefined(Request),
            fun kapi_freeswitch:publish_ping_request/1,
            fun kapi_freeswitch:ping_resp_v/1
        )
    of
        {'error', Reason} -> {'error', Reason};
        {'ok', _JObj} -> {'ok', <<"pong">>}
    end.

-spec api(atom(), kz_term:text()) -> fs_api_return().
api(Node, Cmd) -> ?FS_MODULE:api(Node, Cmd).

-spec api(atom(), kz_term:text(), kz_term:text()) -> fs_api_return().
api(Node, Cmd, Args) ->
    Request = props:filter_undefined(
        [
            {<<"command">>, kz_term:to_binary(Cmd)},
            {<<"args">>, kz_term:to_binary(Args)},
            {<<"Switch-Nodename">>, kz_term:to_binary(Node)}
            | kz_api:default_headers(?APP_NAME, ?APP_VERSION)
        ]
    ),
    case
        kz_amqp_worker:call(
            props:filter_undefined(Request),
            fun kapi_freeswitch:publish_api_request/1,
            fun kapi_freeswitch:api_resp_v/1
        )
    of
        {'ok', JObj} -> {'ok', kz_json:get_value(<<"response">>, JObj)};
        Else -> Else
    end.

-spec api(atom(), kz_term:text(), kz_term:text(), timeout()) -> fs_api_return().
api(Node, Cmd, Args, Timeout) -> ?FS_MODULE:api(Node, Cmd, Args, Timeout).

-spec json_api(atom(), kz_term:text()) -> fs_json_api_return().
json_api(Node, Cmd) -> ?FS_MODULE:json_api(Node, Cmd).

-spec json_api(atom(), kz_term:text(), kz_term:api_object()) -> fs_json_api_return().
json_api(Node, Cmd, Args) -> ?FS_MODULE:json_api(Node, Cmd, Args).

-spec json_api(atom(), kz_term:ne_binary(), kz_term:ne_binary(), kz_term:api_object()) ->
    fs_json_api_return().
json_api(Node, UUID, Cmd, Args) -> ?FS_MODULE:json_api(Node, UUID, Cmd, Args).

-spec json_api(atom(), kz_term:api_ne_binary(), kz_term:text(), kz_term:api_object(), timeout()) ->
    fs_json_api_return().
json_api(Node, UUID, Cmd, Args, Timeout) -> ?FS_MODULE:json_api(Node, UUID, Cmd, Args, Timeout).

%%------------------------------------------------------------------------------
%% @doc Make a background API call to FreeSWITCH. The asynchronous reply is
%% sent to calling process after it is received. This function
%% returns the result of the initial `bgapi' call or `timeout' if FreeSWITCH fails
%% to respond.
%% @end
%%------------------------------------------------------------------------------
-spec bgapi(atom(), atom(), string() | binary()) -> fs_api_return().
bgapi(Node, Cmd, Args) ->
    Self = self(),
    UUID = kz_datamgr:get_uuid(),
    _ = kz_util:spawn(
        fun() ->
            Request = props:filter_undefined(
                [
                    {<<"command">>, kz_term:to_binary(Cmd)},
                    {<<"args">>, kz_term:to_binary(Args)},
                    {<<"Switch-Nodename">>, kz_term:to_binary(Node)}
                    | kz_api:default_headers(?APP_NAME, ?APP_VERSION)
                ]
            ),
            case
                kz_amqp_worker:call(
                    props:filter_undefined(Request),
                    fun kapi_freeswitch:publish_bgapi_request/1,
                    fun kapi_freeswitch:bgapi_resp_v/1,
                    ?BG_TIMEOUT
                )
            of
                {'ok', JObj} -> Self ! {'bgok', UUID, kz_json:get_value(<<"response">>, JObj)};
                {'error', 'timeout'} -> Self ! {'timeout', {Cmd, Args}};
                Else -> Self ! Else
            end
        end
    ),
    {'ok', UUID}.

-spec bgapi(atom(), atom(), string() | binary(), fun()) -> fs_api_return().
bgapi(Node, Cmd, Args, Fun) -> ?FS_MODULE:bgapi(Node, Cmd, Args, Fun).

-spec bgapi(atom(), atom(), string() | binary(), fun(), list()) -> fs_api_return().
bgapi(Node, Cmd, Args, Fun, CallBackParams) ->
    ?FS_MODULE:bgapi(Node, Cmd, Args, Fun, CallBackParams).

-spec bgapi(atom(), kz_term:ne_binary(), list(), atom(), string() | binary(), fun()) ->
    fs_api_return().
bgapi(Node, UUID, CallBackParams, Cmd, Args, Fun) ->
    ?FS_MODULE:bgapi(Node, UUID, CallBackParams, Cmd, Args, Fun).

-type event() :: atom() | kz_json:object().

-spec event(atom(), event() | [event()]) -> 'ok' | {'error', 'timeout' | 'exception'}.
event(Node, Events) -> ?FS_MODULE:event(Node, Events).

-spec event(atom(), event() | [event()], pos_integer()) ->
    'ok' | {'error', 'timeout' | 'exception'}.
event(Node, Events, Timeout) -> ?FS_MODULE:event(Node, Events, Timeout).

-spec nixevent(atom(), event() | [event()]) -> 'ok'.
nixevent(Node, Event) -> ?FS_MODULE:nixevent(Node, Event).

-spec sendevent(atom(), atom(), list()) -> 'ok'.
sendevent(Node, EventName, Headers) ->
    Event = props:filter_undefined(
        [
            {<<"FSEvent">>, EventName},
            {<<"FSEvent-Headers">>, Headers},
            {<<"Switch-Nodename">>, kz_term:to_binary(Node)}
            | kz_api:default_headers(?APP_NAME, ?APP_VERSION)
        ]
    ),
    kapi_freeswitch:publish_event(Event).

-spec sendevent_custom(atom(), atom(), list()) -> 'ok'.
sendevent_custom(Node, SubClassName, Headers) ->
    ?FS_MODULE:sendevent_custom(Node, SubClassName, Headers).

-spec sendmsg(atom(), kz_term:ne_binary(), list()) -> fs_api_return().
sendmsg(Node, UUID, Headers) ->
    FSHeaders = [{kz_term:to_binary(K), kz_term:to_binary(V)} || {K, V} <- Headers],
    Request = props:filter_undefined(
        [
            {<<"UUID">>, UUID},
            {<<"FSHeaders">>, kz_json:from_list(FSHeaders)},
            {<<"Switch-Nodename">>, kz_term:to_binary(Node)}
            | kz_api:default_headers(?APP_NAME, ?APP_VERSION)
        ]
    ),
    case
        kz_amqp_worker:call(
            props:filter_undefined(Request),
            fun kapi_freeswitch:publish_sendmsg_request/1,
            fun kapi_freeswitch:sendmsg_resp_v/1,
            ?TIMEOUT
        )
    of
        {'ok', JObj} ->
            Resp = kz_json:get_atom_value(<<"response">>, JObj),
            case Resp of
                'baduuid' -> {'error', 'baduuid'};
                'ok' -> 'ok'
            end;
        {'error', 'timeout'} ->
            {'timeout', {UUID, Headers}};
        Else ->
            Else
    end.

-spec config(atom()) -> 'ok'.
config(Node) -> ?FS_MODULE:config(Node).

-spec bgapi4(atom(), atom(), string() | binary(), fun(), list()) ->
    {'ok', binary()}
    | {'error', 'timeout' | 'exception' | binary()}.
bgapi4(Node, Cmd, Args, Fun, CallBackParams) ->
    ?FS_MODULE:bgapi4(Node, Cmd, Args, Fun, CallBackParams).

-spec event_stream_framing(atom(), 1 | 2 | 4) -> fs_api_return().
event_stream_framing(Node, PacketFraming) ->
    set_option(Node, <<"event-stream-framing">>, PacketFraming).

-spec event_stream_framing(atom()) -> fs_api_return().
event_stream_framing(Node) ->
    get_option(Node, <<"event-stream-framing">>).

-spec set_option(atom(), binary(), term()) -> fs_api_return().
set_option(Node, Option, Value) ->
    Args = [
        <<"node">>,
        kz_term:to_binary(node()),
        <<"option">>,
        kz_term:to_binary(Option),
        kz_term:to_binary(Value)
    ],
    api(Node, 'erlang', kz_binary:join(Args, <<" ">>)).

-spec get_option(atom(), binary()) -> fs_api_return().
get_option(Node, Option) ->
    Args = [
        <<"node">>,
        kz_term:to_binary(node()),
        "option",
        Option
    ],
    api(Node, 'erlang', kz_binary:join(Args, <<" ">>)).

-spec async_api(atom(), atom(), string() | binary()) -> fs_api_return().
async_api(Node, Cmd, Args) -> ?FS_MODULE:async_api(Node, Cmd, Args).
