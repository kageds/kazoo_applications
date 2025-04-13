%%%-----------------------------------------------------------------------------
%%% @copyright (C) 2025, Kage Design Services Ltd
%%% @doc FreeSwitch events messages.
%%% @author Edouard Swiac
%%% @end
%%%-----------------------------------------------------------------------------
-module(kapi_freeswitch).

-export([
    bind_q/2,
    unbind_q/2,
    directory_resp/1,
    directory_resp_v/1,
    api_request/1,
    api_request_v/1,
    api_resp_v/1,
    bgapi_request/1,
    bgapi_request_v/1,
    bgapi_resp_v/1,
    ping_request/1,
    ping_request_v/1,
    ping_resp_v/1,
    sendmsg_request/1,
    sendmsg_request_v/1,
    sendmsg_resp_v/1,
    event/1,
    event_v/1,
    declare_exchanges/0,
    publish_fetch_resp/3,
    publish_api_request/1,
    publish_bgapi_request/1,
    publish_ping_request/1,
    publish_sendmsg_request/1,
    publish_event/1
]).

-include_lib("kazoo_stdlib/include/kz_types.hrl").
-include_lib("kazoo_amqp/include/kz_api.hrl").

-include("kapi_freeswitch.hrl").

-spec bind_q(kz_term:ne_binary(), kz_term:proplist()) -> 'ok'.
bind_q(Queue, Props) ->
    bind_to_q(Queue, props:get_value('restrict_to', Props), Props).

bind_to_q(Q, 'undefined', _Props) ->
    'ok' = kz_amqp_util:bind_q_to_exchange(Q, <<"FreeSWITCH.*.*.*">>, ?FREESWITCH_EXCHANGE);
bind_to_q(_Q, [], _Props) ->
    'ok'.

-spec unbind_q(kz_term:ne_binary(), kz_term:proplist()) -> 'ok'.
unbind_q(Queue, Props) ->
    unbind_q_from(Queue, props:get_value('restrict_to', Props), Props).

unbind_q_from(Q, 'undefined', _Props) ->
    'ok' = kz_amqp_util:unbind_q_from_exchange(Q, <<"FreeSWITCH.*.*.*">>, ?FREESWITCH_EXCHANGE);
unbind_q_from(_Q, [], _Props) ->
    'ok'.

%%------------------------------------------------------------------------------
%% @doc Directory Response.
%% Takes proplist, creates JSON string or error.
%% @end
%%------------------------------------------------------------------------------
-spec directory_resp(kz_term:api_terms()) ->
    {'ok', iolist()}
    | {'error', string()}.
directory_resp(Prop) when is_list(Prop) ->
    case directory_resp_v(Prop) of
        'true' ->
            kz_api:build_message(Prop, ?DIRECTORY_RESP_HEADERS, ?OPTIONAL_DIRECTORY_RESP_HEADERS);
        'false' ->
            {'error', "Proplist failed validation for directory_resp"}
    end;
directory_resp(JObj) ->
    directory_resp(kz_json:to_proplist(JObj)).

-spec directory_resp_v(kz_term:api_terms()) -> boolean().
directory_resp_v(Prop) when is_list(Prop) ->
    Valid = kz_api:validate(
        Prop, ?DIRECTORY_RESP_HEADERS, ?DIRECTORY_RESP_VALUES, ?DIRECTORY_RESP_TYPES
    ),
    Valid;
directory_resp_v(JObj) ->
    directory_resp_v(kz_json:to_proplist(JObj)).

%%------------------------------------------------------------------------------
%% @doc API Request.
%% Takes proplist, creates JSON string or error.
%% @end
%%------------------------------------------------------------------------------
-spec api_request(kz_term:api_terms()) ->
    {'ok', iolist()}
    | {'error', string()}.
api_request(Prop) when is_list(Prop) ->
    case api_request_v(Prop) of
        'true' -> kz_api:build_message(Prop, ?API_REQUEST_HEADERS, ?OPTIONAL_API_REQUEST_HEADERS);
        'false' -> {'error', "Proplist failed validation for api_request"}
    end;
api_request(JObj) ->
    api_request(kz_json:to_proplist(JObj)).

-spec api_request_v(kz_term:api_terms()) -> boolean().
api_request_v(Prop) when is_list(Prop) ->
    Valid = kz_api:validate(Prop, ?API_REQUEST_HEADERS, ?API_REQUEST_VALUES, ?API_REQUEST_TYPES),
    Valid;
api_request_v(JObj) ->
    api_request_v(kz_json:to_proplist(JObj)).

-spec api_resp_v(kz_term:api_terms()) -> boolean().
api_resp_v(Prop) when is_list(Prop) ->
    Valid = kz_api:validate(Prop, ?API_RESPONSE_HEADERS, ?API_RESPONSE_VALUES, ?API_RESPONSE_TYPES),
    Valid;
api_resp_v(JObj) ->
    api_resp_v(kz_json:to_proplist(JObj)).

