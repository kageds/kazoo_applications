-ifndef(KAPI_DIRECTORY_HRL).

-define(FREESWITCH_EXCHANGE, <<"freeswitch">>).
-define(FREESWITCH_EXCHANGE_TYPE, <<"topic">>).

-define(DIRECTORY_EVENT_CATEGORY, <<"directory">>).
-define(DIRECTORY_REQ_EVENT_NAME, <<"directory_req">>).
-define(DIRECTORY_RESP_EVENT_NAME, <<"directory_resp">>).

-define(API_CATEGORY, <<"api">>).
-define(API_REQ_NAME, <<"api_req">>).
-define(API_RESP_NAME, <<"api_resp">>).

-define(BGAPI_CATEGORY, <<"bgapi">>).
-define(BGAPI_REQ_NAME, <<"bgapi_req">>).
-define(BGAPI_RESP_NAME, <<"bgapi_resp">>).

-define(PING_CATEGORY, <<"ping">>).
-define(PING_REQ_NAME, <<"ping_req">>).
-define(PING_RESP_NAME, <<"ping_resp">>).

-define(SENDMSG_CATEGORY, <<"sendmsg">>).
-define(SENDMSG_REQ_NAME, <<"sendmsg_req">>).
-define(SENDMSG_RESP_NAME, <<"sendmsg_resp">>).

%% Directory Responses
-define(DIRECTORY_RESP_HEADERS, [<<"response">>, <<"Fetch-UUID">>, <<"Switch-Nodename">>]).

-define(OPTIONAL_DIRECTORY_RESP_HEADERS, []).

-define(DIRECTORY_RESP_VALUES, [
    {<<"Event-Category">>, ?DIRECTORY_EVENT_CATEGORY},
    {<<"Event-Name">>, ?DIRECTORY_RESP_EVENT_NAME}
]).

-define(DIRECTORY_RESP_TYPES, [{<<"response">>, fun erlang:is_binary/1}]).

%% API Requests
-define(API_REQUEST_HEADERS, [<<"command">>, <<"Switch-Nodename">>]).

-define(OPTIONAL_API_REQUEST_HEADERS, [<<"args">>]).

-define(API_REQUEST_VALUES, [
    {<<"Event-Category">>, ?API_CATEGORY},
    {<<"Event-Name">>, ?API_REQ_NAME}
]).

-define(API_REQUEST_TYPES, [{<<"command">>, fun erlang:is_binary/1}]).

%% API Responses
-define(API_RESPONSE_HEADERS, [<<"response">>, <<"Switch-Nodename">>]).

-define(OPTIONAL_API_RESPONSE_HEADERS, []).

-define(API_RESPONSE_VALUES, []).

-define(API_RESPONSE_TYPES, [{<<"response">>, fun erlang:is_binary/1}]).

%% Background API Requests
-define(BGAPI_REQUEST_HEADERS, [<<"command">>, <<"Switch-Nodename">>]).

-define(OPTIONAL_BGAPI_REQUEST_HEADERS, [<<"args">>]).

-define(BGAPI_REQUEST_VALUES, [
    {<<"Event-Category">>, ?BGAPI_CATEGORY},
    {<<"Event-Name">>, ?BGAPI_REQ_NAME}
]).

-define(BGAPI_REQUEST_TYPES, [{<<"command">>, fun erlang:is_binary/1}]).
%% Background API Responses
-define(BGAPI_RESPONSE_HEADERS, [<<"response">>, <<"Switch-Nodename">>]).

-define(OPTIONAL_BGAPI_RESPONSE_HEADERS, []).

-define(BGAPI_RESPONSE_VALUES, []).

-define(BGAPI_RESPONSE_TYPES, [{<<"response">>, fun erlang:is_binary/1}]).

%% PING Requests
-define(PING_REQUEST_HEADERS, [<<"ping">>, <<"Switch-Nodename">>]).

-define(OPTIONAL_PING_REQUEST_HEADERS, []).

-define(PING_REQUEST_VALUES, [
    {<<"Event-Category">>, ?PING_CATEGORY},
    {<<"Event-Name">>, ?PING_REQ_NAME}
]).

-define(PING_REQUEST_TYPES, [{<<"ping">>, fun erlang:is_binary/1}]).

%% PING Responses
-define(PING_RESPONSE_HEADERS, [<<"pong">>, <<"Switch-Nodename">>]).

-define(OPTIONAL_PING_RESPONSE_HEADERS, []).

-define(PING_RESPONSE_VALUES, []).

-define(PING_RESPONSE_TYPES, [{<<"pong">>, fun erlang:is_binary/1}]).

%% SENDMSG Requests
-define(SENDMSG_REQUEST_HEADERS, [
    <<"Server-ID">>,
    <<"Msg-ID">>,
    <<"UUID">>,
    <<"FSHeaders">>,
    <<"Switch-Nodename">>
]).

-define(OPTIONAL_SENDMSG_REQUEST_HEADERS, []).

-define(SENDMSG_REQUEST_VALUES, [
    {<<"Event-Category">>, ?SENDMSG_CATEGORY},
    {<<"Event-Name">>, ?SENDMSG_REQ_NAME}
]).

-define(SENDMSG_REQUEST_TYPES, [{<<"UUID">>, fun erlang:is_binary/1}]).

%% SENDMSG Responses
-define(SENDMSG_RESPONSE_HEADERS, [<<"response">>, <<"Switch-Nodename">>]).

-define(OPTIONAL_SENDMSG_RESPONSE_HEADERS, []).

-define(SENDMSG_RESPONSE_VALUES, []).

-define(SENDMSG_RESPONSE_TYPES, [{<<"response">>, fun erlang:is_binary/1}]).

-define(KAPI_DIRECTORY_HRL, 'true').
-endif.
