-ifndef(MEDIA_HRL).

-include_lib("kazoo_stdlib/include/kz_types.hrl").
-include_lib("kazoo_stdlib/include/kz_log.hrl").
-include_lib("kazoo_stdlib/include/kz_databases.hrl").
-include_lib("kazoo_media/include/kz_media.hrl").

-define(APP_NAME, <<"media_srv">>).
-define(APP_VERSION, <<"4.0.0">>).
-define(CONFIG_CAT, ?APP_NAME).

-define(MEDIA_DB, <<"system_media">>).
% use 0 to have OS assign port #, {Low, Hi} for range of ports to try
-define(PORT_RANGE, 0).
-define(PORT_OPTIONS, ['binary', {'packet', 0}, {'active', 'false'}, {'reuseaddr', 'true'}]).
-define(MAX_RESERVED_PORTS, 10).
%% 600 secs = 10 minutes
-define(MAX_WAIT_FOR_LISTENERS, 600 * ?MILLISECONDS_IN_SECOND).

-define(MEDIA_HRL, 'true').
-endif.