%%------------------------------------------------------------------------------
%% @doc Background API Request.
%% Takes proplist, creates JSON string or error.
%% @end
%%------------------------------------------------------------------------------
-spec bgapi_request(kz_term:api_terms()) ->
    {'ok', iolist()}
    | {'error', string()}.
bgapi_request(Prop) when is_list(Prop) ->
    case bgapi_request_v(Prop) of
        'true' ->
            kz_api:build_message(Prop, ?BGAPI_REQUEST_HEADERS, ?OPTIONAL_BGAPI_REQUEST_HEADERS);
        'false' ->
            {'error', "Proplist failed validation for bgapi_request"}
    end;
bgapi_request(JObj) ->
    bgapi_request(kz_json:to_proplist(JObj)).

-spec bgapi_request_v(kz_term:api_terms()) -> boolean().
bgapi_request_v(Prop) when is_list(Prop) ->
    Valid = kz_api:validate(
        Prop, ?BGAPI_REQUEST_HEADERS, ?BGAPI_REQUEST_VALUES, ?BGAPI_REQUEST_TYPES
    ),
    Valid;
bgapi_request_v(JObj) ->
    api_request_v(kz_json:to_proplist(JObj)).

-spec bgapi_resp_v(kz_term:api_terms()) -> boolean().
bgapi_resp_v(Prop) when is_list(Prop) ->
    Valid = kz_api:validate(
        Prop, ?BGAPI_RESPONSE_HEADERS, ?BGAPI_RESPONSE_VALUES, ?BGAPI_RESPONSE_TYPES
    ),
    Valid;
bgapi_resp_v(JObj) ->
    bgapi_resp_v(kz_json:to_proplist(JObj)).

%%------------------------------------------------------------------------------
%% @doc Ping Request.
%% Takes proplist, creates JSON string or error.
%% @end
%%------------------------------------------------------------------------------
-spec ping_request(kz_term:api_terms()) ->
    {'ok', iolist()}
    | {'error', string()}.
ping_request(Prop) when is_list(Prop) ->
    case ping_request_v(Prop) of
        'true' -> kz_api:build_message(Prop, ?PING_REQUEST_HEADERS, ?OPTIONAL_PING_REQUEST_HEADERS);
        'false' -> {'error', "Proplist failed validation for ping_request"}
    end;
ping_request(JObj) ->
    ping_request(kz_json:to_proplist(JObj)).

-spec ping_request_v(kz_term:api_terms()) -> boolean().
ping_request_v(Prop) when is_list(Prop) ->
    Valid = kz_api:validate(Prop, ?PING_REQUEST_HEADERS, ?PING_REQUEST_VALUES, ?PING_REQUEST_TYPES),
    Valid;
ping_request_v(JObj) ->
    api_request_v(kz_json:to_proplist(JObj)).

-spec ping_resp_v(kz_term:api_terms()) -> boolean().
ping_resp_v(Prop) when is_list(Prop) ->
    Valid = kz_api:validate(
        Prop, ?PING_RESPONSE_HEADERS, ?PING_RESPONSE_VALUES, ?PING_RESPONSE_TYPES
    ),
    Valid;
ping_resp_v(JObj) ->
    ping_resp_v(kz_json:to_proplist(JObj)).

%%------------------------------------------------------------------------------
%% @doc SENDMSG Request.
%% Takes proplist, creates JSON string or error.
%% @end
%%------------------------------------------------------------------------------
-spec sendmsg_request(kz_term:api_terms()) ->
    {'ok', iolist()}
    | {'error', string()}.
sendmsg_request(Prop) when is_list(Prop) ->
    case sendmsg_request_v(Prop) of
        'true' ->
            kz_api:build_message(Prop, ?SENDMSG_REQUEST_HEADERS, ?OPTIONAL_SENDMSG_REQUEST_HEADERS);
        'false' ->
            {'error', "Proplist failed validation for sendmsg_request"}
    end;
sendmsg_request(JObj) ->
    sendmsg_request(kz_json:to_proplist(JObj)).

-spec sendmsg_request_v(kz_term:api_terms()) -> boolean().
sendmsg_request_v(Prop) when is_list(Prop) ->
    Valid = kz_api:validate(
        Prop, ?SENDMSG_REQUEST_HEADERS, ?SENDMSG_REQUEST_VALUES, ?SENDMSG_REQUEST_TYPES
    ),
    Valid;
sendmsg_request_v(JObj) ->
    sendmsg_request_v(kz_json:to_proplist(JObj)).

-spec sendmsg_resp_v(kz_term:api_terms()) -> boolean().
sendmsg_resp_v(Prop) when is_list(Prop) ->
    Valid = kz_api:validate(
        Prop, ?SENDMSG_RESPONSE_HEADERS, ?SENDMSG_RESPONSE_VALUES, ?SENDMSG_RESPONSE_TYPES
    ),
    Valid;
sendmsg_resp_v(JObj) ->
    sendmsg_resp_v(kz_json:to_proplist(JObj)).


%%------------------------------------------------------------------------------
%% @doc Directory Response.
%% Takes proplist, creates JSON string or error.
%% @end
%%------------------------------------------------------------------------------
-spec event(kz_term:api_terms()) ->
    {'ok', iolist()}
    | {'error', string()}.
event(Prop) when is_list(Prop) ->
    case event_v(Prop) of
        'true' ->
            kz_api:build_message(Prop, ?EVENT_HEADERS, ?OPTIONAL_EVENT_HEADERS);
        'false' ->
            {'error', "Proplist failed validation for event"}
    end;
event(JObj) ->
    event(kz_json:to_proplist(JObj)).

-spec event_v(kz_term:api_terms()) -> boolean().
event_v(Prop) when is_list(Prop) ->
    Valid = kz_api:validate(
        Prop, ?EVENT_HEADERS, ?EVENT_VALUES, ?EVENT_TYPES
    ),
    Valid;
event_v(JObj) ->
    event_v(kz_json:to_proplist(JObj)).

%%------------------------------------------------------------------------------
%% @doc Declare the exchanges used by this API.
%% @end
%%------------------------------------------------------------------------------
-spec declare_exchanges() -> 'ok'.
declare_exchanges() ->
    kz_amqp_util:new_exchange(?FREESWITCH_EXCHANGE, ?FREESWITCH_EXCHANGE_TYPE).

-spec publish_fetch_resp(kz_term:api_terms(), atom(), kz_term:ne_binary()) -> 'ok'.
publish_fetch_resp(Id, Section, Resp) ->
    {'ok', Payload} = kz_api:prepare_api_payload(
        Resp, ?DIRECTORY_RESP_VALUES, fun directory_resp/1
    ),
    kz_amqp_util:basic_publish(
        ?FREESWITCH_EXCHANGE,
        <<"KAZOO.", (kz_term:to_binary(Section))/binary, ".response.", Id/binary>>,
        Payload,
        ?DEFAULT_CONTENT_TYPE
    ).

-spec publish_api_request(kz_term:api_terms()) -> 'ok'.
publish_api_request(Request) ->
    ServerID = props:get_value(<<"Server-ID">>, Request),
    MsgID = props:get_value(<<"Msg-ID">>, Request),
    {'ok', Payload} = kz_api:prepare_api_payload(Request, ?API_REQUEST_VALUES, fun api_request/1),
    kz_amqp_util:basic_publish(
        ?FREESWITCH_EXCHANGE, <<"KAZOO.command.api">>, Payload, ?DEFAULT_CONTENT_TYPE, [
            {'reply_to', ServerID}, {'correlation_id', MsgID}
        ]
    ).

-spec publish_bgapi_request(kz_term:api_terms()) -> 'ok'.
publish_bgapi_request(Request) ->
    ServerID = props:get_value(<<"Server-ID">>, Request),
    MsgID = props:get_value(<<"Msg-ID">>, Request),
    {'ok', Payload} = kz_api:prepare_api_payload(
        Request, ?BGAPI_REQUEST_VALUES, fun bgapi_request/1
    ),
    kz_amqp_util:basic_publish(
        ?FREESWITCH_EXCHANGE, <<"KAZOO.command.bgapi">>, Payload, ?DEFAULT_CONTENT_TYPE, [
            {'reply_to', ServerID}, {'correlation_id', MsgID}
        ]
    ).

-spec publish_ping_request(kz_term:api_terms()) -> 'ok'.
publish_ping_request(Request) ->
    ServerID = props:get_value(<<"Server-ID">>, Request),
    MsgID = props:get_value(<<"Msg-ID">>, Request),
    {'ok', Payload} = kz_api:prepare_api_payload(Request, ?PING_REQUEST_VALUES, fun ping_request/1),
    kz_amqp_util:basic_publish(
        ?FREESWITCH_EXCHANGE, <<"KAZOO.command.ping">>, Payload, ?DEFAULT_CONTENT_TYPE, [
            {'reply_to', ServerID}, {'correlation_id', MsgID}
        ]
    ).

-spec publish_sendmsg_request(kz_term:api_terms()) -> 'ok'.
publish_sendmsg_request(Request) ->
    ServerID = props:get_value(<<"Server-ID">>, Request),
    MsgID = props:get_value(<<"Msg-ID">>, Request),
    {'ok', Payload} = kz_api:prepare_api_payload(
        Request, ?SENDMSG_REQUEST_VALUES, fun sendmsg_request/1
    ),
    kz_amqp_util:basic_publish(
        ?FREESWITCH_EXCHANGE, <<"KAZOO.command.sendmsg">>, Payload, ?DEFAULT_CONTENT_TYPE, [
            {'reply_to', ServerID}, {'correlation_id', MsgID}
        ]
    ).

-spec publish_event(kz_term:api_terms()) -> 'ok'.
publish_event(Event) ->
    Type = props:get_value(<<"FSEvent">>, Event),
    {'ok', Payload} = kz_api:prepare_api_payload(
        Event, ?EVENT_VALUES, fun event/1
    ),
    kz_amqp_util:basic_publish(
        ?FREESWITCH_EXCHANGE,
        <<"KAZOO.event.", Type/binary>>,
        Payload,
        ?DEFAULT_CONTENT_TYPE
    ).


