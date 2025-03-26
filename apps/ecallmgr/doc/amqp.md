
# NOTES  

* Need to load kageds mod_amqp and mod_kazoo on Freeswitch
* Need /etc/kazoo/freeswitch/autoload_config/amqp.conf.xml

```
<configuration name="amqp.conf" description="mod_amqp">
  <producers>
    <profile name="freeswitch.producers">
      <connections>
        <connection name="primary">
          <param name="hostname" value="localhost"/>
          <param name="virtualhost" value="/"/>
          <param name="username" value="guest"/>
          <param name="password" value="guest"/>
          <param name="port" value="5673"/>
          <param name="heartbeat" value="0"/>
        </connection>
        <connection name="secondary">
          <param name="hostname" value="localhost"/>
          <param name="virtualhost" value="/"/>
          <param name="username" value="guest"/>
          <param name="password" value="guest"/>
          <param name="port" value="5672"/>
          <param name="heartbeat" value="0"/>
        </connection>
      </connections>
      <params>
        <param name="exchange-name" value="freeswitch"/>
        <param name="exchange-type" value="topic"/>
        <param name="exchange-durable" value="false"/>
        <param name="content-type" value="application/json"/>
        <param name="circuit_breaker_ms" value="10000"/>
        <param name="reconnect_interval_ms" value="1000"/>
        <param name="send_queue_size" value="5000"/>
        <param name="enable_fallback_format_fields" value="1"/>

        <!-- The routing key is made from the format string, using the header values in the event specified in the format_fields.-->
        <!-- Fields that are prefixed with a # are treated as literals rather than doing a header lookup -->
        <param name="format_fields" value="#FreeSWITCH,FreeSWITCH-Hostname,Event-Name|Event-Subclass,Unique-ID"/>

        <!-- If enable_fallback_format_fields is enabled, then you can | separate event headers, and if the first does not exist
             then the system will check additional configured header values.
        -->
        <!-- <param name="format_fields" value="#FreeSWITCH,FreeSWITCH-Hostname|#Unknown,Event-Name,Event-Subclass,Unique-ID"/> -->

        <!--    <param name="event_filter" value="SWITCH_EVENT_ALL"/> -->
        <param name="event_filter" value="SWITCH_EVENT_CHANNEL_CREATE,SWITCH_EVENT_CHANNEL_DESTROY,SWITCH_EVENT_HEARTBEAT,SWITCH_EVENT_DTMF"/>
      </params>
    </profile>
  </producers>
  <commands>
    <profile name="freeswitch.commands">
      <connections>
        <connection name="primary">
          <param name="hostname" value="localhost"/>
          <param name="virtualhost" value="/"/>
          <param name="username" value="guest"/>
          <param name="password" value="guest"/>
          <param name="port" value="5672"/>
          <param name="heartbeat" value="0"/>
        </connection>
      </connections>
      <params>
        <param name="exchange-name" value="freeswitch"/>
        <param name="exchange-durable" value="false"/>
        <param name="content-type" value="application/json"/>
        <param name="binding-key" value="KAZOO.command.*"/>
        <param name="reconnect_interval_ms" value="1000"/>
        <param name="queue-passive" value="false"/>
        <param name="queue-durable" value="false"/>
        <param name="queue-exclusive" value="false"/>
        <param name="queue-auto-delete" value="true"/>
      </params>
      <!-- props are added to the JSON command response-->
      <!-- Fields that are prefixed with a # are treated as literals rather than doing a header lookup -->
      <props>
            <prop name="#App-Name" value="#mod_amqp"/>
            <prop name="#App-Version" value="#0.0.1"/>
            <prop name="#Event-Name" value="#command_response"/>
            <prop name="#Event-Category" value="#api"/>
            <prop name="#Switch-Nodename" value="#freeswitch@,AMQP-HOSTNAME"/>
      </props>
    </profile>
  </commands>
  <fetchers>
    <profile name="freeswitch.fetchers">
      <connections>
        <connection name="primary">
          <param name="hostname" value="localhost"/>
          <param name="virtualhost" value="/"/>
          <param name="username" value="guest"/>
          <param name="password" value="guest"/>
          <param name="port" value="5672"/>
          <param name="heartbeat" value="0"/>
        </connection>
      </connections>
      <params>
        <param name="exchange-name" value="freeswitch"/>
        <param name="exchange-durable" value="false"/>
        <param name="content-type" value="application/json"/>
        <param name="reconnect_interval_ms" value="1000"/>
        <param name="queue-passive" value="false"/>
        <param name="queue-durable" value="false"/>
        <param name="queue-exclusive" value="false"/>
        <param name="queue-auto-delete" value="true"/>
      </params>
    </profile>
  </fetchers>
</configuration>
```


# AMQP Messages for Ext -> Ext call

```

================================================================================
2025-03-26T10:50:41.862+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60068 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"FreeSWITCH.directory.request.7fa7b985-7048-475f-af08-655f8babeb9d">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_fs_amqp_listener-<0.1619.0>-00a71b61">>]
Properties:   [{<<"timestamp">>,signedint,1742986241},
               {<<"headers">>,table,
                [{<<"x_Liquid_MessageSentTimeStamp">>,timestamp,1742986241}]},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"call_uuid":"7fa7b985-7048-475f-af08-655f8babeb9d","action":"request","section":"directory","tag_name":"domain","key_name":"name","key_value":"4f5549.sip.2600hz.com","variables":{"Event-Name":"REQUEST_PARAMS","Core-UUID":"917c114b-eaf1-40f2-8407-4d2cd97687a1","FreeSWITCH-Hostname":"debian12-kazoo","FreeSWITCH-Switchname":"debian12-kazoo","FreeSWITCH-IPv4":"10.1.1.14","FreeSWITCH-IPv6":"::1","Event-Date-Local":"2025-03-26 10:50:41","Event-Date-GMT":"Wed, 26 Mar 2025 10:50:41 GMT","Event-Date-Timestamp":"1742986241847058","Event-Calling-File":"sofia.c","Event-Calling-Function":"sofia_locate_user","Event-Calling-Line-Number":"10339","Event-Sequence":"683","X-AUTH-IP":"10.1.1.31","X-AUTH-PORT":"54730","X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","X-ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","X-ecallmgr_Authorizing-Type":"device","X-ecallmgr_Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","X-ecallmgr_Username":"user_p48egzdph4","X-ecallmgr_Realm":"4f5549.sip.2600hz.com","X-ecallmgr_Account-Realm":"4f5549.sip.2600hz.com","X-ecallmgr_Account-Name":"Kage Design Services Ltd","X-ecallmgr_Presence-ID":"1000@4f5549.sip.2600hz.com","X-ecallmgr_Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Channel-State":"CS_NEW","Channel-Call-State":"DOWN","Channel-State-Number":"0","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Unique-ID":"66717c2c66232d6e","Call-Direction":"inbound","Presence-Call-Direction":"inbound","Channel-HIT-Dialplan":"true","Channel-Call-UUID":"66717c2c66232d6e","Answer-State":"ringing","variable_direction":"inbound","variable_uuid":"66717c2c66232d6e","variable_call_uuid":"66717c2c66232d6e","variable_session_id":"3","variable_sip_from_user":"user_p48egZdPh4","variable_sip_from_uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_from_host":"4f5549.sip.2600hz.com","variable_video_media_flow":"disabled","variable_audio_media_flow":"disabled","variable_text_media_flow":"disabled","variable_channel_name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_call_id":"66717c2c66232d6e","variable_ep_codec_string":"CORE_PCM_MODULE.PCMU@8000h@20i@64000b,CORE_PCM_MODULE.PCMA@8000h@20i@64000b","key":"id","user":"user_p48egZdPh4","domain":"4f5549.sip.2600hz.com","Fetch-UUID":"7fa7b985-7048-475f-af08-655f8babeb9d","Fetch-Section":"directory","Fetch-Tag":"domain","Fetch-Key-Name":"name","Fetch-Key-Value":"4f5549.sip.2600hz.com","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Fetch-Timeout":"0","Fetch-Timestamp-Micro":"1742986241847058","Kazoo-Version":"mod_amqp v0.0.1 kageds","Kazoo-Bundle":"community","Kazoo-Release":"v1.5.0-1"}}

================================================================================
2025-03-26T10:50:41.863+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      175
Exchange:     freeswitch
Routing keys: [<<"FreeSWITCH.directory.request.7fa7b985-7048-475f-af08-655f8babeb9d">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_fs_amqp_listener-<0.1619.0>-00a71b61
Properties:   [{<<"timestamp">>,signedint,1742986241},
               {<<"headers">>,table,
                [{<<"x_Liquid_MessageSentTimeStamp">>,timestamp,1742986241}]},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"call_uuid":"7fa7b985-7048-475f-af08-655f8babeb9d","action":"request","section":"directory","tag_name":"domain","key_name":"name","key_value":"4f5549.sip.2600hz.com","variables":{"Event-Name":"REQUEST_PARAMS","Core-UUID":"917c114b-eaf1-40f2-8407-4d2cd97687a1","FreeSWITCH-Hostname":"debian12-kazoo","FreeSWITCH-Switchname":"debian12-kazoo","FreeSWITCH-IPv4":"10.1.1.14","FreeSWITCH-IPv6":"::1","Event-Date-Local":"2025-03-26 10:50:41","Event-Date-GMT":"Wed, 26 Mar 2025 10:50:41 GMT","Event-Date-Timestamp":"1742986241847058","Event-Calling-File":"sofia.c","Event-Calling-Function":"sofia_locate_user","Event-Calling-Line-Number":"10339","Event-Sequence":"683","X-AUTH-IP":"10.1.1.31","X-AUTH-PORT":"54730","X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","X-ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","X-ecallmgr_Authorizing-Type":"device","X-ecallmgr_Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","X-ecallmgr_Username":"user_p48egzdph4","X-ecallmgr_Realm":"4f5549.sip.2600hz.com","X-ecallmgr_Account-Realm":"4f5549.sip.2600hz.com","X-ecallmgr_Account-Name":"Kage Design Services Ltd","X-ecallmgr_Presence-ID":"1000@4f5549.sip.2600hz.com","X-ecallmgr_Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Channel-State":"CS_NEW","Channel-Call-State":"DOWN","Channel-State-Number":"0","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Unique-ID":"66717c2c66232d6e","Call-Direction":"inbound","Presence-Call-Direction":"inbound","Channel-HIT-Dialplan":"true","Channel-Call-UUID":"66717c2c66232d6e","Answer-State":"ringing","variable_direction":"inbound","variable_uuid":"66717c2c66232d6e","variable_call_uuid":"66717c2c66232d6e","variable_session_id":"3","variable_sip_from_user":"user_p48egZdPh4","variable_sip_from_uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_from_host":"4f5549.sip.2600hz.com","variable_video_media_flow":"disabled","variable_audio_media_flow":"disabled","variable_text_media_flow":"disabled","variable_channel_name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_call_id":"66717c2c66232d6e","variable_ep_codec_string":"CORE_PCM_MODULE.PCMU@8000h@20i@64000b,CORE_PCM_MODULE.PCMA@8000h@20i@64000b","key":"id","user":"user_p48egZdPh4","domain":"4f5549.sip.2600hz.com","Fetch-UUID":"7fa7b985-7048-475f-af08-655f8babeb9d","Fetch-Section":"directory","Fetch-Tag":"domain","Fetch-Key-Name":"name","Fetch-Key-Value":"4f5549.sip.2600hz.com","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Fetch-Timeout":"0","Fetch-Timestamp-Micro":"1742986241847058","Kazoo-Version":"mod_amqp v0.0.1 kageds","Kazoo-Bundle":"community","Kazoo-Release":"v1.5.0-1"}}

================================================================================
2025-03-26T10:50:41.864+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      175
Exchange:     freeswitch
Routing keys: [<<"KAZOO.directory.response.7fa7b985-7048-475f-af08-655f8babeb9d">>]
Routed queues: [<<"freeswitch.fetchers">>]
Properties:   [{<<"timestamp">>,signedint,63910205441863886},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Fetch-UUID":"7fa7b985-7048-475f-af08-655f8babeb9d","response":"<document type=\"freeswitch/xml\"><section name=\"directory\"><domain name=\"4f5549.sip.2600hz.com\"><user id=\"user_p48egZdPh4\"><variables><variable name=\"ecallmgr_Account-ID\" value=\"47459457c634aff90b96f6af8a8eebb6\"/><variable name=\"ecallmgr_Authorizing-Type\" value=\"device\"/><variable name=\"ecallmgr_Authorizing-ID\" value=\"8d604a1881ea0c16e12971622e2a8cac\"/><variable name=\"ecallmgr_Username\" value=\"user_p48egzdph4\"/><variable name=\"ecallmgr_Realm\" value=\"4f5549.sip.2600hz.com\"/><variable name=\"ecallmgr_Account-Realm\" value=\"4f5549.sip.2600hz.com\"/><variable name=\"ecallmgr_Account-Name\" value=\"Kage Design Services Ltd\"/><variable name=\"presence_id\" value=\"1000@4f5549.sip.2600hz.com\"/><variable name=\"ecallmgr_Owner-ID\" value=\"dbfb28b1de0750b697d26fb61e9ea863\"/></variables><params><param name=\"password\" value=\"ab0d3a873b7f2001dc1d4232\"/></params></user></domain></section></document>","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"5c222d7b3e287c4333616ecda7033483","Event-Name":"directory_resp","Event-Category":"directory","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.868+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60068 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"KAZOO.directory.response.7fa7b985-7048-475f-af08-655f8babeb9d">>]
Queue:        freeswitch.fetchers
Properties:   [{<<"timestamp">>,signedint,63910205441863886},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Fetch-UUID":"7fa7b985-7048-475f-af08-655f8babeb9d","response":"<document type=\"freeswitch/xml\"><section name=\"directory\"><domain name=\"4f5549.sip.2600hz.com\"><user id=\"user_p48egZdPh4\"><variables><variable name=\"ecallmgr_Account-ID\" value=\"47459457c634aff90b96f6af8a8eebb6\"/><variable name=\"ecallmgr_Authorizing-Type\" value=\"device\"/><variable name=\"ecallmgr_Authorizing-ID\" value=\"8d604a1881ea0c16e12971622e2a8cac\"/><variable name=\"ecallmgr_Username\" value=\"user_p48egzdph4\"/><variable name=\"ecallmgr_Realm\" value=\"4f5549.sip.2600hz.com\"/><variable name=\"ecallmgr_Account-Realm\" value=\"4f5549.sip.2600hz.com\"/><variable name=\"ecallmgr_Account-Name\" value=\"Kage Design Services Ltd\"/><variable name=\"presence_id\" value=\"1000@4f5549.sip.2600hz.com\"/><variable name=\"ecallmgr_Owner-ID\" value=\"dbfb28b1de0750b697d26fb61e9ea863\"/></variables><params><param name=\"password\" value=\"ab0d3a873b7f2001dc1d4232\"/></params></user></domain></section></document>","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"5c222d7b3e287c4333616ecda7033483","Event-Name":"directory_resp","Event-Category":"directory","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.869+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60048 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"FreeSWITCH.debian12-kazoo.CHANNEL_CREATE.66717c2c66232d6e">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_fs_amqp_listener-<0.1619.0>-00a71b61">>]
Properties:   [{<<"timestamp">>,signedint,1742986241},
               {<<"headers">>,table,
                [{<<"x_Liquid_MessageSentTimeStamp">>,timestamp,1742986241}]},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Event-Name":"CHANNEL_CREATE","Core-UUID":"917c114b-eaf1-40f2-8407-4d2cd97687a1","FreeSWITCH-Hostname":"debian12-kazoo","FreeSWITCH-Switchname":"debian12-kazoo","FreeSWITCH-IPv4":"10.1.1.14","FreeSWITCH-IPv6":"::1","Event-Date-Local":"2025-03-26 10:50:41","Event-Date-GMT":"Wed, 26 Mar 2025 10:50:41 GMT","Event-Date-Timestamp":"1742986241847058","Event-Calling-File":"switch_core_state_machine.c","Event-Calling-Function":"switch_core_session_run","Event-Calling-Line-Number":"626","Event-Sequence":"685","Channel-State":"CS_INIT","Channel-Call-State":"DOWN","Channel-State-Number":"2","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Unique-ID":"66717c2c66232d6e","Call-Direction":"inbound","Presence-Call-Direction":"inbound","Channel-HIT-Dialplan":"true","Channel-Presence-ID":"1000@4f5549.sip.2600hz.com","Channel-Call-UUID":"66717c2c66232d6e","Answer-State":"ringing","Caller-Direction":"inbound","Caller-Logical-Direction":"inbound","Caller-Username":"user_p48egZdPh4","Caller-Dialplan":"XML","Caller-Caller-ID-Name":"user_p48egZdPh4","Caller-Caller-ID-Number":"user_p48egZdPh4","Caller-Orig-Caller-ID-Name":"user_p48egZdPh4","Caller-Orig-Caller-ID-Number":"user_p48egZdPh4","Caller-Network-Addr":"10.1.1.14","Caller-ANI":"user_p48egZdPh4","Caller-Destination-Number":"1001","Caller-Unique-ID":"66717c2c66232d6e","Caller-Source":"mod_sofia","Caller-Context":"context_2","Caller-Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Caller-Profile-Index":"1","Caller-Profile-Created-Time":"1742986241847058","Caller-Channel-Created-Time":"1742986241847058","Caller-Channel-Answered-Time":"0","Caller-Channel-Progress-Time":"0","Caller-Channel-Progress-Media-Time":"0","Caller-Channel-Hangup-Time":"0","Caller-Channel-Transfer-Time":"0","Caller-Channel-Resurrect-Time":"0","Caller-Channel-Bridged-Time":"0","Caller-Channel-Last-Hold":"0","Caller-Channel-Hold-Accum":"0","Caller-Screen-Bit":"true","Caller-Privacy-Hide-Name":"false","Caller-Privacy-Hide-Number":"false","variable_direction":"inbound","variable_uuid":"66717c2c66232d6e","variable_call_uuid":"66717c2c66232d6e","variable_session_id":"3","variable_sip_from_user":"user_p48egZdPh4","variable_sip_from_uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_from_host":"4f5549.sip.2600hz.com","variable_video_media_flow":"disabled","variable_audio_media_flow":"disabled","variable_text_media_flow":"disabled","variable_channel_name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_call_id":"66717c2c66232d6e","variable_sip_local_network_addr":"10.1.1.14","variable_sip_network_ip":"10.1.1.14","variable_sip_network_port":"5060","variable_sip_invite_stamp":"1742986241847058","variable_sip_received_ip":"10.1.1.14","variable_sip_received_port":"5060","variable_sip_via_protocol":"udp","variable_sip_authorized":"true","variable_ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_ecallmgr_Authorizing-Type":"device","variable_ecallmgr_Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","variable_ecallmgr_Username":"user_p48egzdph4","variable_ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_ecallmgr_Account-Realm":"4f5549.sip.2600hz.com","variable_ecallmgr_Account-Name":"Kage Design Services Ltd","variable_presence_id":"1000@4f5549.sip.2600hz.com","variable_ecallmgr_Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","variable_user_name":"user_p48egZdPh4","variable_domain_name":"4f5549.sip.2600hz.com","variable_sip_from_user_stripped":"user_p48egZdPh4","variable_sip_from_tag":"2628444714184456","variable_sofia_profile_name":"sipinterface_1","variable_sofia_profile_url":"sip:mod_sofia@10.1.1.14:11000","variable_recovery_profile_name":"sipinterface_1","variable_sip_invite_route_uri":"<sip:10.1.1.14;lr=on;ftag=2628444714184456>","variable_sip_invite_record_route":"<sip:10.1.1.14;lr=on;ftag=2628444714184456>","variable_sip_full_via":"SIP/2.0/UDP 10.1.1.14;branch=z9hG4bK6eab.a30fe37d5e0744b8c9a9b6986b0f2375.0,SIP/2.0/UDP 10.1.1.31:54730;received=10.1.1.31;branch=z9hG4bK584229b86fc25ed2;rport=54730","variable_sip_full_from":"<sip:user_p48egZdPh4@4f5549.sip.2600hz.com>;tag=2628444714184456","variable_sip_full_to":"<sip:1001@4f5549.sip.2600hz.com>","variable_sip_allow":"INVITE, ACK, BYE, CANCEL, OPTIONS, REFER, NOTIFY, SUBSCRIBE, INFO","variable_sip_req_user":"1001","variable_sip_req_uri":"1001@4f5549.sip.2600hz.com","variable_sip_req_host":"4f5549.sip.2600hz.com","variable_sip_to_user":"1001","variable_sip_to_uri":"1001@4f5549.sip.2600hz.com","variable_sip_to_host":"4f5549.sip.2600hz.com","variable_sip_contact_params":"alias=10.1.1.31~54730~1","variable_sip_contact_user":"user_p48egZdPh4","variable_sip_contact_port":"54730","variable_sip_contact_uri":"user_p48egZdPh4@10.1.1.31:54730","variable_sip_contact_host":"10.1.1.31","variable_rtp_use_codec_string":"OPUS,VP8,H263,H264,G7221@32000h,G7221@16000h,G722,PCMU,PCMA,G729,GSM,Speex","variable_sip_user_agent":"tSIP 0.01.70.00","variable_sip_via_host":"10.1.1.14","variable_max_forwards":"50","variable_sip_h_X-AUTH-IP":"10.1.1.31","variable_sip_h_X-AUTH-PORT":"54730","variable_sip_h_X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","variable_sip_h_X-ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_sip_h_X-ecallmgr_Authorizing-Type":"device","variable_sip_h_X-ecallmgr_Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","variable_sip_h_X-ecallmgr_Username":"user_p48egzdph4","variable_sip_h_X-ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_sip_h_X-ecallmgr_Account-Realm":"4f5549.sip.2600hz.com","variable_sip_h_X-ecallmgr_Account-Name":"Kage Design Services Ltd","variable_sip_h_X-ecallmgr_Presence-ID":"1000@4f5549.sip.2600hz.com","variable_sip_h_X-ecallmgr_Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","variable_switch_r_sdp":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_ep_codec_string":"CORE_PCM_MODULE.PCMU@8000h@20i@64000b,CORE_PCM_MODULE.PCMA@8000h@20i@64000b","variable_endpoint_disposition":"DELAYED NEGOTIATION","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com"}

================================================================================
2025-03-26T10:50:41.869+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60068 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"FreeSWITCH.dialplan.request.83efe426-7b44-45f4-be35-5d3d90bea343">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_fs_amqp_listener-<0.1619.0>-00a71b61">>]
Properties:   [{<<"timestamp">>,signedint,1742986241},
               {<<"headers">>,table,
                [{<<"x_Liquid_MessageSentTimeStamp">>,timestamp,1742986241}]},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"call_uuid":"83efe426-7b44-45f4-be35-5d3d90bea343","action":"request","section":"dialplan","variables":{"Event-Name":"REQUEST_PARAMS","Core-UUID":"917c114b-eaf1-40f2-8407-4d2cd97687a1","FreeSWITCH-Hostname":"debian12-kazoo","FreeSWITCH-Switchname":"debian12-kazoo","FreeSWITCH-IPv4":"10.1.1.14","FreeSWITCH-IPv6":"::1","Event-Date-Local":"2025-03-26 10:50:41","Event-Date-GMT":"Wed, 26 Mar 2025 10:50:41 GMT","Event-Date-Timestamp":"1742986241867031","Event-Calling-File":"mod_dialplan_xml.c","Event-Calling-Function":"dialplan_xml_locate","Event-Calling-Line-Number":"610","Event-Sequence":"688","Channel-State":"CS_ROUTING","Channel-Call-State":"RINGING","Channel-State-Number":"2","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Unique-ID":"66717c2c66232d6e","Call-Direction":"inbound","Presence-Call-Direction":"inbound","Channel-HIT-Dialplan":"true","Channel-Presence-ID":"1000@4f5549.sip.2600hz.com","Channel-Call-UUID":"66717c2c66232d6e","Answer-State":"ringing","Caller-Direction":"inbound","Caller-Logical-Direction":"inbound","Caller-Username":"user_p48egZdPh4","Caller-Dialplan":"XML","Caller-Caller-ID-Name":"user_p48egZdPh4","Caller-Caller-ID-Number":"user_p48egZdPh4","Caller-Orig-Caller-ID-Name":"user_p48egZdPh4","Caller-Orig-Caller-ID-Number":"user_p48egZdPh4","Caller-Network-Addr":"10.1.1.14","Caller-ANI":"user_p48egZdPh4","Caller-Destination-Number":"1001","Caller-Unique-ID":"66717c2c66232d6e","Caller-Source":"mod_sofia","Caller-Context":"context_2","Caller-Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Caller-Profile-Index":"1","Caller-Profile-Created-Time":"1742986241847058","Caller-Channel-Created-Time":"1742986241847058","Caller-Channel-Answered-Time":"0","Caller-Channel-Progress-Time":"0","Caller-Channel-Progress-Media-Time":"0","Caller-Channel-Hangup-Time":"0","Caller-Channel-Transfer-Time":"0","Caller-Channel-Resurrect-Time":"0","Caller-Channel-Bridged-Time":"0","Caller-Channel-Last-Hold":"0","Caller-Channel-Hold-Accum":"0","Caller-Screen-Bit":"true","Caller-Privacy-Hide-Name":"false","Caller-Privacy-Hide-Number":"false","variable_direction":"inbound","variable_uuid":"66717c2c66232d6e","variable_session_id":"3","variable_sip_from_user":"user_p48egZdPh4","variable_sip_from_uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_from_host":"4f5549.sip.2600hz.com","variable_video_media_flow":"disabled","variable_audio_media_flow":"disabled","variable_text_media_flow":"disabled","variable_channel_name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_call_id":"66717c2c66232d6e","variable_sip_local_network_addr":"10.1.1.14","variable_sip_network_ip":"10.1.1.14","variable_sip_network_port":"5060","variable_sip_invite_stamp":"1742986241847058","variable_sip_received_ip":"10.1.1.14","variable_sip_received_port":"5060","variable_sip_via_protocol":"udp","variable_sip_authorized":"true","variable_ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_ecallmgr_Authorizing-Type":"device","variable_ecallmgr_Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","variable_ecallmgr_Username":"user_p48egzdph4","variable_ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_ecallmgr_Account-Realm":"4f5549.sip.2600hz.com","variable_ecallmgr_Account-Name":"Kage Design Services Ltd","variable_presence_id":"1000@4f5549.sip.2600hz.com","variable_ecallmgr_Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","variable_user_name":"user_p48egZdPh4","variable_domain_name":"4f5549.sip.2600hz.com","variable_sip_from_user_stripped":"user_p48egZdPh4","variable_sip_from_tag":"2628444714184456","variable_sofia_profile_name":"sipinterface_1","variable_sofia_profile_url":"sip:mod_sofia@10.1.1.14:11000","variable_recovery_profile_name":"sipinterface_1","variable_sip_invite_route_uri":"<sip:10.1.1.14;lr=on;ftag=2628444714184456>","variable_sip_invite_record_route":"<sip:10.1.1.14;lr=on;ftag=2628444714184456>","variable_sip_full_via":"SIP/2.0/UDP 10.1.1.14;branch=z9hG4bK6eab.a30fe37d5e0744b8c9a9b6986b0f2375.0,SIP/2.0/UDP 10.1.1.31:54730;received=10.1.1.31;branch=z9hG4bK584229b86fc25ed2;rport=54730","variable_sip_full_from":"<sip:user_p48egZdPh4@4f5549.sip.2600hz.com>;tag=2628444714184456","variable_sip_full_to":"<sip:1001@4f5549.sip.2600hz.com>","variable_sip_allow":"INVITE, ACK, BYE, CANCEL, OPTIONS, REFER, NOTIFY, SUBSCRIBE, INFO","variable_sip_req_user":"1001","variable_sip_req_uri":"1001@4f5549.sip.2600hz.com","variable_sip_req_host":"4f5549.sip.2600hz.com","variable_sip_to_user":"1001","variable_sip_to_uri":"1001@4f5549.sip.2600hz.com","variable_sip_to_host":"4f5549.sip.2600hz.com","variable_sip_contact_params":"alias=10.1.1.31~54730~1","variable_sip_contact_user":"user_p48egZdPh4","variable_sip_contact_port":"54730","variable_sip_contact_uri":"user_p48egZdPh4@10.1.1.31:54730","variable_sip_contact_host":"10.1.1.31","variable_rtp_use_codec_string":"OPUS,VP8,H263,H264,G7221@32000h,G7221@16000h,G722,PCMU,PCMA,G729,GSM,Speex","variable_sip_user_agent":"tSIP 0.01.70.00","variable_sip_via_host":"10.1.1.14","variable_max_forwards":"50","variable_sip_h_X-AUTH-IP":"10.1.1.31","variable_sip_h_X-AUTH-PORT":"54730","variable_sip_h_X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","variable_sip_h_X-ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_sip_h_X-ecallmgr_Authorizing-Type":"device","variable_sip_h_X-ecallmgr_Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","variable_sip_h_X-ecallmgr_Username":"user_p48egzdph4","variable_sip_h_X-ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_sip_h_X-ecallmgr_Account-Realm":"4f5549.sip.2600hz.com","variable_sip_h_X-ecallmgr_Account-Name":"Kage Design Services Ltd","variable_sip_h_X-ecallmgr_Presence-ID":"1000@4f5549.sip.2600hz.com","variable_sip_h_X-ecallmgr_Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","variable_switch_r_sdp":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_ep_codec_string":"CORE_PCM_MODULE.PCMU@8000h@20i@64000b,CORE_PCM_MODULE.PCMA@8000h@20i@64000b","variable_endpoint_disposition":"DELAYED NEGOTIATION","variable_call_uuid":"66717c2c66232d6e","Hunt-Direction":"inbound","Hunt-Logical-Direction":"inbound","Hunt-Username":"user_p48egZdPh4","Hunt-Dialplan":"XML","Hunt-Caller-ID-Name":"user_p48egZdPh4","Hunt-Caller-ID-Number":"user_p48egZdPh4","Hunt-Orig-Caller-ID-Name":"user_p48egZdPh4","Hunt-Orig-Caller-ID-Number":"user_p48egZdPh4","Hunt-Network-Addr":"10.1.1.14","Hunt-ANI":"user_p48egZdPh4","Hunt-Destination-Number":"1001","Hunt-Unique-ID":"66717c2c66232d6e","Hunt-Source":"mod_sofia","Hunt-Context":"context_2","Hunt-Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Hunt-Profile-Index":"1","Hunt-Profile-Created-Time":"1742986241847058","Hunt-Channel-Created-Time":"1742986241847058","Hunt-Channel-Answered-Time":"0","Hunt-Channel-Progress-Time":"0","Hunt-Channel-Progress-Media-Time":"0","Hunt-Channel-Hangup-Time":"0","Hunt-Channel-Transfer-Time":"0","Hunt-Channel-Resurrect-Time":"0","Hunt-Channel-Bridged-Time":"0","Hunt-Channel-Last-Hold":"0","Hunt-Channel-Hold-Accum":"0","Hunt-Screen-Bit":"true","Hunt-Privacy-Hide-Name":"false","Hunt-Privacy-Hide-Number":"false","Fetch-UUID":"83efe426-7b44-45f4-be35-5d3d90bea343","Fetch-Section":"dialplan","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Fetch-Timeout":"0","Fetch-Timestamp-Micro":"1742986241867031","Kazoo-Version":"mod_amqp v0.0.1 kageds","Kazoo-Bundle":"community","Kazoo-Release":"v1.5.0-1"}}

================================================================================
2025-03-26T10:50:41.870+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      175
Exchange:     freeswitch
Routing keys: [<<"FreeSWITCH.debian12-kazoo.CHANNEL_CREATE.66717c2c66232d6e">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_fs_amqp_listener-<0.1619.0>-00a71b61
Properties:   [{<<"timestamp">>,signedint,1742986241},
               {<<"headers">>,table,
                [{<<"x_Liquid_MessageSentTimeStamp">>,timestamp,1742986241}]},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Event-Name":"CHANNEL_CREATE","Core-UUID":"917c114b-eaf1-40f2-8407-4d2cd97687a1","FreeSWITCH-Hostname":"debian12-kazoo","FreeSWITCH-Switchname":"debian12-kazoo","FreeSWITCH-IPv4":"10.1.1.14","FreeSWITCH-IPv6":"::1","Event-Date-Local":"2025-03-26 10:50:41","Event-Date-GMT":"Wed, 26 Mar 2025 10:50:41 GMT","Event-Date-Timestamp":"1742986241847058","Event-Calling-File":"switch_core_state_machine.c","Event-Calling-Function":"switch_core_session_run","Event-Calling-Line-Number":"626","Event-Sequence":"685","Channel-State":"CS_INIT","Channel-Call-State":"DOWN","Channel-State-Number":"2","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Unique-ID":"66717c2c66232d6e","Call-Direction":"inbound","Presence-Call-Direction":"inbound","Channel-HIT-Dialplan":"true","Channel-Presence-ID":"1000@4f5549.sip.2600hz.com","Channel-Call-UUID":"66717c2c66232d6e","Answer-State":"ringing","Caller-Direction":"inbound","Caller-Logical-Direction":"inbound","Caller-Username":"user_p48egZdPh4","Caller-Dialplan":"XML","Caller-Caller-ID-Name":"user_p48egZdPh4","Caller-Caller-ID-Number":"user_p48egZdPh4","Caller-Orig-Caller-ID-Name":"user_p48egZdPh4","Caller-Orig-Caller-ID-Number":"user_p48egZdPh4","Caller-Network-Addr":"10.1.1.14","Caller-ANI":"user_p48egZdPh4","Caller-Destination-Number":"1001","Caller-Unique-ID":"66717c2c66232d6e","Caller-Source":"mod_sofia","Caller-Context":"context_2","Caller-Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Caller-Profile-Index":"1","Caller-Profile-Created-Time":"1742986241847058","Caller-Channel-Created-Time":"1742986241847058","Caller-Channel-Answered-Time":"0","Caller-Channel-Progress-Time":"0","Caller-Channel-Progress-Media-Time":"0","Caller-Channel-Hangup-Time":"0","Caller-Channel-Transfer-Time":"0","Caller-Channel-Resurrect-Time":"0","Caller-Channel-Bridged-Time":"0","Caller-Channel-Last-Hold":"0","Caller-Channel-Hold-Accum":"0","Caller-Screen-Bit":"true","Caller-Privacy-Hide-Name":"false","Caller-Privacy-Hide-Number":"false","variable_direction":"inbound","variable_uuid":"66717c2c66232d6e","variable_call_uuid":"66717c2c66232d6e","variable_session_id":"3","variable_sip_from_user":"user_p48egZdPh4","variable_sip_from_uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_from_host":"4f5549.sip.2600hz.com","variable_video_media_flow":"disabled","variable_audio_media_flow":"disabled","variable_text_media_flow":"disabled","variable_channel_name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_call_id":"66717c2c66232d6e","variable_sip_local_network_addr":"10.1.1.14","variable_sip_network_ip":"10.1.1.14","variable_sip_network_port":"5060","variable_sip_invite_stamp":"1742986241847058","variable_sip_received_ip":"10.1.1.14","variable_sip_received_port":"5060","variable_sip_via_protocol":"udp","variable_sip_authorized":"true","variable_ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_ecallmgr_Authorizing-Type":"device","variable_ecallmgr_Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","variable_ecallmgr_Username":"user_p48egzdph4","variable_ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_ecallmgr_Account-Realm":"4f5549.sip.2600hz.com","variable_ecallmgr_Account-Name":"Kage Design Services Ltd","variable_presence_id":"1000@4f5549.sip.2600hz.com","variable_ecallmgr_Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","variable_user_name":"user_p48egZdPh4","variable_domain_name":"4f5549.sip.2600hz.com","variable_sip_from_user_stripped":"user_p48egZdPh4","variable_sip_from_tag":"2628444714184456","variable_sofia_profile_name":"sipinterface_1","variable_sofia_profile_url":"sip:mod_sofia@10.1.1.14:11000","variable_recovery_profile_name":"sipinterface_1","variable_sip_invite_route_uri":"<sip:10.1.1.14;lr=on;ftag=2628444714184456>","variable_sip_invite_record_route":"<sip:10.1.1.14;lr=on;ftag=2628444714184456>","variable_sip_full_via":"SIP/2.0/UDP 10.1.1.14;branch=z9hG4bK6eab.a30fe37d5e0744b8c9a9b6986b0f2375.0,SIP/2.0/UDP 10.1.1.31:54730;received=10.1.1.31;branch=z9hG4bK584229b86fc25ed2;rport=54730","variable_sip_full_from":"<sip:user_p48egZdPh4@4f5549.sip.2600hz.com>;tag=2628444714184456","variable_sip_full_to":"<sip:1001@4f5549.sip.2600hz.com>","variable_sip_allow":"INVITE, ACK, BYE, CANCEL, OPTIONS, REFER, NOTIFY, SUBSCRIBE, INFO","variable_sip_req_user":"1001","variable_sip_req_uri":"1001@4f5549.sip.2600hz.com","variable_sip_req_host":"4f5549.sip.2600hz.com","variable_sip_to_user":"1001","variable_sip_to_uri":"1001@4f5549.sip.2600hz.com","variable_sip_to_host":"4f5549.sip.2600hz.com","variable_sip_contact_params":"alias=10.1.1.31~54730~1","variable_sip_contact_user":"user_p48egZdPh4","variable_sip_contact_port":"54730","variable_sip_contact_uri":"user_p48egZdPh4@10.1.1.31:54730","variable_sip_contact_host":"10.1.1.31","variable_rtp_use_codec_string":"OPUS,VP8,H263,H264,G7221@32000h,G7221@16000h,G722,PCMU,PCMA,G729,GSM,Speex","variable_sip_user_agent":"tSIP 0.01.70.00","variable_sip_via_host":"10.1.1.14","variable_max_forwards":"50","variable_sip_h_X-AUTH-IP":"10.1.1.31","variable_sip_h_X-AUTH-PORT":"54730","variable_sip_h_X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","variable_sip_h_X-ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_sip_h_X-ecallmgr_Authorizing-Type":"device","variable_sip_h_X-ecallmgr_Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","variable_sip_h_X-ecallmgr_Username":"user_p48egzdph4","variable_sip_h_X-ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_sip_h_X-ecallmgr_Account-Realm":"4f5549.sip.2600hz.com","variable_sip_h_X-ecallmgr_Account-Name":"Kage Design Services Ltd","variable_sip_h_X-ecallmgr_Presence-ID":"1000@4f5549.sip.2600hz.com","variable_sip_h_X-ecallmgr_Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","variable_switch_r_sdp":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_ep_codec_string":"CORE_PCM_MODULE.PCMU@8000h@20i@64000b,CORE_PCM_MODULE.PCMA@8000h@20i@64000b","variable_endpoint_disposition":"DELAYED NEGOTIATION","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com"}

================================================================================
2025-03-26T10:50:41.876+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      175
Exchange:     freeswitch
Routing keys: [<<"FreeSWITCH.dialplan.request.83efe426-7b44-45f4-be35-5d3d90bea343">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_fs_amqp_listener-<0.1619.0>-00a71b61
Properties:   [{<<"timestamp">>,signedint,1742986241},
               {<<"headers">>,table,
                [{<<"x_Liquid_MessageSentTimeStamp">>,timestamp,1742986241}]},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"call_uuid":"83efe426-7b44-45f4-be35-5d3d90bea343","action":"request","section":"dialplan","variables":{"Event-Name":"REQUEST_PARAMS","Core-UUID":"917c114b-eaf1-40f2-8407-4d2cd97687a1","FreeSWITCH-Hostname":"debian12-kazoo","FreeSWITCH-Switchname":"debian12-kazoo","FreeSWITCH-IPv4":"10.1.1.14","FreeSWITCH-IPv6":"::1","Event-Date-Local":"2025-03-26 10:50:41","Event-Date-GMT":"Wed, 26 Mar 2025 10:50:41 GMT","Event-Date-Timestamp":"1742986241867031","Event-Calling-File":"mod_dialplan_xml.c","Event-Calling-Function":"dialplan_xml_locate","Event-Calling-Line-Number":"610","Event-Sequence":"688","Channel-State":"CS_ROUTING","Channel-Call-State":"RINGING","Channel-State-Number":"2","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Unique-ID":"66717c2c66232d6e","Call-Direction":"inbound","Presence-Call-Direction":"inbound","Channel-HIT-Dialplan":"true","Channel-Presence-ID":"1000@4f5549.sip.2600hz.com","Channel-Call-UUID":"66717c2c66232d6e","Answer-State":"ringing","Caller-Direction":"inbound","Caller-Logical-Direction":"inbound","Caller-Username":"user_p48egZdPh4","Caller-Dialplan":"XML","Caller-Caller-ID-Name":"user_p48egZdPh4","Caller-Caller-ID-Number":"user_p48egZdPh4","Caller-Orig-Caller-ID-Name":"user_p48egZdPh4","Caller-Orig-Caller-ID-Number":"user_p48egZdPh4","Caller-Network-Addr":"10.1.1.14","Caller-ANI":"user_p48egZdPh4","Caller-Destination-Number":"1001","Caller-Unique-ID":"66717c2c66232d6e","Caller-Source":"mod_sofia","Caller-Context":"context_2","Caller-Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Caller-Profile-Index":"1","Caller-Profile-Created-Time":"1742986241847058","Caller-Channel-Created-Time":"1742986241847058","Caller-Channel-Answered-Time":"0","Caller-Channel-Progress-Time":"0","Caller-Channel-Progress-Media-Time":"0","Caller-Channel-Hangup-Time":"0","Caller-Channel-Transfer-Time":"0","Caller-Channel-Resurrect-Time":"0","Caller-Channel-Bridged-Time":"0","Caller-Channel-Last-Hold":"0","Caller-Channel-Hold-Accum":"0","Caller-Screen-Bit":"true","Caller-Privacy-Hide-Name":"false","Caller-Privacy-Hide-Number":"false","variable_direction":"inbound","variable_uuid":"66717c2c66232d6e","variable_session_id":"3","variable_sip_from_user":"user_p48egZdPh4","variable_sip_from_uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_from_host":"4f5549.sip.2600hz.com","variable_video_media_flow":"disabled","variable_audio_media_flow":"disabled","variable_text_media_flow":"disabled","variable_channel_name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_call_id":"66717c2c66232d6e","variable_sip_local_network_addr":"10.1.1.14","variable_sip_network_ip":"10.1.1.14","variable_sip_network_port":"5060","variable_sip_invite_stamp":"1742986241847058","variable_sip_received_ip":"10.1.1.14","variable_sip_received_port":"5060","variable_sip_via_protocol":"udp","variable_sip_authorized":"true","variable_ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_ecallmgr_Authorizing-Type":"device","variable_ecallmgr_Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","variable_ecallmgr_Username":"user_p48egzdph4","variable_ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_ecallmgr_Account-Realm":"4f5549.sip.2600hz.com","variable_ecallmgr_Account-Name":"Kage Design Services Ltd","variable_presence_id":"1000@4f5549.sip.2600hz.com","variable_ecallmgr_Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","variable_user_name":"user_p48egZdPh4","variable_domain_name":"4f5549.sip.2600hz.com","variable_sip_from_user_stripped":"user_p48egZdPh4","variable_sip_from_tag":"2628444714184456","variable_sofia_profile_name":"sipinterface_1","variable_sofia_profile_url":"sip:mod_sofia@10.1.1.14:11000","variable_recovery_profile_name":"sipinterface_1","variable_sip_invite_route_uri":"<sip:10.1.1.14;lr=on;ftag=2628444714184456>","variable_sip_invite_record_route":"<sip:10.1.1.14;lr=on;ftag=2628444714184456>","variable_sip_full_via":"SIP/2.0/UDP 10.1.1.14;branch=z9hG4bK6eab.a30fe37d5e0744b8c9a9b6986b0f2375.0,SIP/2.0/UDP 10.1.1.31:54730;received=10.1.1.31;branch=z9hG4bK584229b86fc25ed2;rport=54730","variable_sip_full_from":"<sip:user_p48egZdPh4@4f5549.sip.2600hz.com>;tag=2628444714184456","variable_sip_full_to":"<sip:1001@4f5549.sip.2600hz.com>","variable_sip_allow":"INVITE, ACK, BYE, CANCEL, OPTIONS, REFER, NOTIFY, SUBSCRIBE, INFO","variable_sip_req_user":"1001","variable_sip_req_uri":"1001@4f5549.sip.2600hz.com","variable_sip_req_host":"4f5549.sip.2600hz.com","variable_sip_to_user":"1001","variable_sip_to_uri":"1001@4f5549.sip.2600hz.com","variable_sip_to_host":"4f5549.sip.2600hz.com","variable_sip_contact_params":"alias=10.1.1.31~54730~1","variable_sip_contact_user":"user_p48egZdPh4","variable_sip_contact_port":"54730","variable_sip_contact_uri":"user_p48egZdPh4@10.1.1.31:54730","variable_sip_contact_host":"10.1.1.31","variable_rtp_use_codec_string":"OPUS,VP8,H263,H264,G7221@32000h,G7221@16000h,G722,PCMU,PCMA,G729,GSM,Speex","variable_sip_user_agent":"tSIP 0.01.70.00","variable_sip_via_host":"10.1.1.14","variable_max_forwards":"50","variable_sip_h_X-AUTH-IP":"10.1.1.31","variable_sip_h_X-AUTH-PORT":"54730","variable_sip_h_X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","variable_sip_h_X-ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_sip_h_X-ecallmgr_Authorizing-Type":"device","variable_sip_h_X-ecallmgr_Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","variable_sip_h_X-ecallmgr_Username":"user_p48egzdph4","variable_sip_h_X-ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_sip_h_X-ecallmgr_Account-Realm":"4f5549.sip.2600hz.com","variable_sip_h_X-ecallmgr_Account-Name":"Kage Design Services Ltd","variable_sip_h_X-ecallmgr_Presence-ID":"1000@4f5549.sip.2600hz.com","variable_sip_h_X-ecallmgr_Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","variable_switch_r_sdp":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_ep_codec_string":"CORE_PCM_MODULE.PCMU@8000h@20i@64000b,CORE_PCM_MODULE.PCMA@8000h@20i@64000b","variable_endpoint_disposition":"DELAYED NEGOTIATION","variable_call_uuid":"66717c2c66232d6e","Hunt-Direction":"inbound","Hunt-Logical-Direction":"inbound","Hunt-Username":"user_p48egZdPh4","Hunt-Dialplan":"XML","Hunt-Caller-ID-Name":"user_p48egZdPh4","Hunt-Caller-ID-Number":"user_p48egZdPh4","Hunt-Orig-Caller-ID-Name":"user_p48egZdPh4","Hunt-Orig-Caller-ID-Number":"user_p48egZdPh4","Hunt-Network-Addr":"10.1.1.14","Hunt-ANI":"user_p48egZdPh4","Hunt-Destination-Number":"1001","Hunt-Unique-ID":"66717c2c66232d6e","Hunt-Source":"mod_sofia","Hunt-Context":"context_2","Hunt-Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Hunt-Profile-Index":"1","Hunt-Profile-Created-Time":"1742986241847058","Hunt-Channel-Created-Time":"1742986241847058","Hunt-Channel-Answered-Time":"0","Hunt-Channel-Progress-Time":"0","Hunt-Channel-Progress-Media-Time":"0","Hunt-Channel-Hangup-Time":"0","Hunt-Channel-Transfer-Time":"0","Hunt-Channel-Resurrect-Time":"0","Hunt-Channel-Bridged-Time":"0","Hunt-Channel-Last-Hold":"0","Hunt-Channel-Hold-Accum":"0","Hunt-Screen-Bit":"true","Hunt-Privacy-Hide-Name":"false","Hunt-Privacy-Hide-Number":"false","Fetch-UUID":"83efe426-7b44-45f4-be35-5d3d90bea343","Fetch-Section":"dialplan","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Fetch-Timeout":"0","Fetch-Timestamp-Micro":"1742986241867031","Kazoo-Version":"mod_amqp v0.0.1 kageds","Kazoo-Bundle":"community","Kazoo-Release":"v1.5.0-1"}}

================================================================================
2025-03-26T10:50:41.876+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      86
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_CREATE.66717c2c66232d6e">>]
Routed queues: [<<"webhooks_shared_listener">>]
Properties:   [{<<"timestamp">>,signedint,63910205441873334},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"To-Uri":"1001@4f5549.sip.2600hz.com","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205441,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Request":"1001@4f5549.sip.2600hz.com","Presence-ID":"1000@4f5549.sip.2600hz.com","Media-Server":"debian12-kazoo","From-Uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","From-Tag":"2628444714184456","From":"1000@4f5549.sip.2600hz.com","Disposition":"DELAYED NEGOTIATION","Custom-SIP-Headers":{"X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","X-AUTH-PORT":"54730","X-AUTH-IP":"10.1.1.31"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Presence-ID":"1000@4f5549.sip.2600hz.com","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4"},"Custom-Application-Vars":{},"Channel-State":"INIT","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241847058,"Channel-Call-State":"DOWN","Caller-ID-Number":"user_p48egZdPh4","Caller-ID-Name":"user_p48egZdPh4","Call-Direction":"inbound","Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986241847058","Event-Name":"CHANNEL_CREATE","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.877+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      223
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_CREATE.66717c2c66232d6e">>]
Queue:        webhooks_shared_listener
Properties:   [{<<"timestamp">>,signedint,63910205441873334},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"To-Uri":"1001@4f5549.sip.2600hz.com","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205441,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Request":"1001@4f5549.sip.2600hz.com","Presence-ID":"1000@4f5549.sip.2600hz.com","Media-Server":"debian12-kazoo","From-Uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","From-Tag":"2628444714184456","From":"1000@4f5549.sip.2600hz.com","Disposition":"DELAYED NEGOTIATION","Custom-SIP-Headers":{"X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","X-AUTH-PORT":"54730","X-AUTH-IP":"10.1.1.31"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Presence-ID":"1000@4f5549.sip.2600hz.com","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4"},"Custom-Application-Vars":{},"Channel-State":"INIT","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241847058,"Channel-Call-State":"DOWN","Caller-ID-Number":"user_p48egZdPh4","Caller-ID-Name":"user_p48egZdPh4","Call-Direction":"inbound","Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986241847058","Event-Name":"CHANNEL_CREATE","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.877+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      87
Exchange:     freeswitch
Routing keys: [<<"KAZOO.command.api">>]
Routed queues: [<<"freeswitch.commands">>]
Properties:   [{<<"timestamp">>,signedint,63910205441872830},
               {<<"reply_to">>,longstr,
                <<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.623.0>-11db6b23">>},
               {<<"correlation_id">>,longstr,<<"e50c4e7e4d8670ec">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"args":"66717c2c66232d6e ecallmgr_Call-Interaction-ID=63910205441-db5e04cf","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","command":"kz_uuid_setvar_multi","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.623.0>-11db6b23","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"e50c4e7e4d8670ec","Msg-ID":"e50c4e7e4d8670ec","Event-Name":"api_req","Event-Category":"api","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.879+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60062 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"KAZOO.command.api">>]
Queue:        freeswitch.commands
Properties:   [{<<"timestamp">>,signedint,63910205441872830},
               {<<"reply_to">>,longstr,
                <<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.623.0>-11db6b23">>},
               {<<"correlation_id">>,longstr,<<"e50c4e7e4d8670ec">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"args":"66717c2c66232d6e ecallmgr_Call-Interaction-ID=63910205441-db5e04cf","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","command":"kz_uuid_setvar_multi","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.623.0>-11db6b23","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"e50c4e7e4d8670ec","Msg-ID":"e50c4e7e4d8670ec","Event-Name":"api_req","Event-Category":"api","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.880+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      85
Exchange:     callmgr
Routing keys: [<<"route.req.audio.47459457c634aff90b96f6af8a8eebb6">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-cf_listener-<0.1847.0>-32c81897">>,
                <<"kazoo_apps@debian12-kazoo.kageds.com-conference_listener-<0.1890.0>-25419573">>,
                <<"kazoo_apps@debian12-kazoo.kageds.com-milliwatt_listener-<0.2323.0>-63623265">>,
                <<"trunkstore_listener">>]
Properties:   [{<<"timestamp">>,signedint,63910205441874791},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","SIP-Request-Host":"4f5549.sip.2600hz.com","Resource-Type":"audio","From-Tag":"2628444714184456","From-Network-Port":"54730","From-Network-Addr":"10.1.1.31","Context":"context_2","Custom-SIP-Headers":{"X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","X-AUTH-PORT":"54730","X-AUTH-IP":"10.1.1.31"},"Custom-Channel-Vars":{"Call-Interaction-ID":"63910205441-db5e04cf","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Presence-ID":"1000@4f5549.sip.2600hz.com","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4","Privacy-Hide-Name":false,"Privacy-Hide-Number":false},"Caller-ID-Number":"user_p48egZdPh4","Caller-ID-Name":"user_p48egZdPh4","Call-Direction":"inbound","Call-ID":"66717c2c66232d6e","To":"1001@4f5549.sip.2600hz.com","Request":"1001@4f5549.sip.2600hz.com","From":"1000@4f5549.sip.2600hz.com","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.620.0>-e114bce2","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"66717c2c66232d6e","Msg-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Event-Name":"route_req","Event-Category":"dialplan","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.880+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60062 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.623.0>-11db6b23">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.623.0>-11db6b23">>]
Properties:   [{<<"correlation_id">>,longstr,<<"e50c4e7e4d8670ec">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"response":"+OK\n","App-Name":"mod_amqp","App-Version":"0.0.1","Event-Name":"command_response","Event-Category":"api","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Msg-ID":"e50c4e7e4d8670ec"}

================================================================================
2025-03-26T10:50:41.880+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      87
Exchange:     
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.623.0>-11db6b23">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.623.0>-11db6b23
Properties:   [{<<"correlation_id">>,longstr,<<"e50c4e7e4d8670ec">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"response":"+OK\n","App-Name":"mod_amqp","App-Version":"0.0.1","Event-Name":"command_response","Event-Category":"api","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Msg-ID":"e50c4e7e4d8670ec"}

================================================================================
2025-03-26T10:50:41.881+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      182
Exchange:     callmgr
Routing keys: [<<"route.req.audio.47459457c634aff90b96f6af8a8eebb6">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-cf_listener-<0.1847.0>-32c81897
Properties:   [{<<"timestamp">>,signedint,63910205441874791},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","SIP-Request-Host":"4f5549.sip.2600hz.com","Resource-Type":"audio","From-Tag":"2628444714184456","From-Network-Port":"54730","From-Network-Addr":"10.1.1.31","Context":"context_2","Custom-SIP-Headers":{"X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","X-AUTH-PORT":"54730","X-AUTH-IP":"10.1.1.31"},"Custom-Channel-Vars":{"Call-Interaction-ID":"63910205441-db5e04cf","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Presence-ID":"1000@4f5549.sip.2600hz.com","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4","Privacy-Hide-Name":false,"Privacy-Hide-Number":false},"Caller-ID-Number":"user_p48egZdPh4","Caller-ID-Name":"user_p48egZdPh4","Call-Direction":"inbound","Call-ID":"66717c2c66232d6e","To":"1001@4f5549.sip.2600hz.com","Request":"1001@4f5549.sip.2600hz.com","From":"1000@4f5549.sip.2600hz.com","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.620.0>-e114bce2","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"66717c2c66232d6e","Msg-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Event-Name":"route_req","Event-Category":"dialplan","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.881+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      186
Exchange:     callmgr
Routing keys: [<<"route.req.audio.47459457c634aff90b96f6af8a8eebb6">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-conference_listener-<0.1890.0>-25419573
Properties:   [{<<"timestamp">>,signedint,63910205441874791},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","SIP-Request-Host":"4f5549.sip.2600hz.com","Resource-Type":"audio","From-Tag":"2628444714184456","From-Network-Port":"54730","From-Network-Addr":"10.1.1.31","Context":"context_2","Custom-SIP-Headers":{"X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","X-AUTH-PORT":"54730","X-AUTH-IP":"10.1.1.31"},"Custom-Channel-Vars":{"Call-Interaction-ID":"63910205441-db5e04cf","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Presence-ID":"1000@4f5549.sip.2600hz.com","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4","Privacy-Hide-Name":false,"Privacy-Hide-Number":false},"Caller-ID-Number":"user_p48egZdPh4","Caller-ID-Name":"user_p48egZdPh4","Call-Direction":"inbound","Call-ID":"66717c2c66232d6e","To":"1001@4f5549.sip.2600hz.com","Request":"1001@4f5549.sip.2600hz.com","From":"1000@4f5549.sip.2600hz.com","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.620.0>-e114bce2","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"66717c2c66232d6e","Msg-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Event-Name":"route_req","Event-Category":"dialplan","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.881+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      208
Exchange:     callmgr
Routing keys: [<<"route.req.audio.47459457c634aff90b96f6af8a8eebb6">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-milliwatt_listener-<0.2323.0>-63623265
Properties:   [{<<"timestamp">>,signedint,63910205441874791},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","SIP-Request-Host":"4f5549.sip.2600hz.com","Resource-Type":"audio","From-Tag":"2628444714184456","From-Network-Port":"54730","From-Network-Addr":"10.1.1.31","Context":"context_2","Custom-SIP-Headers":{"X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","X-AUTH-PORT":"54730","X-AUTH-IP":"10.1.1.31"},"Custom-Channel-Vars":{"Call-Interaction-ID":"63910205441-db5e04cf","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Presence-ID":"1000@4f5549.sip.2600hz.com","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4","Privacy-Hide-Name":false,"Privacy-Hide-Number":false},"Caller-ID-Number":"user_p48egZdPh4","Caller-ID-Name":"user_p48egZdPh4","Call-Direction":"inbound","Call-ID":"66717c2c66232d6e","To":"1001@4f5549.sip.2600hz.com","Request":"1001@4f5549.sip.2600hz.com","From":"1000@4f5549.sip.2600hz.com","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.620.0>-e114bce2","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"66717c2c66232d6e","Msg-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Event-Name":"route_req","Event-Category":"dialplan","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.881+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      220
Exchange:     callmgr
Routing keys: [<<"route.req.audio.47459457c634aff90b96f6af8a8eebb6">>]
Queue:        trunkstore_listener
Properties:   [{<<"timestamp">>,signedint,63910205441874791},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","SIP-Request-Host":"4f5549.sip.2600hz.com","Resource-Type":"audio","From-Tag":"2628444714184456","From-Network-Port":"54730","From-Network-Addr":"10.1.1.31","Context":"context_2","Custom-SIP-Headers":{"X-AUTH-Token":"8d604a1881ea0c16e12971622e2a8cac@47459457c634aff90b96f6af8a8eebb6","X-AUTH-PORT":"54730","X-AUTH-IP":"10.1.1.31"},"Custom-Channel-Vars":{"Call-Interaction-ID":"63910205441-db5e04cf","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Presence-ID":"1000@4f5549.sip.2600hz.com","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4","Privacy-Hide-Name":false,"Privacy-Hide-Number":false},"Caller-ID-Number":"user_p48egZdPh4","Caller-ID-Name":"user_p48egZdPh4","Call-Direction":"inbound","Call-ID":"66717c2c66232d6e","To":"1001@4f5549.sip.2600hz.com","Request":"1001@4f5549.sip.2600hz.com","From":"1000@4f5549.sip.2600hz.com","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.620.0>-e114bce2","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"66717c2c66232d6e","Msg-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Event-Name":"route_req","Event-Category":"dialplan","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.893+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      84
Exchange:     targeted
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.620.0>-e114bce2">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.620.0>-e114bce2">>]
Properties:   [{<<"timestamp">>,signedint,63910205441892099},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Routes":[],"Pre-Park":"none","From-Realm":"4f5549.sip.2600hz.com","Custom-Channel-Vars":{"Username":"user_p48egzdph4","Realm":"4f5549.sip.2600hz.com","Privacy-Hide-Number":false,"Privacy-Hide-Name":false,"Presence-ID":"1000@4f5549.sip.2600hz.com","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Call-Interaction-ID":"63910205441-db5e04cf","Authorizing-Type":"device","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Account-Realm":"4f5549.sip.2600hz.com","Account-Name":"Kage Design Services Ltd","Account-ID":"47459457c634aff90b96f6af8a8eebb6","CallFlow-ID":"7c7290c92292369eb0737a157b8169be"},"Custom-Application-Vars":{},"Method":"park","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.617.0>-6af150b5","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Msg-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Event-Name":"route_resp","Event-Category":"dialplan","App-Version":"4.0.0","App-Name":"callflow"}

================================================================================
2025-03-26T10:50:41.893+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      85
Exchange:     targeted
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.620.0>-e114bce2">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.620.0>-e114bce2
Properties:   [{<<"timestamp">>,signedint,63910205441892099},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Routes":[],"Pre-Park":"none","From-Realm":"4f5549.sip.2600hz.com","Custom-Channel-Vars":{"Username":"user_p48egzdph4","Realm":"4f5549.sip.2600hz.com","Privacy-Hide-Number":false,"Privacy-Hide-Name":false,"Presence-ID":"1000@4f5549.sip.2600hz.com","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Call-Interaction-ID":"63910205441-db5e04cf","Authorizing-Type":"device","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Account-Realm":"4f5549.sip.2600hz.com","Account-Name":"Kage Design Services Ltd","Account-ID":"47459457c634aff90b96f6af8a8eebb6","CallFlow-ID":"7c7290c92292369eb0737a157b8169be"},"Custom-Application-Vars":{},"Method":"park","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.617.0>-6af150b5","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Msg-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Event-Name":"route_resp","Event-Category":"dialplan","App-Version":"4.0.0","App-Name":"callflow"}

================================================================================
2025-03-26T10:50:41.898+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      227
Exchange:     freeswitch
Routing keys: [<<"KAZOO.dialplan.response.83efe426-7b44-45f4-be35-5d3d90bea343">>]
Routed queues: [<<"freeswitch.fetchers">>]
Properties:   [{<<"timestamp">>,signedint,63910205441895897},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Fetch-UUID":"83efe426-7b44-45f4-be35-5d3d90bea343","response":"<document type=\"freeswitch/xml\"><section name=\"dialplan\" description=\"Route Park Response\"><context name=\"context_2\"><extension name=\"park\"><condition><action application=\"log\" data=\"NOTICE log|${uuid}|kazoo_apps@debian12-kazoo.kageds.com won call control\"/><action application=\"export\" data=\"ecallmgr_Ecallmgr-Node=kazoo_apps@debian12-kazoo.kageds.com\"/><condition field=\"${ecallmgr_Bridge-ID}\" expression=\"^$\"><action application=\"export\" data=\"ecallmgr_Bridge-ID=${UUID}\" inline=\"true\"/></condition><action application=\"set\" data=\"ringback=%(2000,4000,440,480)\"/><action application=\"set\" data=\"transfer_ringback=%(2000,4000,440,480)\"/><action application=\"kz_multiset\" data=\"^^|ecallmgr_Username=user_p48egzdph4|ecallmgr_Realm=4f5549.sip.2600hz.com|ecallmgr_Privacy-Hide-Number=false|ecallmgr_Privacy-Hide-Name=false|presence_id=1000@4f5549.sip.2600hz.com|ecallmgr_Owner-ID=dbfb28b1de0750b697d26fb61e9ea863|ecallmgr_Fetch-ID=83efe426-7b44-45f4-be35-5d3d90bea343|ecallmgr_Call-Interaction-ID=63910205441-db5e04cf|ecallmgr_Authorizing-Type=device|ecallmgr_Authorizing-ID=8d604a1881ea0c16e12971622e2a8cac|ecallmgr_Account-Realm=4f5549.sip.2600hz.com|ecallmgr_Account-Name=Kage Design Services Ltd|ecallmgr_Account-ID=47459457c634aff90b96f6af8a8eebb6|ecallmgr_CallFlow-ID=7c7290c92292369eb0737a157b8169be|ecallmgr_Channel-Authorized=true\"/><action application=\"multiunset\" data=\"^^;sip_h_X-AUTH-IP;sip_h_X-AUTH-PORT;sip_h_X-AUTH-Token;sip_h_X-ecallmgr_Account-ID;sip_h_X-ecallmgr_Authorizing-Type;sip_h_X-ecallmgr_Authorizing-ID;sip_h_X-ecallmgr_Username;sip_h_X-ecallmgr_Realm;sip_h_X-ecallmgr_Account-Realm;sip_h_X-ecallmgr_Account-Name;sip_h_X-ecallmgr_Presence-ID;sip_h_X-ecallmgr_Owner-ID\"/><action application=\"park\"/></condition></extension></context></section></document>","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"f90522a62c92b50698b7b89748776c0b","Event-Name":"directory_resp","Event-Category":"directory","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.900+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60068 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"KAZOO.dialplan.response.83efe426-7b44-45f4-be35-5d3d90bea343">>]
Queue:        freeswitch.fetchers
Properties:   [{<<"timestamp">>,signedint,63910205441895897},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Fetch-UUID":"83efe426-7b44-45f4-be35-5d3d90bea343","response":"<document type=\"freeswitch/xml\"><section name=\"dialplan\" description=\"Route Park Response\"><context name=\"context_2\"><extension name=\"park\"><condition><action application=\"log\" data=\"NOTICE log|${uuid}|kazoo_apps@debian12-kazoo.kageds.com won call control\"/><action application=\"export\" data=\"ecallmgr_Ecallmgr-Node=kazoo_apps@debian12-kazoo.kageds.com\"/><condition field=\"${ecallmgr_Bridge-ID}\" expression=\"^$\"><action application=\"export\" data=\"ecallmgr_Bridge-ID=${UUID}\" inline=\"true\"/></condition><action application=\"set\" data=\"ringback=%(2000,4000,440,480)\"/><action application=\"set\" data=\"transfer_ringback=%(2000,4000,440,480)\"/><action application=\"kz_multiset\" data=\"^^|ecallmgr_Username=user_p48egzdph4|ecallmgr_Realm=4f5549.sip.2600hz.com|ecallmgr_Privacy-Hide-Number=false|ecallmgr_Privacy-Hide-Name=false|presence_id=1000@4f5549.sip.2600hz.com|ecallmgr_Owner-ID=dbfb28b1de0750b697d26fb61e9ea863|ecallmgr_Fetch-ID=83efe426-7b44-45f4-be35-5d3d90bea343|ecallmgr_Call-Interaction-ID=63910205441-db5e04cf|ecallmgr_Authorizing-Type=device|ecallmgr_Authorizing-ID=8d604a1881ea0c16e12971622e2a8cac|ecallmgr_Account-Realm=4f5549.sip.2600hz.com|ecallmgr_Account-Name=Kage Design Services Ltd|ecallmgr_Account-ID=47459457c634aff90b96f6af8a8eebb6|ecallmgr_CallFlow-ID=7c7290c92292369eb0737a157b8169be|ecallmgr_Channel-Authorized=true\"/><action application=\"multiunset\" data=\"^^;sip_h_X-AUTH-IP;sip_h_X-AUTH-PORT;sip_h_X-AUTH-Token;sip_h_X-ecallmgr_Account-ID;sip_h_X-ecallmgr_Authorizing-Type;sip_h_X-ecallmgr_Authorizing-ID;sip_h_X-ecallmgr_Username;sip_h_X-ecallmgr_Realm;sip_h_X-ecallmgr_Account-Realm;sip_h_X-ecallmgr_Account-Name;sip_h_X-ecallmgr_Presence-ID;sip_h_X-ecallmgr_Owner-ID\"/><action application=\"park\"/></condition></extension></context></section></document>","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"f90522a62c92b50698b7b89748776c0b","Event-Name":"directory_resp","Event-Category":"directory","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.905+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      82
Exchange:     callevt
Routing keys: [<<"call.usurp_publisher.66717c2c66232d6e">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_usurp_monitor-<0.1581.0>-c2592700">>]
Properties:   [{<<"timestamp">>,signedint,63910205441903515},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Media-Node":"freeswitch@debian12-kazoo.kageds.com","Reference":"f84f799db8dd99d13ad773ae","Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"ca9222958b2cf9da","Event-Name":"usurp_publisher","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.906+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      170
Exchange:     callevt
Routing keys: [<<"call.usurp_publisher.66717c2c66232d6e">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_usurp_monitor-<0.1581.0>-c2592700
Properties:   [{<<"timestamp">>,signedint,63910205441903515},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Media-Node":"freeswitch@debian12-kazoo.kageds.com","Reference":"f84f799db8dd99d13ad773ae","Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"ca9222958b2cf9da","Event-Name":"usurp_publisher","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.907+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      83
Exchange:     freeswitch
Routing keys: [<<"KAZOO.command.api">>]
Routed queues: [<<"freeswitch.commands">>]
Properties:   [{<<"timestamp">>,signedint,63910205441904963},
               {<<"reply_to">>,longstr,
                <<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.590.0>-f61ae3cc">>},
               {<<"correlation_id">>,longstr,<<"e25bbf2c6aca396c">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"args":"66717c2c66232d6e ^^~ecallmgr_Username=user_p48egzdph4~ecallmgr_Realm=4f5549.sip.2600hz.com~ecallmgr_Privacy-Hide-Number=false~ecallmgr_Privacy-Hide-Name=false~presence_id=1000@4f5549.sip.2600hz.com~ecallmgr_Owner-ID=dbfb28b1de0750b697d26fb61e9ea863~ecallmgr_Fetch-ID=83efe426-7b44-45f4-be35-5d3d90bea343~ecallmgr_Call-Interaction-ID=63910205441-db5e04cf~ecallmgr_Authorizing-Type=device~ecallmgr_Authorizing-ID=8d604a1881ea0c16e12971622e2a8cac~ecallmgr_Account-Realm=4f5549.sip.2600hz.com~ecallmgr_Account-Name=Kage Design Services Ltd~ecallmgr_Account-ID=47459457c634aff90b96f6af8a8eebb6~ecallmgr_CallFlow-ID=7c7290c92292369eb0737a157b8169be~ecallmgr_Channel-Authorized=true~ecallmgr_Application-Node=kazoo_apps@debian12-kazoo.kageds.com~ecallmgr_Application-Name=callflow","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","command":"kz_uuid_setvar_multi","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.590.0>-f61ae3cc","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"e25bbf2c6aca396c","Msg-ID":"e25bbf2c6aca396c","Event-Name":"api_req","Event-Category":"api","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.909+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60062 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"KAZOO.command.api">>]
Queue:        freeswitch.commands
Properties:   [{<<"timestamp">>,signedint,63910205441904963},
               {<<"reply_to">>,longstr,
                <<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.590.0>-f61ae3cc">>},
               {<<"correlation_id">>,longstr,<<"e25bbf2c6aca396c">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"args":"66717c2c66232d6e ^^~ecallmgr_Username=user_p48egzdph4~ecallmgr_Realm=4f5549.sip.2600hz.com~ecallmgr_Privacy-Hide-Number=false~ecallmgr_Privacy-Hide-Name=false~presence_id=1000@4f5549.sip.2600hz.com~ecallmgr_Owner-ID=dbfb28b1de0750b697d26fb61e9ea863~ecallmgr_Fetch-ID=83efe426-7b44-45f4-be35-5d3d90bea343~ecallmgr_Call-Interaction-ID=63910205441-db5e04cf~ecallmgr_Authorizing-Type=device~ecallmgr_Authorizing-ID=8d604a1881ea0c16e12971622e2a8cac~ecallmgr_Account-Realm=4f5549.sip.2600hz.com~ecallmgr_Account-Name=Kage Design Services Ltd~ecallmgr_Account-ID=47459457c634aff90b96f6af8a8eebb6~ecallmgr_CallFlow-ID=7c7290c92292369eb0737a157b8169be~ecallmgr_Channel-Authorized=true~ecallmgr_Application-Node=kazoo_apps@debian12-kazoo.kageds.com~ecallmgr_Application-Name=callflow","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","command":"kz_uuid_setvar_multi","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.590.0>-f61ae3cc","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"e25bbf2c6aca396c","Msg-ID":"e25bbf2c6aca396c","Event-Name":"api_req","Event-Category":"api","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.910+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60062 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.590.0>-f61ae3cc">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.590.0>-f61ae3cc">>]
Properties:   [{<<"correlation_id">>,longstr,<<"e25bbf2c6aca396c">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"response":"+OK\n","App-Name":"mod_amqp","App-Version":"0.0.1","Event-Name":"command_response","Event-Category":"api","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Msg-ID":"e25bbf2c6aca396c"}

================================================================================
2025-03-26T10:50:41.910+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      83
Exchange:     
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.590.0>-f61ae3cc">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.590.0>-f61ae3cc
Properties:   [{<<"correlation_id">>,longstr,<<"e25bbf2c6aca396c">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"response":"+OK\n","App-Name":"mod_amqp","App-Version":"0.0.1","Event-Name":"command_response","Event-Category":"api","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Msg-ID":"e25bbf2c6aca396c"}

================================================================================
2025-03-26T10:50:41.920+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      228
Exchange:     targeted
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.617.0>-6af150b5">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.617.0>-6af150b5">>]
Properties:   [{<<"timestamp">>,signedint,63910205441919000},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Custom-Channel-Vars":{"Username":"user_p48egzdph4","Realm":"4f5549.sip.2600hz.com","Privacy-Hide-Number":false,"Privacy-Hide-Name":false,"Presence-ID":"1000@4f5549.sip.2600hz.com","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Call-Interaction-ID":"63910205441-db5e04cf","Authorizing-Type":"device","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Account-Realm":"4f5549.sip.2600hz.com","Account-Name":"Kage Design Services Ltd","Account-ID":"47459457c634aff90b96f6af8a8eebb6","CallFlow-ID":"7c7290c92292369eb0737a157b8169be","Channel-Authorized":"true","Application-Node":"kazoo_apps@debian12-kazoo.kageds.com","Application-Name":"callflow"},"Control-Queue":"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_call_control-<0.3132.0>-bf68cbc7","Call-ID":"66717c2c66232d6e","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_call_control-<0.3132.0>-bf68cbc7","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"66717c2c66232d6e","Event-Name":"route_win","Event-Category":"dialplan","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.920+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      228
Exchange:     callevt
Routing keys: [<<"call.usurp_control.66717c2c66232d6e">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_usurp_monitor-<0.1581.0>-c2592700">>]
Properties:   [{<<"timestamp">>,signedint,63910205441919191},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Media-Node":"freeswitch@debian12-kazoo.kageds.com","Reason":"Route-Win","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"09382a7a1ea9119621c4d057a6179cba","Event-Name":"usurp_control","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.920+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      84
Exchange:     targeted
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.617.0>-6af150b5">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.617.0>-6af150b5
Properties:   [{<<"timestamp">>,signedint,63910205441919000},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Custom-Channel-Vars":{"Username":"user_p48egzdph4","Realm":"4f5549.sip.2600hz.com","Privacy-Hide-Number":false,"Privacy-Hide-Name":false,"Presence-ID":"1000@4f5549.sip.2600hz.com","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Call-Interaction-ID":"63910205441-db5e04cf","Authorizing-Type":"device","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Account-Realm":"4f5549.sip.2600hz.com","Account-Name":"Kage Design Services Ltd","Account-ID":"47459457c634aff90b96f6af8a8eebb6","CallFlow-ID":"7c7290c92292369eb0737a157b8169be","Channel-Authorized":"true","Application-Node":"kazoo_apps@debian12-kazoo.kageds.com","Application-Name":"callflow"},"Control-Queue":"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_call_control-<0.3132.0>-bf68cbc7","Call-ID":"66717c2c66232d6e","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_call_control-<0.3132.0>-bf68cbc7","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"66717c2c66232d6e","Event-Name":"route_win","Event-Category":"dialplan","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.920+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      170
Exchange:     callevt
Routing keys: [<<"call.usurp_control.66717c2c66232d6e">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_usurp_monitor-<0.1581.0>-c2592700
Properties:   [{<<"timestamp">>,signedint,63910205441919191},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Media-Node":"freeswitch@debian12-kazoo.kageds.com","Reason":"Route-Win","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"09382a7a1ea9119621c4d057a6179cba","Event-Name":"usurp_control","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.925+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      182
Exchange:     callctl
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_call_control-<0.3132.0>-bf68cbc7">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_call_control-<0.3132.0>-bf68cbc7">>]
Properties:   [{<<"timestamp">>,signedint,63910205441922109},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Insert-At":"now","Custom-Channel-Vars":{"Caller-ID-Name":"Alan Evans","Caller-ID-Number":"1000","Privacy-Hide-Name":false,"Privacy-Hide-Number":false},"Custom-Call-Vars":{},"Call-ID":"66717c2c66232d6e","Application-Name":"set","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-cf_listener-<0.1847.0>-32c81897","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"5412c30dcba272fe753cc11099c4760e","Event-Name":"command","Event-Category":"call","App-Version":"4.0.0","App-Name":"callflow"}

================================================================================
2025-03-26T10:50:41.926+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      228
Exchange:     callctl
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_call_control-<0.3132.0>-bf68cbc7">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_call_control-<0.3132.0>-bf68cbc7
Properties:   [{<<"timestamp">>,signedint,63910205441922109},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Insert-At":"now","Custom-Channel-Vars":{"Caller-ID-Name":"Alan Evans","Caller-ID-Number":"1000","Privacy-Hide-Name":false,"Privacy-Hide-Number":false},"Custom-Call-Vars":{},"Call-ID":"66717c2c66232d6e","Application-Name":"set","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-cf_listener-<0.1847.0>-32c81897","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"5412c30dcba272fe753cc11099c4760e","Event-Name":"command","Event-Category":"call","App-Version":"4.0.0","App-Name":"callflow"}

================================================================================
2025-03-26T10:50:41.930+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      81
Exchange:     freeswitch
Routing keys: [<<"KAZOO.command.sendmsg">>]
Routed queues: [<<"freeswitch.commands">>]
Properties:   [{<<"timestamp">>,signedint,63910205441928189},
               {<<"reply_to">>,longstr,
                <<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.585.0>-1ebce836">>},
               {<<"correlation_id">>,longstr,<<"2ce42eabe76d4072">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","FSHeaders":{"call-command":"execute","execute-app-name":"kz_multiset","execute-app-arg":"^^~effective_caller_id_name=Alan Evans~effective_caller_id_number=1000~ecallmgr_Privacy-Hide-Name=false~ecallmgr_Privacy-Hide-Number=false"},"UUID":"66717c2c66232d6e","Msg-ID":"2ce42eabe76d4072","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.585.0>-1ebce836","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"2ce42eabe76d4072","Event-Name":"sendmsg_req","Event-Category":"sendmsg","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.930+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60062 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"KAZOO.command.sendmsg">>]
Queue:        freeswitch.commands
Properties:   [{<<"timestamp">>,signedint,63910205441928189},
               {<<"reply_to">>,longstr,
                <<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.585.0>-1ebce836">>},
               {<<"correlation_id">>,longstr,<<"2ce42eabe76d4072">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","FSHeaders":{"call-command":"execute","execute-app-name":"kz_multiset","execute-app-arg":"^^~effective_caller_id_name=Alan Evans~effective_caller_id_number=1000~ecallmgr_Privacy-Hide-Name=false~ecallmgr_Privacy-Hide-Number=false"},"UUID":"66717c2c66232d6e","Msg-ID":"2ce42eabe76d4072","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.585.0>-1ebce836","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"2ce42eabe76d4072","Event-Name":"sendmsg_req","Event-Category":"sendmsg","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.930+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60062 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.585.0>-1ebce836">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.585.0>-1ebce836">>]
Properties:   [{<<"correlation_id">>,longstr,<<"2ce42eabe76d4072">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"response":"ok","App-Name":"mod_amqp","App-Version":"0.0.1","Event-Name":"command_response","Event-Category":"api","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Msg-ID":"2ce42eabe76d4072"}

================================================================================
2025-03-26T10:50:41.931+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      81
Exchange:     
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.585.0>-1ebce836">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.585.0>-1ebce836
Properties:   [{<<"correlation_id">>,longstr,<<"2ce42eabe76d4072">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"response":"ok","App-Name":"mod_amqp","App-Version":"0.0.1","Event-Name":"command_response","Event-Category":"api","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Msg-ID":"2ce42eabe76d4072"}

================================================================================
2025-03-26T10:50:41.953+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      229
Exchange:     callctl
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_call_control-<0.3132.0>-bf68cbc7">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_call_control-<0.3132.0>-bf68cbc7">>]
Properties:   [{<<"timestamp">>,signedint,63910205441952245},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Export-Bridge-Variables":["hold_music"],"Timeout":20,"Ignore-Forward":"false","Dial-Endpoint-Method":"simultaneous","Endpoints":[{"To-Username":"user_42HqcPrjCA","To-User":"user_42HqcPrjCA","To-Realm":"4f5549.sip.2600hz.com","To-DID":"1001","Presence-ID":"1001@4f5549.sip.2600hz.com","Privacy-Method":"kazoo","Outbound-Callee-ID-Number":"1001","Outbound-Callee-ID-Name":"Alan Evans2","Ignore-Completed-Elsewhere":false,"Endpoint-Timeout":"20","Custom-SIP-Headers":{"X-KAZOO-INVITE-FORMAT":"contact","X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com"},"Custom-Channel-Vars":{"SIP-Invite-Domain":"4f5549.sip.2600hz.com","Media-Encryption-Enforce-Security":false,"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Authorizing-Type":"device","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379"},"Codecs":["PCMA","PCMU"],"Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Invite-Format":"contact"}],"Call-ID":"66717c2c66232d6e","Application-Name":"bridge","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"78f2dfa64bf9d4ca702eb65ac56470ab","Event-Name":"command","Event-Category":"call","App-Version":"4.0.0","App-Name":"callflow"}

================================================================================
2025-03-26T10:50:41.953+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      228
Exchange:     callctl
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_call_control-<0.3132.0>-bf68cbc7">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_call_control-<0.3132.0>-bf68cbc7
Properties:   [{<<"timestamp">>,signedint,63910205441952245},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Export-Bridge-Variables":["hold_music"],"Timeout":20,"Ignore-Forward":"false","Dial-Endpoint-Method":"simultaneous","Endpoints":[{"To-Username":"user_42HqcPrjCA","To-User":"user_42HqcPrjCA","To-Realm":"4f5549.sip.2600hz.com","To-DID":"1001","Presence-ID":"1001@4f5549.sip.2600hz.com","Privacy-Method":"kazoo","Outbound-Callee-ID-Number":"1001","Outbound-Callee-ID-Name":"Alan Evans2","Ignore-Completed-Elsewhere":false,"Endpoint-Timeout":"20","Custom-SIP-Headers":{"X-KAZOO-INVITE-FORMAT":"contact","X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com"},"Custom-Channel-Vars":{"SIP-Invite-Domain":"4f5549.sip.2600hz.com","Media-Encryption-Enforce-Security":false,"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Authorizing-Type":"device","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379"},"Codecs":["PCMA","PCMU"],"Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Invite-Format":"contact"}],"Call-ID":"66717c2c66232d6e","Application-Name":"bridge","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"78f2dfa64bf9d4ca702eb65ac56470ab","Event-Name":"command","Event-Category":"call","App-Version":"4.0.0","App-Name":"callflow"}

================================================================================
2025-03-26T10:50:41.956+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      79
Exchange:     freeswitch
Routing keys: [<<"KAZOO.command.sendmsg">>]
Routed queues: [<<"freeswitch.commands">>]
Properties:   [{<<"timestamp">>,signedint,63910205441955973},
               {<<"reply_to">>,longstr,
                <<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.584.0>-c95e51a0">>},
               {<<"correlation_id">>,longstr,<<"624dc2c2f3e2ac60">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","FSHeaders":{"call-command":"execute","execute-app-name":"kz_export","execute-app-arg":"^^~ringback=%(2000,4000,440,480)~transfer_ringback=%(2000,4000,440,480)"},"UUID":"66717c2c66232d6e","Msg-ID":"624dc2c2f3e2ac60","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.584.0>-c95e51a0","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"624dc2c2f3e2ac60","Event-Name":"sendmsg_req","Event-Category":"sendmsg","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.957+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60062 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"KAZOO.command.sendmsg">>]
Queue:        freeswitch.commands
Properties:   [{<<"timestamp">>,signedint,63910205441955973},
               {<<"reply_to">>,longstr,
                <<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.584.0>-c95e51a0">>},
               {<<"correlation_id">>,longstr,<<"624dc2c2f3e2ac60">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","FSHeaders":{"call-command":"execute","execute-app-name":"kz_export","execute-app-arg":"^^~ringback=%(2000,4000,440,480)~transfer_ringback=%(2000,4000,440,480)"},"UUID":"66717c2c66232d6e","Msg-ID":"624dc2c2f3e2ac60","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.584.0>-c95e51a0","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"624dc2c2f3e2ac60","Event-Name":"sendmsg_req","Event-Category":"sendmsg","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.957+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60062 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.584.0>-c95e51a0">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.584.0>-c95e51a0">>]
Properties:   [{<<"correlation_id">>,longstr,<<"624dc2c2f3e2ac60">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"response":"ok","App-Name":"mod_amqp","App-Version":"0.0.1","Event-Name":"command_response","Event-Category":"api","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Msg-ID":"624dc2c2f3e2ac60"}

================================================================================
2025-03-26T10:50:41.957+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      79
Exchange:     
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.584.0>-c95e51a0">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.584.0>-c95e51a0
Properties:   [{<<"correlation_id">>,longstr,<<"624dc2c2f3e2ac60">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"response":"ok","App-Name":"mod_amqp","App-Version":"0.0.1","Event-Name":"command_response","Event-Category":"api","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Msg-ID":"624dc2c2f3e2ac60"}

================================================================================
2025-03-26T10:50:41.962+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      80
Exchange:     freeswitch
Routing keys: [<<"KAZOO.command.sendmsg">>]
Routed queues: [<<"freeswitch.commands">>]
Properties:   [{<<"timestamp">>,signedint,63910205441961103},
               {<<"reply_to">>,longstr,
                <<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.582.0>-2f926212">>},
               {<<"correlation_id">>,longstr,<<"8ca1e4dde4d604a9">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","FSHeaders":{"call-command":"xferext","application":"set continue_on_fail=true","application":"export sip_redirect_context=context_2","application":"set hangup_after_bridge=true","application":"export ecallmgr_Inception=${ecallmgr_Inception}","application":"export ecallmgr_Call-Interaction-ID=${ecallmgr_Call-Interaction-ID}","application":"bridge {call_timeout=20,originate_timeout=20,outbound_redirect_fatal='false',bridge_export_vars='hold_music',local_var_clobber='true'}[^^!ecallmgr_Username='user_42HqcPrjCA'!ecallmgr_Realm='4f5549.sip.2600hz.com'!presence_id='1001@4f5549.sip.2600hz.com'!origination_callee_id_number='1001'!origination_callee_id_name='Alan Evans2'!ignore_completed_elsewhere='false'!leg_timeout='20'!sip_h_X-KAZOO-AOR='sip:user_42HqcPrjCA@4f5549.sip.2600hz.com'!sip_h_X-KAZOO-INVITE-FORMAT='contact'!ecallmgr_Authorizing-ID='9cabbb2ac44fbb1638218cbe47c83379'!ecallmgr_Authorizing-Type='device'!ecallmgr_Owner-ID='b96758fb45467d8555f42735cc5b39b3'!ecallmgr_Account-ID='47459457c634aff90b96f6af8a8eebb6'!sdp_secure_savp_only='false'!sip_invite_domain='4f5549.sip.2600hz.com'!absolute_codec_string='^^:PCMA:PCMU'!effective_callee_id_number='1001'!effective_callee_id_name='Alan Evans2']sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com;fs_path=sip:10.1.1.14:5060","application":"event Event-Name=CUSTOM,Event-Subclass=kazoo::masquerade,kazoo_event_name=CHANNEL_EXECUTE_COMPLETE,kazoo_application_name=bridge","application":"park "},"UUID":"66717c2c66232d6e","Msg-ID":"8ca1e4dde4d604a9","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.582.0>-2f926212","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"8ca1e4dde4d604a9","Event-Name":"sendmsg_req","Event-Category":"sendmsg","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.965+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60062 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"KAZOO.command.sendmsg">>]
Queue:        freeswitch.commands
Properties:   [{<<"timestamp">>,signedint,63910205441961103},
               {<<"reply_to">>,longstr,
                <<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.582.0>-2f926212">>},
               {<<"correlation_id">>,longstr,<<"8ca1e4dde4d604a9">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","FSHeaders":{"call-command":"xferext","application":"set continue_on_fail=true","application":"export sip_redirect_context=context_2","application":"set hangup_after_bridge=true","application":"export ecallmgr_Inception=${ecallmgr_Inception}","application":"export ecallmgr_Call-Interaction-ID=${ecallmgr_Call-Interaction-ID}","application":"bridge {call_timeout=20,originate_timeout=20,outbound_redirect_fatal='false',bridge_export_vars='hold_music',local_var_clobber='true'}[^^!ecallmgr_Username='user_42HqcPrjCA'!ecallmgr_Realm='4f5549.sip.2600hz.com'!presence_id='1001@4f5549.sip.2600hz.com'!origination_callee_id_number='1001'!origination_callee_id_name='Alan Evans2'!ignore_completed_elsewhere='false'!leg_timeout='20'!sip_h_X-KAZOO-AOR='sip:user_42HqcPrjCA@4f5549.sip.2600hz.com'!sip_h_X-KAZOO-INVITE-FORMAT='contact'!ecallmgr_Authorizing-ID='9cabbb2ac44fbb1638218cbe47c83379'!ecallmgr_Authorizing-Type='device'!ecallmgr_Owner-ID='b96758fb45467d8555f42735cc5b39b3'!ecallmgr_Account-ID='47459457c634aff90b96f6af8a8eebb6'!sdp_secure_savp_only='false'!sip_invite_domain='4f5549.sip.2600hz.com'!absolute_codec_string='^^:PCMA:PCMU'!effective_callee_id_number='1001'!effective_callee_id_name='Alan Evans2']sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com;fs_path=sip:10.1.1.14:5060","application":"event Event-Name=CUSTOM,Event-Subclass=kazoo::masquerade,kazoo_event_name=CHANNEL_EXECUTE_COMPLETE,kazoo_application_name=bridge","application":"park "},"UUID":"66717c2c66232d6e","Msg-ID":"8ca1e4dde4d604a9","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.582.0>-2f926212","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"8ca1e4dde4d604a9","Event-Name":"sendmsg_req","Event-Category":"sendmsg","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.965+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60062 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.582.0>-2f926212">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.582.0>-2f926212">>]
Properties:   [{<<"correlation_id">>,longstr,<<"8ca1e4dde4d604a9">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"response":"ok","App-Name":"mod_amqp","App-Version":"0.0.1","Event-Name":"command_response","Event-Category":"api","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Msg-ID":"8ca1e4dde4d604a9"}

================================================================================
2025-03-26T10:50:41.966+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      80
Exchange:     
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.582.0>-2f926212">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.582.0>-2f926212
Properties:   [{<<"correlation_id">>,longstr,<<"8ca1e4dde4d604a9">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"response":"ok","App-Name":"mod_amqp","App-Version":"0.0.1","Event-Name":"command_response","Event-Category":"api","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Msg-ID":"8ca1e4dde4d604a9"}

================================================================================
2025-03-26T10:50:41.971+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60048 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"FreeSWITCH.debian12-kazoo.CHANNEL_CREATE.338d3557-e3b7-4bd2-b253-81c905d474cd">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_fs_amqp_listener-<0.1619.0>-00a71b61">>]
Properties:   [{<<"timestamp">>,signedint,1742986241},
               {<<"headers">>,table,
                [{<<"x_Liquid_MessageSentTimeStamp">>,timestamp,1742986241}]},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Event-Name":"CHANNEL_CREATE","Core-UUID":"917c114b-eaf1-40f2-8407-4d2cd97687a1","FreeSWITCH-Hostname":"debian12-kazoo","FreeSWITCH-Switchname":"debian12-kazoo","FreeSWITCH-IPv4":"10.1.1.14","FreeSWITCH-IPv6":"::1","Event-Date-Local":"2025-03-26 10:50:41","Event-Date-GMT":"Wed, 26 Mar 2025 10:50:41 GMT","Event-Date-Timestamp":"1742986241967237","Event-Calling-File":"switch_core_state_machine.c","Event-Calling-Function":"switch_core_session_run","Event-Calling-Line-Number":"626","Event-Sequence":"739","Channel-State":"CS_INIT","Channel-Call-State":"DOWN","Channel-State-Number":"2","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Unique-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Call-Direction":"outbound","Presence-Call-Direction":"outbound","Channel-HIT-Dialplan":"false","Channel-Presence-ID":"1001@4f5549.sip.2600hz.com","Channel-Call-UUID":"66717c2c66232d6e","Answer-State":"ringing","Caller-Direction":"outbound","Caller-Logical-Direction":"outbound","Caller-Username":"user_p48egZdPh4","Caller-Dialplan":"XML","Caller-Caller-ID-Name":"Alan Evans","Caller-Caller-ID-Number":"1000","Caller-Orig-Caller-ID-Name":"user_p48egZdPh4","Caller-Orig-Caller-ID-Number":"user_p48egZdPh4","Caller-Callee-ID-Name":"Alan Evans2","Caller-Callee-ID-Number":"1001","Caller-Network-Addr":"10.1.1.14","Caller-ANI":"user_p48egZdPh4","Caller-Destination-Number":"user_42HqcPrjCA","Caller-Unique-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Caller-Source":"mod_sofia","Caller-Context":"context_2","Caller-Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Caller-Profile-Index":"1","Caller-Profile-Created-Time":"1742986241947047","Caller-Channel-Created-Time":"1742986241947047","Caller-Channel-Answered-Time":"0","Caller-Channel-Progress-Time":"0","Caller-Channel-Progress-Media-Time":"0","Caller-Channel-Hangup-Time":"0","Caller-Channel-Transfer-Time":"0","Caller-Channel-Resurrect-Time":"0","Caller-Channel-Bridged-Time":"0","Caller-Channel-Last-Hold":"0","Caller-Channel-Hold-Accum":"0","Caller-Screen-Bit":"true","Caller-Privacy-Hide-Name":"false","Caller-Privacy-Hide-Number":"false","Other-Type":"originator","Other-Leg-Direction":"inbound","Other-Leg-Logical-Direction":"inbound","Other-Leg-Username":"user_p48egZdPh4","Other-Leg-Dialplan":"XML","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Orig-Caller-ID-Name":"user_p48egZdPh4","Other-Leg-Orig-Caller-ID-Number":"user_p48egZdPh4","Other-Leg-Network-Addr":"10.1.1.14","Other-Leg-ANI":"user_p48egZdPh4","Other-Leg-Destination-Number":"1001","Other-Leg-Unique-ID":"66717c2c66232d6e","Other-Leg-Source":"mod_sofia","Other-Leg-Context":"context_2","Other-Leg-Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Other-Leg-Profile-Created-Time":"0","Other-Leg-Channel-Created-Time":"0","Other-Leg-Channel-Answered-Time":"0","Other-Leg-Channel-Progress-Time":"0","Other-Leg-Channel-Progress-Media-Time":"0","Other-Leg-Channel-Hangup-Time":"0","Other-Leg-Channel-Transfer-Time":"0","Other-Leg-Channel-Resurrect-Time":"0","Other-Leg-Channel-Bridged-Time":"0","Other-Leg-Channel-Last-Hold":"0","Other-Leg-Channel-Hold-Accum":"0","Other-Leg-Screen-Bit":"true","Other-Leg-Privacy-Hide-Name":"false","Other-Leg-Privacy-Hide-Number":"false","variable_direction":"outbound","variable_is_outbound":"true","variable_uuid":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_session_id":"4","variable_sip_local_network_addr":"10.1.1.14","variable_sip_profile_name":"sipinterface_1","variable_text_media_flow":"disabled","variable_channel_name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sip_destination_url":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com;fs_path=sip:10.1.1.14:5060","variable_max_forwards":"49","variable_originator_codec":"CORE_PCM_MODULE.PCMU@8000h@20i@64000b,CORE_PCM_MODULE.PCMA@8000h@20i@64000b","variable_originator":"66717c2c66232d6e","variable_signal_bond":"66717c2c66232d6e","variable_switch_m_sdp":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_call_uuid":"66717c2c66232d6e","variable_export_vars":"ecallmgr_Bridge-ID,ecallmgr_Ecallmgr-Node,ringback,transfer_ringback,sip_redirect_context,ecallmgr_Call-Interaction-ID","variable_ecallmgr_Bridge-ID":"66717c2c66232d6e","variable_ecallmgr_Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","variable_ringback":"%(2000,4000,440,480)","variable_transfer_ringback":"%(2000,4000,440,480)","variable_sip_redirect_context":"context_2","variable_ecallmgr_Call-Interaction-ID":"63910205441-db5e04cf","variable_call_timeout":"20","variable_originate_timeout":"20","variable_outbound_redirect_fatal":"false","variable_bridge_export_vars":"hold_music","variable_local_var_clobber":"true","variable_originate_early_media":"true","variable_ecallmgr_Username":"user_42HqcPrjCA","variable_ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_presence_id":"1001@4f5549.sip.2600hz.com","variable_origination_callee_id_number":"1001","variable_origination_callee_id_name":"Alan Evans2","variable_ignore_completed_elsewhere":"false","variable_leg_timeout":"20","variable_sip_h_X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sip_h_X-KAZOO-INVITE-FORMAT":"contact","variable_ecallmgr_Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","variable_ecallmgr_Authorizing-Type":"device","variable_ecallmgr_Owner-ID":"b96758fb45467d8555f42735cc5b39b3","variable_ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_sdp_secure_savp_only":"false","variable_sip_invite_domain":"4f5549.sip.2600hz.com","variable_absolute_codec_string":"^^:PCMA:PCMU","variable_effective_callee_id_number":"1001","variable_effective_callee_id_name":"Alan Evans2","variable_originating_leg_uuid":"66717c2c66232d6e","variable_originate_endpoint":"sofia","variable_rtp_use_codec_string":"^^:PCMA:PCMU","variable_local_media_ip":"10.1.1.14","variable_local_media_port":"27018","variable_advertised_media_ip":"10.1.1.14","variable_audio_media_flow":"sendrecv","variable_video_media_flow":"sendrecv","variable_rtp_local_sdp_str":"v=0\r\no=FreeSWITCH 1742959223 1742959224 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 27018 RTP/AVP 8 0 101 13\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=rtpmap:13 CN/8000\r\na=ptime:20\r\na=sendrecv\r\n","variable_sip_outgoing_contact_uri":"<sip:mod_sofia@10.1.1.14:11000>","variable_sip_req_uri":"user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sip_to_host":"4f5549.sip.2600hz.com","variable_sip_from_host":"4f5549.sip.2600hz.com","variable_sofia_profile_name":"sipinterface_1","variable_recovery_profile_name":"sipinterface_1","variable_sofia_profile_url":"sip:mod_sofia@10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com"}

================================================================================
2025-03-26T10:50:41.971+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      175
Exchange:     freeswitch
Routing keys: [<<"FreeSWITCH.debian12-kazoo.CHANNEL_CREATE.338d3557-e3b7-4bd2-b253-81c905d474cd">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_fs_amqp_listener-<0.1619.0>-00a71b61
Properties:   [{<<"timestamp">>,signedint,1742986241},
               {<<"headers">>,table,
                [{<<"x_Liquid_MessageSentTimeStamp">>,timestamp,1742986241}]},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Event-Name":"CHANNEL_CREATE","Core-UUID":"917c114b-eaf1-40f2-8407-4d2cd97687a1","FreeSWITCH-Hostname":"debian12-kazoo","FreeSWITCH-Switchname":"debian12-kazoo","FreeSWITCH-IPv4":"10.1.1.14","FreeSWITCH-IPv6":"::1","Event-Date-Local":"2025-03-26 10:50:41","Event-Date-GMT":"Wed, 26 Mar 2025 10:50:41 GMT","Event-Date-Timestamp":"1742986241967237","Event-Calling-File":"switch_core_state_machine.c","Event-Calling-Function":"switch_core_session_run","Event-Calling-Line-Number":"626","Event-Sequence":"739","Channel-State":"CS_INIT","Channel-Call-State":"DOWN","Channel-State-Number":"2","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Unique-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Call-Direction":"outbound","Presence-Call-Direction":"outbound","Channel-HIT-Dialplan":"false","Channel-Presence-ID":"1001@4f5549.sip.2600hz.com","Channel-Call-UUID":"66717c2c66232d6e","Answer-State":"ringing","Caller-Direction":"outbound","Caller-Logical-Direction":"outbound","Caller-Username":"user_p48egZdPh4","Caller-Dialplan":"XML","Caller-Caller-ID-Name":"Alan Evans","Caller-Caller-ID-Number":"1000","Caller-Orig-Caller-ID-Name":"user_p48egZdPh4","Caller-Orig-Caller-ID-Number":"user_p48egZdPh4","Caller-Callee-ID-Name":"Alan Evans2","Caller-Callee-ID-Number":"1001","Caller-Network-Addr":"10.1.1.14","Caller-ANI":"user_p48egZdPh4","Caller-Destination-Number":"user_42HqcPrjCA","Caller-Unique-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Caller-Source":"mod_sofia","Caller-Context":"context_2","Caller-Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Caller-Profile-Index":"1","Caller-Profile-Created-Time":"1742986241947047","Caller-Channel-Created-Time":"1742986241947047","Caller-Channel-Answered-Time":"0","Caller-Channel-Progress-Time":"0","Caller-Channel-Progress-Media-Time":"0","Caller-Channel-Hangup-Time":"0","Caller-Channel-Transfer-Time":"0","Caller-Channel-Resurrect-Time":"0","Caller-Channel-Bridged-Time":"0","Caller-Channel-Last-Hold":"0","Caller-Channel-Hold-Accum":"0","Caller-Screen-Bit":"true","Caller-Privacy-Hide-Name":"false","Caller-Privacy-Hide-Number":"false","Other-Type":"originator","Other-Leg-Direction":"inbound","Other-Leg-Logical-Direction":"inbound","Other-Leg-Username":"user_p48egZdPh4","Other-Leg-Dialplan":"XML","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Orig-Caller-ID-Name":"user_p48egZdPh4","Other-Leg-Orig-Caller-ID-Number":"user_p48egZdPh4","Other-Leg-Network-Addr":"10.1.1.14","Other-Leg-ANI":"user_p48egZdPh4","Other-Leg-Destination-Number":"1001","Other-Leg-Unique-ID":"66717c2c66232d6e","Other-Leg-Source":"mod_sofia","Other-Leg-Context":"context_2","Other-Leg-Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Other-Leg-Profile-Created-Time":"0","Other-Leg-Channel-Created-Time":"0","Other-Leg-Channel-Answered-Time":"0","Other-Leg-Channel-Progress-Time":"0","Other-Leg-Channel-Progress-Media-Time":"0","Other-Leg-Channel-Hangup-Time":"0","Other-Leg-Channel-Transfer-Time":"0","Other-Leg-Channel-Resurrect-Time":"0","Other-Leg-Channel-Bridged-Time":"0","Other-Leg-Channel-Last-Hold":"0","Other-Leg-Channel-Hold-Accum":"0","Other-Leg-Screen-Bit":"true","Other-Leg-Privacy-Hide-Name":"false","Other-Leg-Privacy-Hide-Number":"false","variable_direction":"outbound","variable_is_outbound":"true","variable_uuid":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_session_id":"4","variable_sip_local_network_addr":"10.1.1.14","variable_sip_profile_name":"sipinterface_1","variable_text_media_flow":"disabled","variable_channel_name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sip_destination_url":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com;fs_path=sip:10.1.1.14:5060","variable_max_forwards":"49","variable_originator_codec":"CORE_PCM_MODULE.PCMU@8000h@20i@64000b,CORE_PCM_MODULE.PCMA@8000h@20i@64000b","variable_originator":"66717c2c66232d6e","variable_signal_bond":"66717c2c66232d6e","variable_switch_m_sdp":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_call_uuid":"66717c2c66232d6e","variable_export_vars":"ecallmgr_Bridge-ID,ecallmgr_Ecallmgr-Node,ringback,transfer_ringback,sip_redirect_context,ecallmgr_Call-Interaction-ID","variable_ecallmgr_Bridge-ID":"66717c2c66232d6e","variable_ecallmgr_Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","variable_ringback":"%(2000,4000,440,480)","variable_transfer_ringback":"%(2000,4000,440,480)","variable_sip_redirect_context":"context_2","variable_ecallmgr_Call-Interaction-ID":"63910205441-db5e04cf","variable_call_timeout":"20","variable_originate_timeout":"20","variable_outbound_redirect_fatal":"false","variable_bridge_export_vars":"hold_music","variable_local_var_clobber":"true","variable_originate_early_media":"true","variable_ecallmgr_Username":"user_42HqcPrjCA","variable_ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_presence_id":"1001@4f5549.sip.2600hz.com","variable_origination_callee_id_number":"1001","variable_origination_callee_id_name":"Alan Evans2","variable_ignore_completed_elsewhere":"false","variable_leg_timeout":"20","variable_sip_h_X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sip_h_X-KAZOO-INVITE-FORMAT":"contact","variable_ecallmgr_Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","variable_ecallmgr_Authorizing-Type":"device","variable_ecallmgr_Owner-ID":"b96758fb45467d8555f42735cc5b39b3","variable_ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_sdp_secure_savp_only":"false","variable_sip_invite_domain":"4f5549.sip.2600hz.com","variable_absolute_codec_string":"^^:PCMA:PCMU","variable_effective_callee_id_number":"1001","variable_effective_callee_id_name":"Alan Evans2","variable_originating_leg_uuid":"66717c2c66232d6e","variable_originate_endpoint":"sofia","variable_rtp_use_codec_string":"^^:PCMA:PCMU","variable_local_media_ip":"10.1.1.14","variable_local_media_port":"27018","variable_advertised_media_ip":"10.1.1.14","variable_audio_media_flow":"sendrecv","variable_video_media_flow":"sendrecv","variable_rtp_local_sdp_str":"v=0\r\no=FreeSWITCH 1742959223 1742959224 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 27018 RTP/AVP 8 0 101 13\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=rtpmap:13 CN/8000\r\na=ptime:20\r\na=sendrecv\r\n","variable_sip_outgoing_contact_uri":"<sip:mod_sofia@10.1.1.14:11000>","variable_sip_req_uri":"user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sip_to_host":"4f5549.sip.2600hz.com","variable_sip_from_host":"4f5549.sip.2600hz.com","variable_sofia_profile_name":"sipinterface_1","variable_recovery_profile_name":"sipinterface_1","variable_sofia_profile_url":"sip:mod_sofia@10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com"}

================================================================================
2025-03-26T10:50:41.976+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      78
Exchange:     callevt
Routing keys: [<<"call.LEG_CREATED.66717c2c66232d6e">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33">>]
Properties:   [{<<"timestamp">>,signedint,63910205441975138},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Timestamp":63910205441,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Presence-ID":"1001@4f5549.sip.2600hz.com","Other-Leg-Direction":"outbound","Other-Leg-Destination-Number":"user_42HqcPrjCA","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Media-Server":"debian12-kazoo","Custom-SIP-Headers":{"X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com","X-KAZOO-INVITE-FORMAT":"contact"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Realm":"4f5549.sip.2600hz.com","Username":"user_42HqcPrjCA"},"Custom-Application-Vars":{},"Channel-State":"INIT","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Channel-Created-Time":0,"Channel-Call-State":"DOWN","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"outbound","Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986241967237","Event-Name":"LEG_CREATED","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.977+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      229
Exchange:     callevt
Routing keys: [<<"call.LEG_CREATED.66717c2c66232d6e">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33
Properties:   [{<<"timestamp">>,signedint,63910205441975138},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Timestamp":63910205441,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Presence-ID":"1001@4f5549.sip.2600hz.com","Other-Leg-Direction":"outbound","Other-Leg-Destination-Number":"user_42HqcPrjCA","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Media-Server":"debian12-kazoo","Custom-SIP-Headers":{"X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com","X-KAZOO-INVITE-FORMAT":"contact"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Realm":"4f5549.sip.2600hz.com","Username":"user_42HqcPrjCA"},"Custom-Application-Vars":{},"Channel-State":"INIT","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Channel-Created-Time":0,"Channel-Call-State":"DOWN","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"outbound","Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986241967237","Event-Name":"LEG_CREATED","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.980+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      77
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_CREATE.338d3557-e3b7-4bd2-b253-81c905d474cd">>]
Routed queues: [<<"webhooks_shared_listener">>]
Properties:   [{<<"timestamp">>,signedint,63910205441977775},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205441,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Request":"user_42HqcPrjCA@4f5549.sip.2600hz.com","Presence-ID":"1001@4f5549.sip.2600hz.com","Other-Leg-Direction":"inbound","Other-Leg-Destination-Number":"1001","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"66717c2c66232d6e","Media-Server":"debian12-kazoo","From":"1000@4f5549.sip.2600hz.com","Custom-SIP-Headers":{"X-KAZOO-INVITE-FORMAT":"contact","X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Realm":"4f5549.sip.2600hz.com","Username":"user_42HqcPrjCA"},"Custom-Application-Vars":{},"Channel-State":"INIT","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241947047,"Channel-Call-State":"DOWN","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"outbound","Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986241967237","Event-Name":"CHANNEL_CREATE","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.980+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      223
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_CREATE.338d3557-e3b7-4bd2-b253-81c905d474cd">>]
Queue:        webhooks_shared_listener
Properties:   [{<<"timestamp">>,signedint,63910205441977775},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205441,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Request":"user_42HqcPrjCA@4f5549.sip.2600hz.com","Presence-ID":"1001@4f5549.sip.2600hz.com","Other-Leg-Direction":"inbound","Other-Leg-Destination-Number":"1001","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"66717c2c66232d6e","Media-Server":"debian12-kazoo","From":"1000@4f5549.sip.2600hz.com","Custom-SIP-Headers":{"X-KAZOO-INVITE-FORMAT":"contact","X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Realm":"4f5549.sip.2600hz.com","Username":"user_42HqcPrjCA"},"Custom-Application-Vars":{},"Channel-State":"INIT","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241947047,"Channel-Call-State":"DOWN","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"outbound","Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986241967237","Event-Name":"CHANNEL_CREATE","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.984+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      76
Exchange:     freeswitch
Routing keys: [<<"KAZOO.command.api">>]
Routed queues: [<<"freeswitch.commands">>]
Properties:   [{<<"timestamp">>,signedint,63910205441982558},
               {<<"reply_to">>,longstr,
                <<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.575.0>-0d783513">>},
               {<<"correlation_id">>,longstr,<<"3d3a4597cc61be4d">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"args":"338d3557-e3b7-4bd2-b253-81c905d474cd ^^~ecallmgr_Account-ID=47459457c634aff90b96f6af8a8eebb6~ecallmgr_Global-Resource=false~ecallmgr_Channel-Authorized=true","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","command":"kz_uuid_setvar_multi","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.575.0>-0d783513","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"3d3a4597cc61be4d","Msg-ID":"3d3a4597cc61be4d","Event-Name":"api_req","Event-Category":"api","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.985+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60062 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"KAZOO.command.api">>]
Queue:        freeswitch.commands
Properties:   [{<<"timestamp">>,signedint,63910205441982558},
               {<<"reply_to">>,longstr,
                <<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.575.0>-0d783513">>},
               {<<"correlation_id">>,longstr,<<"3d3a4597cc61be4d">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"args":"338d3557-e3b7-4bd2-b253-81c905d474cd ^^~ecallmgr_Account-ID=47459457c634aff90b96f6af8a8eebb6~ecallmgr_Global-Resource=false~ecallmgr_Channel-Authorized=true","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","command":"kz_uuid_setvar_multi","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.575.0>-0d783513","Node":"kazoo_apps@debian12-kazoo.kageds.com","System-Log-ID":"3d3a4597cc61be4d","Msg-ID":"3d3a4597cc61be4d","Event-Name":"api_req","Event-Category":"api","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:41.986+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60062 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.575.0>-0d783513">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.575.0>-0d783513">>]
Properties:   [{<<"correlation_id">>,longstr,<<"3d3a4597cc61be4d">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"response":"+OK\n","App-Name":"mod_amqp","App-Version":"0.0.1","Event-Name":"command_response","Event-Category":"api","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Msg-ID":"3d3a4597cc61be4d"}

================================================================================
2025-03-26T10:50:41.987+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      76
Exchange:     
Routing keys: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.575.0>-0d783513">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-kz_amqp_worker-<0.575.0>-0d783513
Properties:   [{<<"correlation_id">>,longstr,<<"3d3a4597cc61be4d">>},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"response":"+OK\n","App-Name":"mod_amqp","App-Version":"0.0.1","Event-Name":"command_response","Event-Category":"api","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Msg-ID":"3d3a4597cc61be4d"}

================================================================================
2025-03-26T10:50:44.535+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:60262 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      18
Exchange:     nodes
Routing keys: [<<>>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-kz_nodes-<0.1256.0>-fde31d39">>,
                <<"nodes-debian12-kazoo.kageds.com">>]
Properties:   [{<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{ "Event-Category": "nodes", "Event-Name": "advertise", "Expires": 15000, "Used-Memory": 14693384, "Startup": 1742900930, "WhApps": { "kamailio": { "Startup": 1742900930 } }, "Roles": { "Proxy": { "Listeners": { "udp:10.1.1.14:5060": { "proto": "udp", "address": "10.1.1.14", "port": 5060 }, "udp:10.1.1.14:7000": { "proto": "udp", "address": "10.1.1.14", "port": 7000 }, "tcp:10.1.1.14:5060": { "proto": "tcp", "address": "10.1.1.14", "port": 5060 }, "tcp:10.1.1.14:7000": { "proto": "tcp", "address": "10.1.1.14", "port": 7000 } } }, "Dispatcher": { "Groups": { "2": { "sip:10.0.0.4:11000": { "destination": "sip:10.0.0.4:11000", "flags": "IP", "priority": 0, "attrs": "" } }, "1": { "sip:10.1.1.14:11000": { "destination": "sip:10.1.1.14:11000", "flags": "AP", "priority": 0, "attrs": "" }, "sip:20.108.67.20:11000": { "destination": "sip:20.108.67.20:11000", "flags": "IP", "priority": 0, "attrs": "" } } } }, "Presence": { "Subscribers": { "dialog": 2 }, "Subscriptions": { "dialog": 4 }, "Presentities": { "message-summary": 0, "dialog": 0, "presence": 0 } }, "Registrar": { "Registrations": 2 } }, "App-Name": "kamailio", "App-Version": "5.6.3", "Node": "kamailio@debian12-kazoo.kageds.com", "Msg-ID": "6c51c3ba-92b0-44ba-88dc-27f17d7e0792", "Server-ID": "kamailio@debian12-kazoo.kageds.com-<1>-targeted-17" }

================================================================================
2025-03-26T10:50:44.536+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:60244 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      29
Exchange:     nodes
Routing keys: [<<>>]
Queue:        nodes-debian12-kazoo.kageds.com
Properties:   [{<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{ "Event-Category": "nodes", "Event-Name": "advertise", "Expires": 15000, "Used-Memory": 14693384, "Startup": 1742900930, "WhApps": { "kamailio": { "Startup": 1742900930 } }, "Roles": { "Proxy": { "Listeners": { "udp:10.1.1.14:5060": { "proto": "udp", "address": "10.1.1.14", "port": 5060 }, "udp:10.1.1.14:7000": { "proto": "udp", "address": "10.1.1.14", "port": 7000 }, "tcp:10.1.1.14:5060": { "proto": "tcp", "address": "10.1.1.14", "port": 5060 }, "tcp:10.1.1.14:7000": { "proto": "tcp", "address": "10.1.1.14", "port": 7000 } } }, "Dispatcher": { "Groups": { "2": { "sip:10.0.0.4:11000": { "destination": "sip:10.0.0.4:11000", "flags": "IP", "priority": 0, "attrs": "" } }, "1": { "sip:10.1.1.14:11000": { "destination": "sip:10.1.1.14:11000", "flags": "AP", "priority": 0, "attrs": "" }, "sip:20.108.67.20:11000": { "destination": "sip:20.108.67.20:11000", "flags": "IP", "priority": 0, "attrs": "" } } } }, "Presence": { "Subscribers": { "dialog": 2 }, "Subscriptions": { "dialog": 4 }, "Presentities": { "message-summary": 0, "dialog": 0, "presence": 0 } }, "Registrar": { "Registrations": 2 } }, "App-Name": "kamailio", "App-Version": "5.6.3", "Node": "kamailio@debian12-kazoo.kageds.com", "Msg-ID": "6c51c3ba-92b0-44ba-88dc-27f17d7e0792", "Server-ID": "kamailio@debian12-kazoo.kageds.com-<1>-targeted-17" }

================================================================================
2025-03-26T10:50:44.536+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      153
Exchange:     nodes
Routing keys: [<<>>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-kz_nodes-<0.1256.0>-fde31d39
Properties:   [{<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{ "Event-Category": "nodes", "Event-Name": "advertise", "Expires": 15000, "Used-Memory": 14693384, "Startup": 1742900930, "WhApps": { "kamailio": { "Startup": 1742900930 } }, "Roles": { "Proxy": { "Listeners": { "udp:10.1.1.14:5060": { "proto": "udp", "address": "10.1.1.14", "port": 5060 }, "udp:10.1.1.14:7000": { "proto": "udp", "address": "10.1.1.14", "port": 7000 }, "tcp:10.1.1.14:5060": { "proto": "tcp", "address": "10.1.1.14", "port": 5060 }, "tcp:10.1.1.14:7000": { "proto": "tcp", "address": "10.1.1.14", "port": 7000 } } }, "Dispatcher": { "Groups": { "2": { "sip:10.0.0.4:11000": { "destination": "sip:10.0.0.4:11000", "flags": "IP", "priority": 0, "attrs": "" } }, "1": { "sip:10.1.1.14:11000": { "destination": "sip:10.1.1.14:11000", "flags": "AP", "priority": 0, "attrs": "" }, "sip:20.108.67.20:11000": { "destination": "sip:20.108.67.20:11000", "flags": "IP", "priority": 0, "attrs": "" } } } }, "Presence": { "Subscribers": { "dialog": 2 }, "Subscriptions": { "dialog": 4 }, "Presentities": { "message-summary": 0, "dialog": 0, "presence": 0 } }, "Registrar": { "Registrations": 2 } }, "App-Name": "kamailio", "App-Version": "5.6.3", "Node": "kamailio@debian12-kazoo.kageds.com", "Msg-ID": "6c51c3ba-92b0-44ba-88dc-27f17d7e0792", "Server-ID": "kamailio@debian12-kazoo.kageds.com-<1>-targeted-17" }

================================================================================
2025-03-26T10:50:46.701+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60048 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"FreeSWITCH.debian12-kazoo.CHANNEL_DESTROY.338d3557-e3b7-4bd2-b253-81c905d474cd">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_fs_amqp_listener-<0.1619.0>-00a71b61">>]
Properties:   [{<<"timestamp">>,signedint,1742986246},
               {<<"headers">>,table,
                [{<<"x_Liquid_MessageSentTimeStamp">>,timestamp,1742986246}]},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Event-Name":"CHANNEL_DESTROY","Core-UUID":"917c114b-eaf1-40f2-8407-4d2cd97687a1","FreeSWITCH-Hostname":"debian12-kazoo","FreeSWITCH-Switchname":"debian12-kazoo","FreeSWITCH-IPv4":"10.1.1.14","FreeSWITCH-IPv6":"::1","Event-Date-Local":"2025-03-26 10:50:46","Event-Date-GMT":"Wed, 26 Mar 2025 10:50:46 GMT","Event-Date-Timestamp":"1742986246687088","Event-Calling-File":"switch_core_session.c","Event-Calling-Function":"switch_core_session_perform_destroy","Event-Calling-Line-Number":"1584","Event-Sequence":"778","Channel-State":"CS_REPORTING","Channel-Call-State":"HANGUP","Channel-State-Number":"12","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Unique-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Call-Direction":"outbound","Presence-Call-Direction":"outbound","Channel-HIT-Dialplan":"false","Channel-Presence-ID":"1001@4f5549.sip.2600hz.com","Channel-Call-UUID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Answer-State":"hangup","Hangup-Cause":"NORMAL_CLEARING","Channel-Read-Codec-Name":"PCMA","Channel-Read-Codec-Rate":"8000","Channel-Read-Codec-Bit-Rate":"64000","Channel-Write-Codec-Name":"PCMA","Channel-Write-Codec-Rate":"8000","Channel-Write-Codec-Bit-Rate":"64000","Caller-Direction":"outbound","Caller-Logical-Direction":"outbound","Caller-Username":"user_p48egZdPh4","Caller-Dialplan":"XML","Caller-Caller-ID-Name":"Alan Evans","Caller-Caller-ID-Number":"1000","Caller-Orig-Caller-ID-Name":"user_p48egZdPh4","Caller-Orig-Caller-ID-Number":"user_p48egZdPh4","Caller-Callee-ID-Name":"Alan Evans2","Caller-Callee-ID-Number":"1001","Caller-Network-Addr":"10.1.1.14","Caller-ANI":"user_p48egZdPh4","Caller-Destination-Number":"user_42HqcPrjCA","Caller-Unique-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Caller-Source":"mod_sofia","Caller-Context":"context_2","Caller-Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Caller-Profile-Index":"1","Caller-Profile-Created-Time":"1742986241947047","Caller-Channel-Created-Time":"1742986241947047","Caller-Channel-Answered-Time":"1742986243287232","Caller-Channel-Progress-Time":"1742986241987059","Caller-Channel-Progress-Media-Time":"0","Caller-Channel-Hangup-Time":"1742986246687088","Caller-Channel-Transfer-Time":"0","Caller-Channel-Resurrect-Time":"0","Caller-Channel-Bridged-Time":"1742986243287232","Caller-Channel-Last-Hold":"0","Caller-Channel-Hold-Accum":"0","Caller-Screen-Bit":"true","Caller-Privacy-Hide-Name":"false","Caller-Privacy-Hide-Number":"false","Other-Type":"originator","Other-Leg-Direction":"inbound","Other-Leg-Logical-Direction":"inbound","Other-Leg-Username":"user_p48egZdPh4","Other-Leg-Dialplan":"XML","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Orig-Caller-ID-Name":"user_p48egZdPh4","Other-Leg-Orig-Caller-ID-Number":"user_p48egZdPh4","Other-Leg-Network-Addr":"10.1.1.14","Other-Leg-ANI":"user_p48egZdPh4","Other-Leg-Destination-Number":"1001","Other-Leg-Unique-ID":"66717c2c66232d6e","Other-Leg-Source":"mod_sofia","Other-Leg-Context":"context_2","Other-Leg-Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Other-Leg-Profile-Created-Time":"0","Other-Leg-Channel-Created-Time":"0","Other-Leg-Channel-Answered-Time":"0","Other-Leg-Channel-Progress-Time":"1742986241987059","Other-Leg-Channel-Progress-Media-Time":"0","Other-Leg-Channel-Hangup-Time":"0","Other-Leg-Channel-Transfer-Time":"0","Other-Leg-Channel-Resurrect-Time":"0","Other-Leg-Channel-Bridged-Time":"0","Other-Leg-Channel-Last-Hold":"0","Other-Leg-Channel-Hold-Accum":"0","Other-Leg-Screen-Bit":"true","Other-Leg-Privacy-Hide-Name":"false","Other-Leg-Privacy-Hide-Number":"false","variable_direction":"outbound","variable_is_outbound":"true","variable_uuid":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_session_id":"4","variable_sip_profile_name":"sipinterface_1","variable_text_media_flow":"disabled","variable_channel_name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sip_destination_url":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com;fs_path=sip:10.1.1.14:5060","variable_max_forwards":"49","variable_originator_codec":"CORE_PCM_MODULE.PCMU@8000h@20i@64000b,CORE_PCM_MODULE.PCMA@8000h@20i@64000b","variable_originator":"66717c2c66232d6e","variable_switch_m_sdp":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_export_vars":"ecallmgr_Bridge-ID,ecallmgr_Ecallmgr-Node,ringback,transfer_ringback,sip_redirect_context,ecallmgr_Call-Interaction-ID","variable_ecallmgr_Bridge-ID":"66717c2c66232d6e","variable_ecallmgr_Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","variable_ringback":"%(2000,4000,440,480)","variable_transfer_ringback":"%(2000,4000,440,480)","variable_sip_redirect_context":"context_2","variable_ecallmgr_Call-Interaction-ID":"63910205441-db5e04cf","variable_call_timeout":"20","variable_originate_timeout":"20","variable_outbound_redirect_fatal":"false","variable_local_var_clobber":"true","variable_originate_early_media":"true","variable_ecallmgr_Username":"user_42HqcPrjCA","variable_ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_presence_id":"1001@4f5549.sip.2600hz.com","variable_origination_callee_id_number":"1001","variable_origination_callee_id_name":"Alan Evans2","variable_ignore_completed_elsewhere":"false","variable_leg_timeout":"20","variable_sip_h_X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sip_h_X-KAZOO-INVITE-FORMAT":"contact","variable_ecallmgr_Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","variable_ecallmgr_Authorizing-Type":"device","variable_ecallmgr_Owner-ID":"b96758fb45467d8555f42735cc5b39b3","variable_sdp_secure_savp_only":"false","variable_sip_invite_domain":"4f5549.sip.2600hz.com","variable_absolute_codec_string":"^^:PCMA:PCMU","variable_effective_callee_id_number":"1001","variable_effective_callee_id_name":"Alan Evans2","variable_originating_leg_uuid":"66717c2c66232d6e","variable_originate_endpoint":"sofia","variable_audio_media_flow":"sendrecv","variable_video_media_flow":"sendrecv","variable_rtp_local_sdp_str":"v=0\r\no=FreeSWITCH 1742959223 1742959224 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 27018 RTP/AVP 8 0 101 13\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=rtpmap:13 CN/8000\r\na=ptime:20\r\na=sendrecv\r\n","variable_sip_outgoing_contact_uri":"<sip:mod_sofia@10.1.1.14:11000>","variable_sip_req_uri":"user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sofia_profile_name":"sipinterface_1","variable_recovery_profile_name":"sipinterface_1","variable_sofia_profile_url":"sip:mod_sofia@10.1.1.14:11000","variable_ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_ecallmgr_Global-Resource":"false","variable_ecallmgr_Channel-Authorized":"true","variable_sip_local_network_addr":"10.1.1.14","variable_sip_reply_host":"10.1.1.14","variable_sip_reply_port":"5060","variable_sip_network_ip":"10.1.1.14","variable_sip_network_port":"5060","variable_sip_allow":"INVITE, ACK, BYE, CANCEL, OPTIONS, REFER, NOTIFY, SUBSCRIBE, INFO","variable_sip_recover_contact":"<sip:user_42HqcPrjCA@10.1.1.31:61179;alias=10.1.1.31~61179~1>","variable_sip_invite_route_uri":"<sip:10.1.1.14;lr=on;ftag=cggBg8BSt2Qvj>","variable_sip_invite_record_route":"<sip:10.1.1.14;lr=on;ftag=cggBg8BSt2Qvj>","variable_sip_full_via":"SIP/2.0/UDP 10.1.1.14:11000;received=10.1.1.14;rport=11000;branch=z9hG4bKS1ec6FQtKFFpK","variable_sip_recover_via":"SIP/2.0/UDP 10.1.1.14:11000;received=10.1.1.14;rport=11000;branch=z9hG4bKS1ec6FQtKFFpK","variable_sip_from_display":"Alan Evans","variable_sip_full_from":"\"Alan Evans\" <sip:1000@4f5549.sip.2600hz.com>;tag=cggBg8BSt2Qvj","variable_sip_full_to":"<sip:user_42HqcPrjCA@4f5549.sip.2600hz.com>;tag=09ca759f6a08420a","variable_sip_from_user":"1000","variable_sip_from_uri":"1000@4f5549.sip.2600hz.com","variable_sip_from_host":"4f5549.sip.2600hz.com","variable_sip_to_user":"user_42HqcPrjCA","variable_sip_to_uri":"user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sip_to_host":"4f5549.sip.2600hz.com","variable_sip_contact_params":"alias=10.1.1.31~61179~1","variable_sip_contact_user":"user_42HqcPrjCA","variable_sip_contact_port":"61179","variable_sip_contact_uri":"user_42HqcPrjCA@10.1.1.31:61179","variable_sip_contact_host":"10.1.1.31","variable_sip_to_tag":"09ca759f6a08420a","variable_sip_from_tag":"cggBg8BSt2Qvj","variable_sip_cseq":"96939328","variable_sip_call_id":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_switch_r_sdp":"v=0\r\no=- 1263800803 855048506 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 14540 RTP/AVP 8 0 101\r\nb=AS:125\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_ep_codec_string":"CORE_PCM_MODULE.PCMA@8000h@20i@64000b,CORE_PCM_MODULE.PCMU@8000h@20i@64000b","variable_rtp_use_codec_string":"^^:PCMA:PCMU","variable_remote_video_media_flow":"inactive","variable_remote_text_media_flow":"inactive","variable_remote_audio_media_flow":"sendrecv","variable_rtp_audio_recv_pt":"8","variable_rtp_use_codec_name":"PCMA","variable_rtp_use_codec_rate":"8000","variable_rtp_use_codec_ptime":"20","variable_rtp_use_codec_channels":"1","variable_rtp_last_audio_codec_string":"PCMA@8000h@20i@1c","variable_read_codec":"PCMA","variable_original_read_codec":"PCMA","variable_read_rate":"8000","variable_original_read_rate":"8000","variable_write_codec":"PCMA","variable_write_rate":"8000","variable_dtmf_type":"rfc2833","variable_local_media_ip":"10.1.1.14","variable_local_media_port":"27018","variable_advertised_media_ip":"10.1.1.14","variable_rtp_use_timer_name":"soft","variable_rtp_use_pt":"8","variable_rtp_use_ssrc":"1206307353","variable_rtp_2833_send_payload":"101","variable_rtp_2833_recv_payload":"101","variable_remote_media_ip":"10.1.1.31","variable_remote_media_port":"14540","variable_endpoint_disposition":"ANSWER","variable_bridge_export_vars":"hold_music","variable_hold_music":"local_stream://default","variable_last_bridge_to":"66717c2c66232d6e","variable_bridge_channel":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","variable_bridge_uuid":"66717c2c66232d6e","variable_signal_bond":"66717c2c66232d6e","variable_last_sent_callee_id_name":"Alan Evans","variable_last_sent_callee_id_number":"1000","variable_sip_term_status":"200","variable_proto_specific_hangup_cause":"sip:200","variable_sip_term_cause":"16","variable_last_bridge_role":"originatee","variable_sip_user_agent":"tSIP 0.01.70.00","variable_sip_hangup_disposition":"recv_bye","variable_hangup_cause":"NORMAL_CLEARING","variable_hangup_cause_q850":"16","variable_digits_dialed":"none","variable_start_stamp":"2025-03-26 10:50:41","variable_profile_start_stamp":"2025-03-26 10:50:41","variable_answer_stamp":"2025-03-26 10:50:43","variable_bridge_stamp":"2025-03-26 10:50:43","variable_progress_stamp":"2025-03-26 10:50:41","variable_end_stamp":"2025-03-26 10:50:46","variable_start_epoch":"1742986241","variable_start_uepoch":"1742986241947047","variable_profile_start_epoch":"1742986241","variable_profile_start_uepoch":"1742986241947047","variable_answer_epoch":"1742986243","variable_answer_uepoch":"1742986243287232","variable_bridge_epoch":"1742986243","variable_bridge_uepoch":"1742986243287232","variable_last_hold_epoch":"0","variable_last_hold_uepoch":"0","variable_hold_accum_seconds":"0","variable_hold_accum_usec":"0","variable_hold_accum_ms":"0","variable_resurrect_epoch":"0","variable_resurrect_uepoch":"0","variable_progress_epoch":"1742986241","variable_progress_uepoch":"1742986241987059","variable_progress_media_epoch":"0","variable_progress_media_uepoch":"0","variable_end_epoch":"1742986246","variable_end_uepoch":"1742986246687088","variable_caller_id":"\"Alan Evans\" <1000>","variable_duration":"5","variable_billsec":"3","variable_progresssec":"0","variable_answersec":"2","variable_waitsec":"2","variable_progress_mediasec":"0","variable_flow_billsec":"5","variable_mduration":"4740","variable_billmsec":"3400","variable_progressmsec":"40","variable_answermsec":"1340","variable_waitmsec":"1340","variable_progress_mediamsec":"0","variable_flow_billmsec":"4740","variable_uduration":"4740041","variable_billusec":"3399856","variable_progressusec":"40012","variable_answerusec":"1340185","variable_waitusec":"1340185","variable_progress_mediausec":"0","variable_flow_billusec":"4740041","variable_call_uuid":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_rtp_audio_in_raw_bytes":"28552","variable_rtp_audio_in_media_bytes":"28552","variable_rtp_audio_in_packet_count":"166","variable_rtp_audio_in_media_packet_count":"166","variable_rtp_audio_in_skip_packet_count":"5","variable_rtp_audio_in_jitter_packet_count":"0","variable_rtp_audio_in_dtmf_packet_count":"0","variable_rtp_audio_in_cng_packet_count":"0","variable_rtp_audio_in_flush_packet_count":"0","variable_rtp_audio_in_largest_jb_size":"0","variable_rtp_audio_in_jitter_min_variance":"3.87","variable_rtp_audio_in_jitter_max_variance":"200.00","variable_rtp_audio_in_jitter_loss_rate":"0.00","variable_rtp_audio_in_jitter_burst_rate":"0.00","variable_rtp_audio_in_mean_interval":"20.13","variable_rtp_audio_in_flaw_total":"0","variable_rtp_audio_in_quality_percentage":"100.00","variable_rtp_audio_in_mos":"4.50","variable_rtp_audio_out_raw_bytes":"28552","variable_rtp_audio_out_media_bytes":"28552","variable_rtp_audio_out_packet_count":"166","variable_rtp_audio_out_media_packet_count":"166","variable_rtp_audio_out_skip_packet_count":"0","variable_rtp_audio_out_dtmf_packet_count":"0","variable_rtp_audio_out_cng_packet_count":"0","variable_rtp_audio_rtcp_packet_count":"0","variable_rtp_audio_rtcp_octet_count":"0","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com"}

================================================================================
2025-03-26T10:50:46.702+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   [::1]:60048 -> [::1]:5672
Virtual host: /
User:         guest
Channel:      1
Exchange:     freeswitch
Routing keys: [<<"FreeSWITCH.debian12-kazoo.CHANNEL_DESTROY.66717c2c66232d6e">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_fs_amqp_listener-<0.1619.0>-00a71b61">>]
Properties:   [{<<"timestamp">>,signedint,1742986246},
               {<<"headers">>,table,
                [{<<"x_Liquid_MessageSentTimeStamp">>,timestamp,1742986246}]},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Event-Name":"CHANNEL_DESTROY","Core-UUID":"917c114b-eaf1-40f2-8407-4d2cd97687a1","FreeSWITCH-Hostname":"debian12-kazoo","FreeSWITCH-Switchname":"debian12-kazoo","FreeSWITCH-IPv4":"10.1.1.14","FreeSWITCH-IPv6":"::1","Event-Date-Local":"2025-03-26 10:50:46","Event-Date-GMT":"Wed, 26 Mar 2025 10:50:46 GMT","Event-Date-Timestamp":"1742986246687088","Event-Calling-File":"switch_core_session.c","Event-Calling-Function":"switch_core_session_perform_destroy","Event-Calling-Line-Number":"1584","Event-Sequence":"784","Channel-State":"CS_REPORTING","Channel-Call-State":"HANGUP","Channel-State-Number":"12","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Unique-ID":"66717c2c66232d6e","Call-Direction":"inbound","Presence-Call-Direction":"inbound","Channel-HIT-Dialplan":"true","Channel-Presence-ID":"1000@4f5549.sip.2600hz.com","Channel-Call-UUID":"66717c2c66232d6e","Answer-State":"hangup","Hangup-Cause":"NORMAL_CLEARING","Channel-Read-Codec-Name":"PCMU","Channel-Read-Codec-Rate":"8000","Channel-Read-Codec-Bit-Rate":"64000","Channel-Write-Codec-Name":"PCMU","Channel-Write-Codec-Rate":"8000","Channel-Write-Codec-Bit-Rate":"64000","Caller-Direction":"inbound","Caller-Logical-Direction":"inbound","Caller-Username":"user_p48egZdPh4","Caller-Dialplan":"XML","Caller-Caller-ID-Name":"Alan Evans","Caller-Caller-ID-Number":"1000","Caller-Orig-Caller-ID-Name":"user_p48egZdPh4","Caller-Orig-Caller-ID-Number":"user_p48egZdPh4","Caller-Callee-ID-Name":"Alan Evans2","Caller-Callee-ID-Number":"1001","Caller-Network-Addr":"10.1.1.14","Caller-ANI":"user_p48egZdPh4","Caller-Destination-Number":"1001","Caller-Unique-ID":"66717c2c66232d6e","Caller-Source":"mod_sofia","Caller-Context":"context_2","Caller-Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Caller-Profile-Index":"1","Caller-Profile-Created-Time":"1742986241847058","Caller-Channel-Created-Time":"1742986241847058","Caller-Channel-Answered-Time":"1742986243287232","Caller-Channel-Progress-Time":"1742986241987059","Caller-Channel-Progress-Media-Time":"1742986242007088","Caller-Channel-Hangup-Time":"1742986246687088","Caller-Channel-Transfer-Time":"0","Caller-Channel-Resurrect-Time":"0","Caller-Channel-Bridged-Time":"1742986243287232","Caller-Channel-Last-Hold":"0","Caller-Channel-Hold-Accum":"0","Caller-Screen-Bit":"true","Caller-Privacy-Hide-Name":"false","Caller-Privacy-Hide-Number":"false","Other-Type":"originatee","Other-Leg-Direction":"outbound","Other-Leg-Logical-Direction":"inbound","Other-Leg-Username":"user_p48egZdPh4","Other-Leg-Dialplan":"XML","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Orig-Caller-ID-Name":"user_p48egZdPh4","Other-Leg-Orig-Caller-ID-Number":"user_p48egZdPh4","Other-Leg-Callee-ID-Name":"Alan Evans2","Other-Leg-Callee-ID-Number":"1001","Other-Leg-Network-Addr":"10.1.1.14","Other-Leg-ANI":"user_p48egZdPh4","Other-Leg-Destination-Number":"user_42HqcPrjCA","Other-Leg-Unique-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Other-Leg-Source":"mod_sofia","Other-Leg-Context":"context_2","Other-Leg-Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Other-Leg-Profile-Created-Time":"1742986241947047","Other-Leg-Channel-Created-Time":"1742986241947047","Other-Leg-Channel-Answered-Time":"1742986243287232","Other-Leg-Channel-Progress-Time":"1742986241987059","Other-Leg-Channel-Progress-Media-Time":"0","Other-Leg-Channel-Hangup-Time":"0","Other-Leg-Channel-Transfer-Time":"0","Other-Leg-Channel-Resurrect-Time":"0","Other-Leg-Channel-Bridged-Time":"0","Other-Leg-Channel-Last-Hold":"0","Other-Leg-Channel-Hold-Accum":"0","Other-Leg-Screen-Bit":"true","Other-Leg-Privacy-Hide-Name":"false","Other-Leg-Privacy-Hide-Number":"false","variable_direction":"inbound","variable_uuid":"66717c2c66232d6e","variable_session_id":"3","variable_sip_from_user":"user_p48egZdPh4","variable_sip_from_uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_from_host":"4f5549.sip.2600hz.com","variable_channel_name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_local_network_addr":"10.1.1.14","variable_sip_network_ip":"10.1.1.14","variable_sip_network_port":"5060","variable_sip_invite_stamp":"1742986241847058","variable_sip_received_ip":"10.1.1.14","variable_sip_received_port":"5060","variable_sip_via_protocol":"udp","variable_sip_authorized":"true","variable_user_name":"user_p48egZdPh4","variable_domain_name":"4f5549.sip.2600hz.com","variable_sip_from_user_stripped":"user_p48egZdPh4","variable_sofia_profile_name":"sipinterface_1","variable_sofia_profile_url":"sip:mod_sofia@10.1.1.14:11000","variable_recovery_profile_name":"sipinterface_1","variable_sip_invite_route_uri":"<sip:10.1.1.14;lr=on;ftag=2628444714184456>","variable_sip_invite_record_route":"<sip:10.1.1.14;lr=on;ftag=2628444714184456>","variable_sip_allow":"INVITE, ACK, BYE, CANCEL, OPTIONS, REFER, NOTIFY, SUBSCRIBE, INFO","variable_sip_req_user":"1001","variable_sip_req_uri":"1001@4f5549.sip.2600hz.com","variable_sip_req_host":"4f5549.sip.2600hz.com","variable_sip_to_user":"1001","variable_sip_to_uri":"1001@4f5549.sip.2600hz.com","variable_sip_to_host":"4f5549.sip.2600hz.com","variable_sip_contact_params":"alias=10.1.1.31~54730~1","variable_sip_contact_user":"user_p48egZdPh4","variable_sip_contact_port":"54730","variable_sip_contact_uri":"user_p48egZdPh4@10.1.1.31:54730","variable_sip_contact_host":"10.1.1.31","variable_sip_user_agent":"tSIP 0.01.70.00","variable_sip_via_host":"10.1.1.14","variable_max_forwards":"50","variable_switch_r_sdp":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_ep_codec_string":"CORE_PCM_MODULE.PCMU@8000h@20i@64000b,CORE_PCM_MODULE.PCMA@8000h@20i@64000b","variable_ecallmgr_Bridge-ID":"66717c2c66232d6e","variable_ecallmgr_Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","variable_ecallmgr_Username":"user_p48egzdph4","variable_ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_presence_id":"1000@4f5549.sip.2600hz.com","variable_ecallmgr_Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","variable_ecallmgr_Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","variable_ecallmgr_Authorizing-Type":"device","variable_ecallmgr_Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","variable_ecallmgr_Account-Realm":"4f5549.sip.2600hz.com","variable_ecallmgr_Account-Name":"Kage Design Services Ltd","variable_ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_ecallmgr_CallFlow-ID":"7c7290c92292369eb0737a157b8169be","variable_ecallmgr_Channel-Authorized":"true","variable_ecallmgr_Application-Node":"kazoo_apps@debian12-kazoo.kageds.com","variable_ecallmgr_Application-Name":"callflow","variable_effective_caller_id_name":"Alan Evans","variable_effective_caller_id_number":"1000","variable_ecallmgr_Privacy-Hide-Name":"false","variable_ecallmgr_Privacy-Hide-Number":"false","variable_ringback":"%(2000,4000,440,480)","variable_transfer_ringback":"%(2000,4000,440,480)","variable_call_uuid":"66717c2c66232d6e","variable_continue_on_fail":"true","variable_sip_redirect_context":"context_2","variable_hangup_after_bridge":"true","variable_ecallmgr_Call-Interaction-ID":"63910205441-db5e04cf","variable_export_vars":"ecallmgr_Bridge-ID,ecallmgr_Ecallmgr-Node,ringback,transfer_ringback,sip_redirect_context,ecallmgr_Call-Interaction-ID","variable_current_application_data":"{call_timeout=20,originate_timeout=20,outbound_redirect_fatal='false',bridge_export_vars='hold_music',local_var_clobber='true'}[^^!ecallmgr_Username='user_42HqcPrjCA'!ecallmgr_Realm='4f5549.sip.2600hz.com'!presence_id='1001@4f5549.sip.2600hz.com'!origination_callee_id_number='1001'!origination_callee_id_name='Alan Evans2'!ignore_completed_elsewhere='false'!leg_timeout='20'!sip_h_X-KAZOO-AOR='sip:user_42HqcPrjCA@4f5549.sip.2600hz.com'!sip_h_X-KAZOO-INVITE-FORMAT='contact'!ecallmgr_Authorizing-ID='9cabbb2ac44fbb1638218cbe47c83379'!ecallmgr_Authorizing-Type='device'!ecallmgr_Owner-ID='b96758fb45467d8555f42735cc5b39b3'!ecallmgr_Account-ID='47459457c634aff90b96f6af8a8eebb6'!sdp_secure_savp_only='false'!sip_invite_domain='4f5549.sip.2600hz.com'!absolute_codec_string='^^:PCMA:PCMU'!effective_callee_id_number='1001'!effective_callee_id_name='Alan Evans2']sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com;fs_path=sip:10.1.1.14:5060","variable_current_application":"bridge","variable_originated_legs":"338d3557-e3b7-4bd2-b253-81c905d474cd;Alan Evans2;1001","variable_rtp_use_codec_string":"OPUS,VP8,H263,H264,G7221@32000h,G7221@16000h,G722,PCMU,PCMA,G729,GSM,Speex","variable_remote_video_media_flow":"inactive","variable_remote_text_media_flow":"inactive","variable_remote_audio_media_flow":"sendrecv","variable_rtp_audio_recv_pt":"0","variable_rtp_use_codec_name":"PCMU","variable_rtp_use_codec_rate":"8000","variable_rtp_use_codec_ptime":"20","variable_rtp_use_codec_channels":"1","variable_rtp_last_audio_codec_string":"PCMU@8000h@20i@1c","variable_original_read_codec":"PCMU","variable_original_read_rate":"8000","variable_write_codec":"PCMU","variable_write_rate":"8000","variable_dtmf_type":"rfc2833","variable_local_media_ip":"10.1.1.14","variable_local_media_port":"19364","variable_advertised_media_ip":"10.1.1.14","variable_rtp_use_timer_name":"soft","variable_rtp_use_pt":"0","variable_rtp_use_ssrc":"266932313","variable_rtp_2833_send_payload":"101","variable_rtp_2833_recv_payload":"101","variable_remote_media_ip":"10.1.1.31","variable_remote_media_port":"1690","variable_switch_m_sdp":"v=0\r\no=- 1263800803 855048506 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 14540 RTP/AVP 8 0 101\r\nb=AS:125\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_video_media_flow":"inactive","variable_text_media_flow":"inactive","variable_audio_media_flow":"sendrecv","variable_read_codec":"PCMU","variable_read_rate":"8000","variable_rtp_local_sdp_str":"v=0\r\no=FreeSWITCH 1742966878 1742966880 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 19364 RTP/AVP 0 101\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=ptime:20\r\na=sendrecv\r\n","variable_endpoint_disposition":"ANSWER","variable_originate_disposition":"SUCCESS","variable_DIALSTATUS":"SUCCESS","variable_originate_causes":"338d3557-e3b7-4bd2-b253-81c905d474cd;NONE","variable_bridge_export_vars":"hold_music","variable_hold_music":"local_stream://default","variable_last_bridge_to":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_bridge_channel":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_bridge_uuid":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_signal_bond":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_sip_to_tag":"B7pjeDUNXS19p","variable_sip_from_tag":"2628444714184456","variable_sip_cseq":"4471","variable_sip_call_id":"66717c2c66232d6e","variable_sip_full_via":"SIP/2.0/UDP 10.1.1.14;branch=z9hG4bK6eab.49742e84f19c2e621fc410e4d3f0c36c.0,SIP/2.0/UDP 10.1.1.31:54730;received=10.1.1.31;branch=z9hG4bK796c7c5c4b322df1;rport=54730","variable_sip_full_from":"<sip:user_p48egZdPh4@4f5549.sip.2600hz.com>;tag=2628444714184456","variable_sip_full_to":"<sip:1001@4f5549.sip.2600hz.com>;tag=B7pjeDUNXS19p","variable_last_sent_callee_id_name":"Alan Evans2","variable_last_sent_callee_id_number":"1001","variable_sip_hangup_phrase":"OK","variable_last_bridge_hangup_cause":"NORMAL_CLEARING","variable_last_bridge_proto_specific_hangup_cause":"sip:200","variable_bridge_hangup_cause":"NORMAL_CLEARING","variable_hangup_cause":"NORMAL_CLEARING","variable_hangup_cause_q850":"16","variable_digits_dialed":"none","variable_start_stamp":"2025-03-26 10:50:41","variable_profile_start_stamp":"2025-03-26 10:50:41","variable_answer_stamp":"2025-03-26 10:50:43","variable_bridge_stamp":"2025-03-26 10:50:43","variable_progress_stamp":"2025-03-26 10:50:41","variable_progress_media_stamp":"2025-03-26 10:50:42","variable_end_stamp":"2025-03-26 10:50:46","variable_start_epoch":"1742986241","variable_start_uepoch":"1742986241847058","variable_profile_start_epoch":"1742986241","variable_profile_start_uepoch":"1742986241847058","variable_answer_epoch":"1742986243","variable_answer_uepoch":"1742986243287232","variable_bridge_epoch":"1742986243","variable_bridge_uepoch":"1742986243287232","variable_last_hold_epoch":"0","variable_last_hold_uepoch":"0","variable_hold_accum_seconds":"0","variable_hold_accum_usec":"0","variable_hold_accum_ms":"0","variable_resurrect_epoch":"0","variable_resurrect_uepoch":"0","variable_progress_epoch":"1742986241","variable_progress_uepoch":"1742986241987059","variable_progress_media_epoch":"1742986242","variable_progress_media_uepoch":"1742986242007088","variable_end_epoch":"1742986246","variable_end_uepoch":"1742986246687088","variable_last_app":"bridge","variable_last_arg":"{call_timeout=20,originate_timeout=20,outbound_redirect_fatal='false',bridge_export_vars='hold_music',local_var_clobber='true'}[^^!ecallmgr_Username='user_42HqcPrjCA'!ecallmgr_Realm='4f5549.sip.2600hz.com'!presence_id='1001@4f5549.sip.2600hz.com'!origination_callee_id_number='1001'!origination_callee_id_name='Alan Evans2'!ignore_completed_elsewhere='false'!leg_timeout='20'!sip_h_X-KAZOO-AOR='sip:user_42HqcPrjCA@4f5549.sip.2600hz.com'!sip_h_X-KAZOO-INVITE-FORMAT='contact'!ecallmgr_Authorizing-ID='9cabbb2ac44fbb1638218cbe47c83379'!ecallmgr_Authorizing-Type='device'!ecallmgr_Owner-ID='b96758fb45467d8555f42735cc5b39b3'!ecallmgr_Account-ID='47459457c634aff90b96f6af8a8eebb6'!sdp_secure_savp_only='false'!sip_invite_domain='4f5549.sip.2600hz.com'!absolute_codec_string='^^:PCMA:PCMU'!effective_callee_id_number='1001'!effective_callee_id_name='Alan Evans2']sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com;fs_path=sip:10.1.1.14:5060","variable_caller_id":"\"Alan Evans\" <1000>","variable_duration":"5","variable_billsec":"3","variable_progresssec":"0","variable_answersec":"2","variable_waitsec":"2","variable_progress_mediasec":"1","variable_flow_billsec":"5","variable_mduration":"4840","variable_billmsec":"3400","variable_progressmsec":"140","variable_answermsec":"1440","variable_waitmsec":"1440","variable_progress_mediamsec":"160","variable_flow_billmsec":"4840","variable_uduration":"4840030","variable_billusec":"3399856","variable_progressusec":"140001","variable_answerusec":"1440174","variable_waitusec":"1440174","variable_progress_mediausec":"160030","variable_flow_billusec":"4840030","variable_sip_hangup_disposition":"send_bye","variable_rtp_audio_in_raw_bytes":"39044","variable_rtp_audio_in_media_bytes":"38700","variable_rtp_audio_in_packet_count":"227","variable_rtp_audio_in_media_packet_count":"225","variable_rtp_audio_in_skip_packet_count":"9","variable_rtp_audio_in_jitter_packet_count":"0","variable_rtp_audio_in_dtmf_packet_count":"0","variable_rtp_audio_in_cng_packet_count":"0","variable_rtp_audio_in_flush_packet_count":"2","variable_rtp_audio_in_largest_jb_size":"0","variable_rtp_audio_in_jitter_min_variance":"28.55","variable_rtp_audio_in_jitter_max_variance":"408.33","variable_rtp_audio_in_jitter_loss_rate":"0.00","variable_rtp_audio_in_jitter_burst_rate":"0.00","variable_rtp_audio_in_mean_interval":"20.00","variable_rtp_audio_in_flaw_total":"0","variable_rtp_audio_in_quality_percentage":"100.00","variable_rtp_audio_in_mos":"4.50","variable_rtp_audio_out_raw_bytes":"39044","variable_rtp_audio_out_media_bytes":"39044","variable_rtp_audio_out_packet_count":"227","variable_rtp_audio_out_media_packet_count":"227","variable_rtp_audio_out_skip_packet_count":"0","variable_rtp_audio_out_dtmf_packet_count":"0","variable_rtp_audio_out_cng_packet_count":"0","variable_rtp_audio_rtcp_packet_count":"0","variable_rtp_audio_rtcp_octet_count":"0","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com"}

================================================================================
2025-03-26T10:50:46.704+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      175
Exchange:     freeswitch
Routing keys: [<<"FreeSWITCH.debian12-kazoo.CHANNEL_DESTROY.338d3557-e3b7-4bd2-b253-81c905d474cd">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_fs_amqp_listener-<0.1619.0>-00a71b61
Properties:   [{<<"timestamp">>,signedint,1742986246},
               {<<"headers">>,table,
                [{<<"x_Liquid_MessageSentTimeStamp">>,timestamp,1742986246}]},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Event-Name":"CHANNEL_DESTROY","Core-UUID":"917c114b-eaf1-40f2-8407-4d2cd97687a1","FreeSWITCH-Hostname":"debian12-kazoo","FreeSWITCH-Switchname":"debian12-kazoo","FreeSWITCH-IPv4":"10.1.1.14","FreeSWITCH-IPv6":"::1","Event-Date-Local":"2025-03-26 10:50:46","Event-Date-GMT":"Wed, 26 Mar 2025 10:50:46 GMT","Event-Date-Timestamp":"1742986246687088","Event-Calling-File":"switch_core_session.c","Event-Calling-Function":"switch_core_session_perform_destroy","Event-Calling-Line-Number":"1584","Event-Sequence":"778","Channel-State":"CS_REPORTING","Channel-Call-State":"HANGUP","Channel-State-Number":"12","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Unique-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Call-Direction":"outbound","Presence-Call-Direction":"outbound","Channel-HIT-Dialplan":"false","Channel-Presence-ID":"1001@4f5549.sip.2600hz.com","Channel-Call-UUID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Answer-State":"hangup","Hangup-Cause":"NORMAL_CLEARING","Channel-Read-Codec-Name":"PCMA","Channel-Read-Codec-Rate":"8000","Channel-Read-Codec-Bit-Rate":"64000","Channel-Write-Codec-Name":"PCMA","Channel-Write-Codec-Rate":"8000","Channel-Write-Codec-Bit-Rate":"64000","Caller-Direction":"outbound","Caller-Logical-Direction":"outbound","Caller-Username":"user_p48egZdPh4","Caller-Dialplan":"XML","Caller-Caller-ID-Name":"Alan Evans","Caller-Caller-ID-Number":"1000","Caller-Orig-Caller-ID-Name":"user_p48egZdPh4","Caller-Orig-Caller-ID-Number":"user_p48egZdPh4","Caller-Callee-ID-Name":"Alan Evans2","Caller-Callee-ID-Number":"1001","Caller-Network-Addr":"10.1.1.14","Caller-ANI":"user_p48egZdPh4","Caller-Destination-Number":"user_42HqcPrjCA","Caller-Unique-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Caller-Source":"mod_sofia","Caller-Context":"context_2","Caller-Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Caller-Profile-Index":"1","Caller-Profile-Created-Time":"1742986241947047","Caller-Channel-Created-Time":"1742986241947047","Caller-Channel-Answered-Time":"1742986243287232","Caller-Channel-Progress-Time":"1742986241987059","Caller-Channel-Progress-Media-Time":"0","Caller-Channel-Hangup-Time":"1742986246687088","Caller-Channel-Transfer-Time":"0","Caller-Channel-Resurrect-Time":"0","Caller-Channel-Bridged-Time":"1742986243287232","Caller-Channel-Last-Hold":"0","Caller-Channel-Hold-Accum":"0","Caller-Screen-Bit":"true","Caller-Privacy-Hide-Name":"false","Caller-Privacy-Hide-Number":"false","Other-Type":"originator","Other-Leg-Direction":"inbound","Other-Leg-Logical-Direction":"inbound","Other-Leg-Username":"user_p48egZdPh4","Other-Leg-Dialplan":"XML","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Orig-Caller-ID-Name":"user_p48egZdPh4","Other-Leg-Orig-Caller-ID-Number":"user_p48egZdPh4","Other-Leg-Network-Addr":"10.1.1.14","Other-Leg-ANI":"user_p48egZdPh4","Other-Leg-Destination-Number":"1001","Other-Leg-Unique-ID":"66717c2c66232d6e","Other-Leg-Source":"mod_sofia","Other-Leg-Context":"context_2","Other-Leg-Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Other-Leg-Profile-Created-Time":"0","Other-Leg-Channel-Created-Time":"0","Other-Leg-Channel-Answered-Time":"0","Other-Leg-Channel-Progress-Time":"1742986241987059","Other-Leg-Channel-Progress-Media-Time":"0","Other-Leg-Channel-Hangup-Time":"0","Other-Leg-Channel-Transfer-Time":"0","Other-Leg-Channel-Resurrect-Time":"0","Other-Leg-Channel-Bridged-Time":"0","Other-Leg-Channel-Last-Hold":"0","Other-Leg-Channel-Hold-Accum":"0","Other-Leg-Screen-Bit":"true","Other-Leg-Privacy-Hide-Name":"false","Other-Leg-Privacy-Hide-Number":"false","variable_direction":"outbound","variable_is_outbound":"true","variable_uuid":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_session_id":"4","variable_sip_profile_name":"sipinterface_1","variable_text_media_flow":"disabled","variable_channel_name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sip_destination_url":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com;fs_path=sip:10.1.1.14:5060","variable_max_forwards":"49","variable_originator_codec":"CORE_PCM_MODULE.PCMU@8000h@20i@64000b,CORE_PCM_MODULE.PCMA@8000h@20i@64000b","variable_originator":"66717c2c66232d6e","variable_switch_m_sdp":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_export_vars":"ecallmgr_Bridge-ID,ecallmgr_Ecallmgr-Node,ringback,transfer_ringback,sip_redirect_context,ecallmgr_Call-Interaction-ID","variable_ecallmgr_Bridge-ID":"66717c2c66232d6e","variable_ecallmgr_Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","variable_ringback":"%(2000,4000,440,480)","variable_transfer_ringback":"%(2000,4000,440,480)","variable_sip_redirect_context":"context_2","variable_ecallmgr_Call-Interaction-ID":"63910205441-db5e04cf","variable_call_timeout":"20","variable_originate_timeout":"20","variable_outbound_redirect_fatal":"false","variable_local_var_clobber":"true","variable_originate_early_media":"true","variable_ecallmgr_Username":"user_42HqcPrjCA","variable_ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_presence_id":"1001@4f5549.sip.2600hz.com","variable_origination_callee_id_number":"1001","variable_origination_callee_id_name":"Alan Evans2","variable_ignore_completed_elsewhere":"false","variable_leg_timeout":"20","variable_sip_h_X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sip_h_X-KAZOO-INVITE-FORMAT":"contact","variable_ecallmgr_Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","variable_ecallmgr_Authorizing-Type":"device","variable_ecallmgr_Owner-ID":"b96758fb45467d8555f42735cc5b39b3","variable_sdp_secure_savp_only":"false","variable_sip_invite_domain":"4f5549.sip.2600hz.com","variable_absolute_codec_string":"^^:PCMA:PCMU","variable_effective_callee_id_number":"1001","variable_effective_callee_id_name":"Alan Evans2","variable_originating_leg_uuid":"66717c2c66232d6e","variable_originate_endpoint":"sofia","variable_audio_media_flow":"sendrecv","variable_video_media_flow":"sendrecv","variable_rtp_local_sdp_str":"v=0\r\no=FreeSWITCH 1742959223 1742959224 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 27018 RTP/AVP 8 0 101 13\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=rtpmap:13 CN/8000\r\na=ptime:20\r\na=sendrecv\r\n","variable_sip_outgoing_contact_uri":"<sip:mod_sofia@10.1.1.14:11000>","variable_sip_req_uri":"user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sofia_profile_name":"sipinterface_1","variable_recovery_profile_name":"sipinterface_1","variable_sofia_profile_url":"sip:mod_sofia@10.1.1.14:11000","variable_ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_ecallmgr_Global-Resource":"false","variable_ecallmgr_Channel-Authorized":"true","variable_sip_local_network_addr":"10.1.1.14","variable_sip_reply_host":"10.1.1.14","variable_sip_reply_port":"5060","variable_sip_network_ip":"10.1.1.14","variable_sip_network_port":"5060","variable_sip_allow":"INVITE, ACK, BYE, CANCEL, OPTIONS, REFER, NOTIFY, SUBSCRIBE, INFO","variable_sip_recover_contact":"<sip:user_42HqcPrjCA@10.1.1.31:61179;alias=10.1.1.31~61179~1>","variable_sip_invite_route_uri":"<sip:10.1.1.14;lr=on;ftag=cggBg8BSt2Qvj>","variable_sip_invite_record_route":"<sip:10.1.1.14;lr=on;ftag=cggBg8BSt2Qvj>","variable_sip_full_via":"SIP/2.0/UDP 10.1.1.14:11000;received=10.1.1.14;rport=11000;branch=z9hG4bKS1ec6FQtKFFpK","variable_sip_recover_via":"SIP/2.0/UDP 10.1.1.14:11000;received=10.1.1.14;rport=11000;branch=z9hG4bKS1ec6FQtKFFpK","variable_sip_from_display":"Alan Evans","variable_sip_full_from":"\"Alan Evans\" <sip:1000@4f5549.sip.2600hz.com>;tag=cggBg8BSt2Qvj","variable_sip_full_to":"<sip:user_42HqcPrjCA@4f5549.sip.2600hz.com>;tag=09ca759f6a08420a","variable_sip_from_user":"1000","variable_sip_from_uri":"1000@4f5549.sip.2600hz.com","variable_sip_from_host":"4f5549.sip.2600hz.com","variable_sip_to_user":"user_42HqcPrjCA","variable_sip_to_uri":"user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_sip_to_host":"4f5549.sip.2600hz.com","variable_sip_contact_params":"alias=10.1.1.31~61179~1","variable_sip_contact_user":"user_42HqcPrjCA","variable_sip_contact_port":"61179","variable_sip_contact_uri":"user_42HqcPrjCA@10.1.1.31:61179","variable_sip_contact_host":"10.1.1.31","variable_sip_to_tag":"09ca759f6a08420a","variable_sip_from_tag":"cggBg8BSt2Qvj","variable_sip_cseq":"96939328","variable_sip_call_id":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_switch_r_sdp":"v=0\r\no=- 1263800803 855048506 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 14540 RTP/AVP 8 0 101\r\nb=AS:125\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_ep_codec_string":"CORE_PCM_MODULE.PCMA@8000h@20i@64000b,CORE_PCM_MODULE.PCMU@8000h@20i@64000b","variable_rtp_use_codec_string":"^^:PCMA:PCMU","variable_remote_video_media_flow":"inactive","variable_remote_text_media_flow":"inactive","variable_remote_audio_media_flow":"sendrecv","variable_rtp_audio_recv_pt":"8","variable_rtp_use_codec_name":"PCMA","variable_rtp_use_codec_rate":"8000","variable_rtp_use_codec_ptime":"20","variable_rtp_use_codec_channels":"1","variable_rtp_last_audio_codec_string":"PCMA@8000h@20i@1c","variable_read_codec":"PCMA","variable_original_read_codec":"PCMA","variable_read_rate":"8000","variable_original_read_rate":"8000","variable_write_codec":"PCMA","variable_write_rate":"8000","variable_dtmf_type":"rfc2833","variable_local_media_ip":"10.1.1.14","variable_local_media_port":"27018","variable_advertised_media_ip":"10.1.1.14","variable_rtp_use_timer_name":"soft","variable_rtp_use_pt":"8","variable_rtp_use_ssrc":"1206307353","variable_rtp_2833_send_payload":"101","variable_rtp_2833_recv_payload":"101","variable_remote_media_ip":"10.1.1.31","variable_remote_media_port":"14540","variable_endpoint_disposition":"ANSWER","variable_bridge_export_vars":"hold_music","variable_hold_music":"local_stream://default","variable_last_bridge_to":"66717c2c66232d6e","variable_bridge_channel":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","variable_bridge_uuid":"66717c2c66232d6e","variable_signal_bond":"66717c2c66232d6e","variable_last_sent_callee_id_name":"Alan Evans","variable_last_sent_callee_id_number":"1000","variable_sip_term_status":"200","variable_proto_specific_hangup_cause":"sip:200","variable_sip_term_cause":"16","variable_last_bridge_role":"originatee","variable_sip_user_agent":"tSIP 0.01.70.00","variable_sip_hangup_disposition":"recv_bye","variable_hangup_cause":"NORMAL_CLEARING","variable_hangup_cause_q850":"16","variable_digits_dialed":"none","variable_start_stamp":"2025-03-26 10:50:41","variable_profile_start_stamp":"2025-03-26 10:50:41","variable_answer_stamp":"2025-03-26 10:50:43","variable_bridge_stamp":"2025-03-26 10:50:43","variable_progress_stamp":"2025-03-26 10:50:41","variable_end_stamp":"2025-03-26 10:50:46","variable_start_epoch":"1742986241","variable_start_uepoch":"1742986241947047","variable_profile_start_epoch":"1742986241","variable_profile_start_uepoch":"1742986241947047","variable_answer_epoch":"1742986243","variable_answer_uepoch":"1742986243287232","variable_bridge_epoch":"1742986243","variable_bridge_uepoch":"1742986243287232","variable_last_hold_epoch":"0","variable_last_hold_uepoch":"0","variable_hold_accum_seconds":"0","variable_hold_accum_usec":"0","variable_hold_accum_ms":"0","variable_resurrect_epoch":"0","variable_resurrect_uepoch":"0","variable_progress_epoch":"1742986241","variable_progress_uepoch":"1742986241987059","variable_progress_media_epoch":"0","variable_progress_media_uepoch":"0","variable_end_epoch":"1742986246","variable_end_uepoch":"1742986246687088","variable_caller_id":"\"Alan Evans\" <1000>","variable_duration":"5","variable_billsec":"3","variable_progresssec":"0","variable_answersec":"2","variable_waitsec":"2","variable_progress_mediasec":"0","variable_flow_billsec":"5","variable_mduration":"4740","variable_billmsec":"3400","variable_progressmsec":"40","variable_answermsec":"1340","variable_waitmsec":"1340","variable_progress_mediamsec":"0","variable_flow_billmsec":"4740","variable_uduration":"4740041","variable_billusec":"3399856","variable_progressusec":"40012","variable_answerusec":"1340185","variable_waitusec":"1340185","variable_progress_mediausec":"0","variable_flow_billusec":"4740041","variable_call_uuid":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_rtp_audio_in_raw_bytes":"28552","variable_rtp_audio_in_media_bytes":"28552","variable_rtp_audio_in_packet_count":"166","variable_rtp_audio_in_media_packet_count":"166","variable_rtp_audio_in_skip_packet_count":"5","variable_rtp_audio_in_jitter_packet_count":"0","variable_rtp_audio_in_dtmf_packet_count":"0","variable_rtp_audio_in_cng_packet_count":"0","variable_rtp_audio_in_flush_packet_count":"0","variable_rtp_audio_in_largest_jb_size":"0","variable_rtp_audio_in_jitter_min_variance":"3.87","variable_rtp_audio_in_jitter_max_variance":"200.00","variable_rtp_audio_in_jitter_loss_rate":"0.00","variable_rtp_audio_in_jitter_burst_rate":"0.00","variable_rtp_audio_in_mean_interval":"20.13","variable_rtp_audio_in_flaw_total":"0","variable_rtp_audio_in_quality_percentage":"100.00","variable_rtp_audio_in_mos":"4.50","variable_rtp_audio_out_raw_bytes":"28552","variable_rtp_audio_out_media_bytes":"28552","variable_rtp_audio_out_packet_count":"166","variable_rtp_audio_out_media_packet_count":"166","variable_rtp_audio_out_skip_packet_count":"0","variable_rtp_audio_out_dtmf_packet_count":"0","variable_rtp_audio_out_cng_packet_count":"0","variable_rtp_audio_rtcp_packet_count":"0","variable_rtp_audio_rtcp_octet_count":"0","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com"}

================================================================================
2025-03-26T10:50:46.709+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      175
Exchange:     freeswitch
Routing keys: [<<"FreeSWITCH.debian12-kazoo.CHANNEL_DESTROY.66717c2c66232d6e">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-ecallmgr_fs_amqp_listener-<0.1619.0>-00a71b61
Properties:   [{<<"timestamp">>,signedint,1742986246},
               {<<"headers">>,table,
                [{<<"x_Liquid_MessageSentTimeStamp">>,timestamp,1742986246}]},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Event-Name":"CHANNEL_DESTROY","Core-UUID":"917c114b-eaf1-40f2-8407-4d2cd97687a1","FreeSWITCH-Hostname":"debian12-kazoo","FreeSWITCH-Switchname":"debian12-kazoo","FreeSWITCH-IPv4":"10.1.1.14","FreeSWITCH-IPv6":"::1","Event-Date-Local":"2025-03-26 10:50:46","Event-Date-GMT":"Wed, 26 Mar 2025 10:50:46 GMT","Event-Date-Timestamp":"1742986246687088","Event-Calling-File":"switch_core_session.c","Event-Calling-Function":"switch_core_session_perform_destroy","Event-Calling-Line-Number":"1584","Event-Sequence":"784","Channel-State":"CS_REPORTING","Channel-Call-State":"HANGUP","Channel-State-Number":"12","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Unique-ID":"66717c2c66232d6e","Call-Direction":"inbound","Presence-Call-Direction":"inbound","Channel-HIT-Dialplan":"true","Channel-Presence-ID":"1000@4f5549.sip.2600hz.com","Channel-Call-UUID":"66717c2c66232d6e","Answer-State":"hangup","Hangup-Cause":"NORMAL_CLEARING","Channel-Read-Codec-Name":"PCMU","Channel-Read-Codec-Rate":"8000","Channel-Read-Codec-Bit-Rate":"64000","Channel-Write-Codec-Name":"PCMU","Channel-Write-Codec-Rate":"8000","Channel-Write-Codec-Bit-Rate":"64000","Caller-Direction":"inbound","Caller-Logical-Direction":"inbound","Caller-Username":"user_p48egZdPh4","Caller-Dialplan":"XML","Caller-Caller-ID-Name":"Alan Evans","Caller-Caller-ID-Number":"1000","Caller-Orig-Caller-ID-Name":"user_p48egZdPh4","Caller-Orig-Caller-ID-Number":"user_p48egZdPh4","Caller-Callee-ID-Name":"Alan Evans2","Caller-Callee-ID-Number":"1001","Caller-Network-Addr":"10.1.1.14","Caller-ANI":"user_p48egZdPh4","Caller-Destination-Number":"1001","Caller-Unique-ID":"66717c2c66232d6e","Caller-Source":"mod_sofia","Caller-Context":"context_2","Caller-Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Caller-Profile-Index":"1","Caller-Profile-Created-Time":"1742986241847058","Caller-Channel-Created-Time":"1742986241847058","Caller-Channel-Answered-Time":"1742986243287232","Caller-Channel-Progress-Time":"1742986241987059","Caller-Channel-Progress-Media-Time":"1742986242007088","Caller-Channel-Hangup-Time":"1742986246687088","Caller-Channel-Transfer-Time":"0","Caller-Channel-Resurrect-Time":"0","Caller-Channel-Bridged-Time":"1742986243287232","Caller-Channel-Last-Hold":"0","Caller-Channel-Hold-Accum":"0","Caller-Screen-Bit":"true","Caller-Privacy-Hide-Name":"false","Caller-Privacy-Hide-Number":"false","Other-Type":"originatee","Other-Leg-Direction":"outbound","Other-Leg-Logical-Direction":"inbound","Other-Leg-Username":"user_p48egZdPh4","Other-Leg-Dialplan":"XML","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Orig-Caller-ID-Name":"user_p48egZdPh4","Other-Leg-Orig-Caller-ID-Number":"user_p48egZdPh4","Other-Leg-Callee-ID-Name":"Alan Evans2","Other-Leg-Callee-ID-Number":"1001","Other-Leg-Network-Addr":"10.1.1.14","Other-Leg-ANI":"user_p48egZdPh4","Other-Leg-Destination-Number":"user_42HqcPrjCA","Other-Leg-Unique-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Other-Leg-Source":"mod_sofia","Other-Leg-Context":"context_2","Other-Leg-Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Other-Leg-Profile-Created-Time":"1742986241947047","Other-Leg-Channel-Created-Time":"1742986241947047","Other-Leg-Channel-Answered-Time":"1742986243287232","Other-Leg-Channel-Progress-Time":"1742986241987059","Other-Leg-Channel-Progress-Media-Time":"0","Other-Leg-Channel-Hangup-Time":"0","Other-Leg-Channel-Transfer-Time":"0","Other-Leg-Channel-Resurrect-Time":"0","Other-Leg-Channel-Bridged-Time":"0","Other-Leg-Channel-Last-Hold":"0","Other-Leg-Channel-Hold-Accum":"0","Other-Leg-Screen-Bit":"true","Other-Leg-Privacy-Hide-Name":"false","Other-Leg-Privacy-Hide-Number":"false","variable_direction":"inbound","variable_uuid":"66717c2c66232d6e","variable_session_id":"3","variable_sip_from_user":"user_p48egZdPh4","variable_sip_from_uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_from_host":"4f5549.sip.2600hz.com","variable_channel_name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","variable_sip_local_network_addr":"10.1.1.14","variable_sip_network_ip":"10.1.1.14","variable_sip_network_port":"5060","variable_sip_invite_stamp":"1742986241847058","variable_sip_received_ip":"10.1.1.14","variable_sip_received_port":"5060","variable_sip_via_protocol":"udp","variable_sip_authorized":"true","variable_user_name":"user_p48egZdPh4","variable_domain_name":"4f5549.sip.2600hz.com","variable_sip_from_user_stripped":"user_p48egZdPh4","variable_sofia_profile_name":"sipinterface_1","variable_sofia_profile_url":"sip:mod_sofia@10.1.1.14:11000","variable_recovery_profile_name":"sipinterface_1","variable_sip_invite_route_uri":"<sip:10.1.1.14;lr=on;ftag=2628444714184456>","variable_sip_invite_record_route":"<sip:10.1.1.14;lr=on;ftag=2628444714184456>","variable_sip_allow":"INVITE, ACK, BYE, CANCEL, OPTIONS, REFER, NOTIFY, SUBSCRIBE, INFO","variable_sip_req_user":"1001","variable_sip_req_uri":"1001@4f5549.sip.2600hz.com","variable_sip_req_host":"4f5549.sip.2600hz.com","variable_sip_to_user":"1001","variable_sip_to_uri":"1001@4f5549.sip.2600hz.com","variable_sip_to_host":"4f5549.sip.2600hz.com","variable_sip_contact_params":"alias=10.1.1.31~54730~1","variable_sip_contact_user":"user_p48egZdPh4","variable_sip_contact_port":"54730","variable_sip_contact_uri":"user_p48egZdPh4@10.1.1.31:54730","variable_sip_contact_host":"10.1.1.31","variable_sip_user_agent":"tSIP 0.01.70.00","variable_sip_via_host":"10.1.1.14","variable_max_forwards":"50","variable_switch_r_sdp":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_ep_codec_string":"CORE_PCM_MODULE.PCMU@8000h@20i@64000b,CORE_PCM_MODULE.PCMA@8000h@20i@64000b","variable_ecallmgr_Bridge-ID":"66717c2c66232d6e","variable_ecallmgr_Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","variable_ecallmgr_Username":"user_p48egzdph4","variable_ecallmgr_Realm":"4f5549.sip.2600hz.com","variable_presence_id":"1000@4f5549.sip.2600hz.com","variable_ecallmgr_Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","variable_ecallmgr_Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","variable_ecallmgr_Authorizing-Type":"device","variable_ecallmgr_Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","variable_ecallmgr_Account-Realm":"4f5549.sip.2600hz.com","variable_ecallmgr_Account-Name":"Kage Design Services Ltd","variable_ecallmgr_Account-ID":"47459457c634aff90b96f6af8a8eebb6","variable_ecallmgr_CallFlow-ID":"7c7290c92292369eb0737a157b8169be","variable_ecallmgr_Channel-Authorized":"true","variable_ecallmgr_Application-Node":"kazoo_apps@debian12-kazoo.kageds.com","variable_ecallmgr_Application-Name":"callflow","variable_effective_caller_id_name":"Alan Evans","variable_effective_caller_id_number":"1000","variable_ecallmgr_Privacy-Hide-Name":"false","variable_ecallmgr_Privacy-Hide-Number":"false","variable_ringback":"%(2000,4000,440,480)","variable_transfer_ringback":"%(2000,4000,440,480)","variable_call_uuid":"66717c2c66232d6e","variable_continue_on_fail":"true","variable_sip_redirect_context":"context_2","variable_hangup_after_bridge":"true","variable_ecallmgr_Call-Interaction-ID":"63910205441-db5e04cf","variable_export_vars":"ecallmgr_Bridge-ID,ecallmgr_Ecallmgr-Node,ringback,transfer_ringback,sip_redirect_context,ecallmgr_Call-Interaction-ID","variable_current_application_data":"{call_timeout=20,originate_timeout=20,outbound_redirect_fatal='false',bridge_export_vars='hold_music',local_var_clobber='true'}[^^!ecallmgr_Username='user_42HqcPrjCA'!ecallmgr_Realm='4f5549.sip.2600hz.com'!presence_id='1001@4f5549.sip.2600hz.com'!origination_callee_id_number='1001'!origination_callee_id_name='Alan Evans2'!ignore_completed_elsewhere='false'!leg_timeout='20'!sip_h_X-KAZOO-AOR='sip:user_42HqcPrjCA@4f5549.sip.2600hz.com'!sip_h_X-KAZOO-INVITE-FORMAT='contact'!ecallmgr_Authorizing-ID='9cabbb2ac44fbb1638218cbe47c83379'!ecallmgr_Authorizing-Type='device'!ecallmgr_Owner-ID='b96758fb45467d8555f42735cc5b39b3'!ecallmgr_Account-ID='47459457c634aff90b96f6af8a8eebb6'!sdp_secure_savp_only='false'!sip_invite_domain='4f5549.sip.2600hz.com'!absolute_codec_string='^^:PCMA:PCMU'!effective_callee_id_number='1001'!effective_callee_id_name='Alan Evans2']sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com;fs_path=sip:10.1.1.14:5060","variable_current_application":"bridge","variable_originated_legs":"338d3557-e3b7-4bd2-b253-81c905d474cd;Alan Evans2;1001","variable_rtp_use_codec_string":"OPUS,VP8,H263,H264,G7221@32000h,G7221@16000h,G722,PCMU,PCMA,G729,GSM,Speex","variable_remote_video_media_flow":"inactive","variable_remote_text_media_flow":"inactive","variable_remote_audio_media_flow":"sendrecv","variable_rtp_audio_recv_pt":"0","variable_rtp_use_codec_name":"PCMU","variable_rtp_use_codec_rate":"8000","variable_rtp_use_codec_ptime":"20","variable_rtp_use_codec_channels":"1","variable_rtp_last_audio_codec_string":"PCMU@8000h@20i@1c","variable_original_read_codec":"PCMU","variable_original_read_rate":"8000","variable_write_codec":"PCMU","variable_write_rate":"8000","variable_dtmf_type":"rfc2833","variable_local_media_ip":"10.1.1.14","variable_local_media_port":"19364","variable_advertised_media_ip":"10.1.1.14","variable_rtp_use_timer_name":"soft","variable_rtp_use_pt":"0","variable_rtp_use_ssrc":"266932313","variable_rtp_2833_send_payload":"101","variable_rtp_2833_recv_payload":"101","variable_remote_media_ip":"10.1.1.31","variable_remote_media_port":"1690","variable_switch_m_sdp":"v=0\r\no=- 1263800803 855048506 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 14540 RTP/AVP 8 0 101\r\nb=AS:125\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","variable_video_media_flow":"inactive","variable_text_media_flow":"inactive","variable_audio_media_flow":"sendrecv","variable_read_codec":"PCMU","variable_read_rate":"8000","variable_rtp_local_sdp_str":"v=0\r\no=FreeSWITCH 1742966878 1742966880 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 19364 RTP/AVP 0 101\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=ptime:20\r\na=sendrecv\r\n","variable_endpoint_disposition":"ANSWER","variable_originate_disposition":"SUCCESS","variable_DIALSTATUS":"SUCCESS","variable_originate_causes":"338d3557-e3b7-4bd2-b253-81c905d474cd;NONE","variable_bridge_export_vars":"hold_music","variable_hold_music":"local_stream://default","variable_last_bridge_to":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_bridge_channel":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","variable_bridge_uuid":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_signal_bond":"338d3557-e3b7-4bd2-b253-81c905d474cd","variable_sip_to_tag":"B7pjeDUNXS19p","variable_sip_from_tag":"2628444714184456","variable_sip_cseq":"4471","variable_sip_call_id":"66717c2c66232d6e","variable_sip_full_via":"SIP/2.0/UDP 10.1.1.14;branch=z9hG4bK6eab.49742e84f19c2e621fc410e4d3f0c36c.0,SIP/2.0/UDP 10.1.1.31:54730;received=10.1.1.31;branch=z9hG4bK796c7c5c4b322df1;rport=54730","variable_sip_full_from":"<sip:user_p48egZdPh4@4f5549.sip.2600hz.com>;tag=2628444714184456","variable_sip_full_to":"<sip:1001@4f5549.sip.2600hz.com>;tag=B7pjeDUNXS19p","variable_last_sent_callee_id_name":"Alan Evans2","variable_last_sent_callee_id_number":"1001","variable_sip_hangup_phrase":"OK","variable_last_bridge_hangup_cause":"NORMAL_CLEARING","variable_last_bridge_proto_specific_hangup_cause":"sip:200","variable_bridge_hangup_cause":"NORMAL_CLEARING","variable_hangup_cause":"NORMAL_CLEARING","variable_hangup_cause_q850":"16","variable_digits_dialed":"none","variable_start_stamp":"2025-03-26 10:50:41","variable_profile_start_stamp":"2025-03-26 10:50:41","variable_answer_stamp":"2025-03-26 10:50:43","variable_bridge_stamp":"2025-03-26 10:50:43","variable_progress_stamp":"2025-03-26 10:50:41","variable_progress_media_stamp":"2025-03-26 10:50:42","variable_end_stamp":"2025-03-26 10:50:46","variable_start_epoch":"1742986241","variable_start_uepoch":"1742986241847058","variable_profile_start_epoch":"1742986241","variable_profile_start_uepoch":"1742986241847058","variable_answer_epoch":"1742986243","variable_answer_uepoch":"1742986243287232","variable_bridge_epoch":"1742986243","variable_bridge_uepoch":"1742986243287232","variable_last_hold_epoch":"0","variable_last_hold_uepoch":"0","variable_hold_accum_seconds":"0","variable_hold_accum_usec":"0","variable_hold_accum_ms":"0","variable_resurrect_epoch":"0","variable_resurrect_uepoch":"0","variable_progress_epoch":"1742986241","variable_progress_uepoch":"1742986241987059","variable_progress_media_epoch":"1742986242","variable_progress_media_uepoch":"1742986242007088","variable_end_epoch":"1742986246","variable_end_uepoch":"1742986246687088","variable_last_app":"bridge","variable_last_arg":"{call_timeout=20,originate_timeout=20,outbound_redirect_fatal='false',bridge_export_vars='hold_music',local_var_clobber='true'}[^^!ecallmgr_Username='user_42HqcPrjCA'!ecallmgr_Realm='4f5549.sip.2600hz.com'!presence_id='1001@4f5549.sip.2600hz.com'!origination_callee_id_number='1001'!origination_callee_id_name='Alan Evans2'!ignore_completed_elsewhere='false'!leg_timeout='20'!sip_h_X-KAZOO-AOR='sip:user_42HqcPrjCA@4f5549.sip.2600hz.com'!sip_h_X-KAZOO-INVITE-FORMAT='contact'!ecallmgr_Authorizing-ID='9cabbb2ac44fbb1638218cbe47c83379'!ecallmgr_Authorizing-Type='device'!ecallmgr_Owner-ID='b96758fb45467d8555f42735cc5b39b3'!ecallmgr_Account-ID='47459457c634aff90b96f6af8a8eebb6'!sdp_secure_savp_only='false'!sip_invite_domain='4f5549.sip.2600hz.com'!absolute_codec_string='^^:PCMA:PCMU'!effective_callee_id_number='1001'!effective_callee_id_name='Alan Evans2']sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com;fs_path=sip:10.1.1.14:5060","variable_caller_id":"\"Alan Evans\" <1000>","variable_duration":"5","variable_billsec":"3","variable_progresssec":"0","variable_answersec":"2","variable_waitsec":"2","variable_progress_mediasec":"1","variable_flow_billsec":"5","variable_mduration":"4840","variable_billmsec":"3400","variable_progressmsec":"140","variable_answermsec":"1440","variable_waitmsec":"1440","variable_progress_mediamsec":"160","variable_flow_billmsec":"4840","variable_uduration":"4840030","variable_billusec":"3399856","variable_progressusec":"140001","variable_answerusec":"1440174","variable_waitusec":"1440174","variable_progress_mediausec":"160030","variable_flow_billusec":"4840030","variable_sip_hangup_disposition":"send_bye","variable_rtp_audio_in_raw_bytes":"39044","variable_rtp_audio_in_media_bytes":"38700","variable_rtp_audio_in_packet_count":"227","variable_rtp_audio_in_media_packet_count":"225","variable_rtp_audio_in_skip_packet_count":"9","variable_rtp_audio_in_jitter_packet_count":"0","variable_rtp_audio_in_dtmf_packet_count":"0","variable_rtp_audio_in_cng_packet_count":"0","variable_rtp_audio_in_flush_packet_count":"2","variable_rtp_audio_in_largest_jb_size":"0","variable_rtp_audio_in_jitter_min_variance":"28.55","variable_rtp_audio_in_jitter_max_variance":"408.33","variable_rtp_audio_in_jitter_loss_rate":"0.00","variable_rtp_audio_in_jitter_burst_rate":"0.00","variable_rtp_audio_in_mean_interval":"20.00","variable_rtp_audio_in_flaw_total":"0","variable_rtp_audio_in_quality_percentage":"100.00","variable_rtp_audio_in_mos":"4.50","variable_rtp_audio_out_raw_bytes":"39044","variable_rtp_audio_out_media_bytes":"39044","variable_rtp_audio_out_packet_count":"227","variable_rtp_audio_out_media_packet_count":"227","variable_rtp_audio_out_skip_packet_count":"0","variable_rtp_audio_out_dtmf_packet_count":"0","variable_rtp_audio_out_cng_packet_count":"0","variable_rtp_audio_rtcp_packet_count":"0","variable_rtp_audio_rtcp_octet_count":"0","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com"}

================================================================================
2025-03-26T10:50:46.724+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      74
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_DESTROY.338d3557-e3b7-4bd2-b253-81c905d474cd">>]
Routed queues: [<<"cdr_listener">>,<<"hangups_listener">>,
                <<"kazoo_apps@debian12-kazoo.kageds.com-cf_listener-<0.1847.0>-32c81897">>,
                <<"webhooks_shared_listener">>]
Properties:   [{<<"timestamp">>,signedint,63910205446709246},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","To-Uri":"user_42HqcPrjCA@4f5549.sip.2600hz.com","To-Tag":"09ca759f6a08420a","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Ringing-Seconds":1,"Request":"user_42HqcPrjCA@4f5549.sip.2600hz.com","Remote-SDP":"v=0\r\no=- 1263800803 855048506 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 14540 RTP/AVP 8 0 101\r\nb=AS:125\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","Presence-ID":"1001@4f5549.sip.2600hz.com","Other-Leg-Direction":"inbound","Other-Leg-Destination-Number":"1001","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"66717c2c66232d6e","Media-Server":"debian12-kazoo","Local-SDP":"v=0\r\no=FreeSWITCH 1742959223 1742959224 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 27018 RTP/AVP 8 0 101 13\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=rtpmap:13 CN/8000\r\na=ptime:20\r\na=sendrecv\r\n","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Uri":"1000@4f5549.sip.2600hz.com","From-Tag":"cggBg8BSt2Qvj","From":"1000@4f5549.sip.2600hz.com","Duration-Seconds":5,"Disposition":"ANSWER","Custom-SIP-Headers":{"X-KAZOO-INVITE-FORMAT":"contact","X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Global-Resource":"false","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Realm":"4f5549.sip.2600hz.com","Username":"user_42HqcPrjCA"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241947047,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"outbound","Billing-Seconds":4,"Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"CHANNEL_DESTROY","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.726+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      223
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_DESTROY.338d3557-e3b7-4bd2-b253-81c905d474cd">>]
Queue:        webhooks_shared_listener
Properties:   [{<<"timestamp">>,signedint,63910205446709246},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","To-Uri":"user_42HqcPrjCA@4f5549.sip.2600hz.com","To-Tag":"09ca759f6a08420a","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Ringing-Seconds":1,"Request":"user_42HqcPrjCA@4f5549.sip.2600hz.com","Remote-SDP":"v=0\r\no=- 1263800803 855048506 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 14540 RTP/AVP 8 0 101\r\nb=AS:125\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","Presence-ID":"1001@4f5549.sip.2600hz.com","Other-Leg-Direction":"inbound","Other-Leg-Destination-Number":"1001","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"66717c2c66232d6e","Media-Server":"debian12-kazoo","Local-SDP":"v=0\r\no=FreeSWITCH 1742959223 1742959224 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 27018 RTP/AVP 8 0 101 13\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=rtpmap:13 CN/8000\r\na=ptime:20\r\na=sendrecv\r\n","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Uri":"1000@4f5549.sip.2600hz.com","From-Tag":"cggBg8BSt2Qvj","From":"1000@4f5549.sip.2600hz.com","Duration-Seconds":5,"Disposition":"ANSWER","Custom-SIP-Headers":{"X-KAZOO-INVITE-FORMAT":"contact","X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Global-Resource":"false","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Realm":"4f5549.sip.2600hz.com","Username":"user_42HqcPrjCA"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241947047,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"outbound","Billing-Seconds":4,"Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"CHANNEL_DESTROY","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.726+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      204
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_DESTROY.338d3557-e3b7-4bd2-b253-81c905d474cd">>]
Queue:        hangups_listener
Properties:   [{<<"timestamp">>,signedint,63910205446709246},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","To-Uri":"user_42HqcPrjCA@4f5549.sip.2600hz.com","To-Tag":"09ca759f6a08420a","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Ringing-Seconds":1,"Request":"user_42HqcPrjCA@4f5549.sip.2600hz.com","Remote-SDP":"v=0\r\no=- 1263800803 855048506 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 14540 RTP/AVP 8 0 101\r\nb=AS:125\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","Presence-ID":"1001@4f5549.sip.2600hz.com","Other-Leg-Direction":"inbound","Other-Leg-Destination-Number":"1001","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"66717c2c66232d6e","Media-Server":"debian12-kazoo","Local-SDP":"v=0\r\no=FreeSWITCH 1742959223 1742959224 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 27018 RTP/AVP 8 0 101 13\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=rtpmap:13 CN/8000\r\na=ptime:20\r\na=sendrecv\r\n","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Uri":"1000@4f5549.sip.2600hz.com","From-Tag":"cggBg8BSt2Qvj","From":"1000@4f5549.sip.2600hz.com","Duration-Seconds":5,"Disposition":"ANSWER","Custom-SIP-Headers":{"X-KAZOO-INVITE-FORMAT":"contact","X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Global-Resource":"false","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Realm":"4f5549.sip.2600hz.com","Username":"user_42HqcPrjCA"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241947047,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"outbound","Billing-Seconds":4,"Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"CHANNEL_DESTROY","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.727+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      183
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_DESTROY.338d3557-e3b7-4bd2-b253-81c905d474cd">>]
Queue:        cdr_listener
Properties:   [{<<"timestamp">>,signedint,63910205446709246},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","To-Uri":"user_42HqcPrjCA@4f5549.sip.2600hz.com","To-Tag":"09ca759f6a08420a","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Ringing-Seconds":1,"Request":"user_42HqcPrjCA@4f5549.sip.2600hz.com","Remote-SDP":"v=0\r\no=- 1263800803 855048506 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 14540 RTP/AVP 8 0 101\r\nb=AS:125\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","Presence-ID":"1001@4f5549.sip.2600hz.com","Other-Leg-Direction":"inbound","Other-Leg-Destination-Number":"1001","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"66717c2c66232d6e","Media-Server":"debian12-kazoo","Local-SDP":"v=0\r\no=FreeSWITCH 1742959223 1742959224 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 27018 RTP/AVP 8 0 101 13\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=rtpmap:13 CN/8000\r\na=ptime:20\r\na=sendrecv\r\n","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Uri":"1000@4f5549.sip.2600hz.com","From-Tag":"cggBg8BSt2Qvj","From":"1000@4f5549.sip.2600hz.com","Duration-Seconds":5,"Disposition":"ANSWER","Custom-SIP-Headers":{"X-KAZOO-INVITE-FORMAT":"contact","X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Global-Resource":"false","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Realm":"4f5549.sip.2600hz.com","Username":"user_42HqcPrjCA"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241947047,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"outbound","Billing-Seconds":4,"Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"CHANNEL_DESTROY","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.727+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      182
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_DESTROY.338d3557-e3b7-4bd2-b253-81c905d474cd">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-cf_listener-<0.1847.0>-32c81897
Properties:   [{<<"timestamp">>,signedint,63910205446709246},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","To-Uri":"user_42HqcPrjCA@4f5549.sip.2600hz.com","To-Tag":"09ca759f6a08420a","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Ringing-Seconds":1,"Request":"user_42HqcPrjCA@4f5549.sip.2600hz.com","Remote-SDP":"v=0\r\no=- 1263800803 855048506 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 14540 RTP/AVP 8 0 101\r\nb=AS:125\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","Presence-ID":"1001@4f5549.sip.2600hz.com","Other-Leg-Direction":"inbound","Other-Leg-Destination-Number":"1001","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"66717c2c66232d6e","Media-Server":"debian12-kazoo","Local-SDP":"v=0\r\no=FreeSWITCH 1742959223 1742959224 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 27018 RTP/AVP 8 0 101 13\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=rtpmap:13 CN/8000\r\na=ptime:20\r\na=sendrecv\r\n","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Uri":"1000@4f5549.sip.2600hz.com","From-Tag":"cggBg8BSt2Qvj","From":"1000@4f5549.sip.2600hz.com","Duration-Seconds":5,"Disposition":"ANSWER","Custom-SIP-Headers":{"X-KAZOO-INVITE-FORMAT":"contact","X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Global-Resource":"false","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Realm":"4f5549.sip.2600hz.com","Username":"user_42HqcPrjCA"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241947047,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"outbound","Billing-Seconds":4,"Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"CHANNEL_DESTROY","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.727+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      75
Exchange:     callevt
Routing keys: [<<"call.LEG_DESTROYED.66717c2c66232d6e">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33">>]
Properties:   [{<<"timestamp">>,signedint,63910205446706653},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"To-Tag":"09ca759f6a08420a","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Presence-ID":"1001@4f5549.sip.2600hz.com","Other-Leg-Direction":"outbound","Other-Leg-Destination-Number":"user_42HqcPrjCA","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Media-Server":"debian12-kazoo","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Tag":"cggBg8BSt2Qvj","Disposition":"ANSWER","Custom-SIP-Headers":{"X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com","X-KAZOO-INVITE-FORMAT":"contact"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Global-Resource":"false","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Realm":"4f5549.sip.2600hz.com","Username":"user_42HqcPrjCA"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Channel-Created-Time":0,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"outbound","Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"LEG_DESTROYED","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.733+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      229
Exchange:     callevt
Routing keys: [<<"call.LEG_DESTROYED.66717c2c66232d6e">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33
Properties:   [{<<"timestamp">>,signedint,63910205446706653},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"To-Tag":"09ca759f6a08420a","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Presence-ID":"1001@4f5549.sip.2600hz.com","Other-Leg-Direction":"outbound","Other-Leg-Destination-Number":"user_42HqcPrjCA","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Media-Server":"debian12-kazoo","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Tag":"cggBg8BSt2Qvj","Disposition":"ANSWER","Custom-SIP-Headers":{"X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com","X-KAZOO-INVITE-FORMAT":"contact"},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Global-Resource":"false","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Realm":"4f5549.sip.2600hz.com","Username":"user_42HqcPrjCA"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_42HqcPrjCA@4f5549.sip.2600hz.com","Channel-Created-Time":0,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"outbound","Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"LEG_DESTROYED","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.741+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      73
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_DESTROY.66717c2c66232d6e">>]
Routed queues: [<<"cdr_listener">>,<<"hangups_listener">>,
                <<"kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33">>,
                <<"kazoo_apps@debian12-kazoo.kageds.com-cf_listener-<0.1847.0>-32c81897">>,
                <<"webhooks_shared_listener">>]
Properties:   [{<<"timestamp">>,signedint,63910205446728103},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","To-Uri":"1001@4f5549.sip.2600hz.com","To-Tag":"B7pjeDUNXS19p","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Ringing-Seconds":1,"Request":"1001@4f5549.sip.2600hz.com","Remote-SDP":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","Presence-ID":"1000@4f5549.sip.2600hz.com","Other-Leg-Direction":"outbound","Other-Leg-Destination-Number":"user_42HqcPrjCA","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Media-Server":"debian12-kazoo","Local-SDP":"v=0\r\no=FreeSWITCH 1742966878 1742966880 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 19364 RTP/AVP 0 101\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=ptime:20\r\na=sendrecv\r\n","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","From-Tag":"2628444714184456","From":"1000@4f5549.sip.2600hz.com","Duration-Seconds":5,"Disposition":"SUCCESS","Custom-SIP-Headers":{},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Application-Name":"callflow","Application-Node":"kazoo_apps@debian12-kazoo.kageds.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","CallFlow-ID":"7c7290c92292369eb0737a157b8169be","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Privacy-Hide-Name":"false","Privacy-Hide-Number":"false","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241847058,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"inbound","Billing-Seconds":4,"Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"CHANNEL_DESTROY","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.741+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      223
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_DESTROY.66717c2c66232d6e">>]
Queue:        webhooks_shared_listener
Properties:   [{<<"timestamp">>,signedint,63910205446728103},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","To-Uri":"1001@4f5549.sip.2600hz.com","To-Tag":"B7pjeDUNXS19p","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Ringing-Seconds":1,"Request":"1001@4f5549.sip.2600hz.com","Remote-SDP":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","Presence-ID":"1000@4f5549.sip.2600hz.com","Other-Leg-Direction":"outbound","Other-Leg-Destination-Number":"user_42HqcPrjCA","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Media-Server":"debian12-kazoo","Local-SDP":"v=0\r\no=FreeSWITCH 1742966878 1742966880 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 19364 RTP/AVP 0 101\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=ptime:20\r\na=sendrecv\r\n","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","From-Tag":"2628444714184456","From":"1000@4f5549.sip.2600hz.com","Duration-Seconds":5,"Disposition":"SUCCESS","Custom-SIP-Headers":{},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Application-Name":"callflow","Application-Node":"kazoo_apps@debian12-kazoo.kageds.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","CallFlow-ID":"7c7290c92292369eb0737a157b8169be","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Privacy-Hide-Name":"false","Privacy-Hide-Number":"false","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241847058,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"inbound","Billing-Seconds":4,"Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"CHANNEL_DESTROY","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.741+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      229
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_DESTROY.66717c2c66232d6e">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33
Properties:   [{<<"timestamp">>,signedint,63910205446728103},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","To-Uri":"1001@4f5549.sip.2600hz.com","To-Tag":"B7pjeDUNXS19p","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Ringing-Seconds":1,"Request":"1001@4f5549.sip.2600hz.com","Remote-SDP":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","Presence-ID":"1000@4f5549.sip.2600hz.com","Other-Leg-Direction":"outbound","Other-Leg-Destination-Number":"user_42HqcPrjCA","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Media-Server":"debian12-kazoo","Local-SDP":"v=0\r\no=FreeSWITCH 1742966878 1742966880 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 19364 RTP/AVP 0 101\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=ptime:20\r\na=sendrecv\r\n","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","From-Tag":"2628444714184456","From":"1000@4f5549.sip.2600hz.com","Duration-Seconds":5,"Disposition":"SUCCESS","Custom-SIP-Headers":{},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Application-Name":"callflow","Application-Node":"kazoo_apps@debian12-kazoo.kageds.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","CallFlow-ID":"7c7290c92292369eb0737a157b8169be","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Privacy-Hide-Name":"false","Privacy-Hide-Number":"false","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241847058,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"inbound","Billing-Seconds":4,"Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"CHANNEL_DESTROY","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.741+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      204
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_DESTROY.66717c2c66232d6e">>]
Queue:        hangups_listener
Properties:   [{<<"timestamp">>,signedint,63910205446728103},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","To-Uri":"1001@4f5549.sip.2600hz.com","To-Tag":"B7pjeDUNXS19p","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Ringing-Seconds":1,"Request":"1001@4f5549.sip.2600hz.com","Remote-SDP":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","Presence-ID":"1000@4f5549.sip.2600hz.com","Other-Leg-Direction":"outbound","Other-Leg-Destination-Number":"user_42HqcPrjCA","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Media-Server":"debian12-kazoo","Local-SDP":"v=0\r\no=FreeSWITCH 1742966878 1742966880 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 19364 RTP/AVP 0 101\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=ptime:20\r\na=sendrecv\r\n","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","From-Tag":"2628444714184456","From":"1000@4f5549.sip.2600hz.com","Duration-Seconds":5,"Disposition":"SUCCESS","Custom-SIP-Headers":{},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Application-Name":"callflow","Application-Node":"kazoo_apps@debian12-kazoo.kageds.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","CallFlow-ID":"7c7290c92292369eb0737a157b8169be","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Privacy-Hide-Name":"false","Privacy-Hide-Number":"false","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241847058,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"inbound","Billing-Seconds":4,"Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"CHANNEL_DESTROY","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.742+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      183
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_DESTROY.66717c2c66232d6e">>]
Queue:        cdr_listener
Properties:   [{<<"timestamp">>,signedint,63910205446728103},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","To-Uri":"1001@4f5549.sip.2600hz.com","To-Tag":"B7pjeDUNXS19p","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Ringing-Seconds":1,"Request":"1001@4f5549.sip.2600hz.com","Remote-SDP":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","Presence-ID":"1000@4f5549.sip.2600hz.com","Other-Leg-Direction":"outbound","Other-Leg-Destination-Number":"user_42HqcPrjCA","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Media-Server":"debian12-kazoo","Local-SDP":"v=0\r\no=FreeSWITCH 1742966878 1742966880 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 19364 RTP/AVP 0 101\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=ptime:20\r\na=sendrecv\r\n","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","From-Tag":"2628444714184456","From":"1000@4f5549.sip.2600hz.com","Duration-Seconds":5,"Disposition":"SUCCESS","Custom-SIP-Headers":{},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Application-Name":"callflow","Application-Node":"kazoo_apps@debian12-kazoo.kageds.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","CallFlow-ID":"7c7290c92292369eb0737a157b8169be","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Privacy-Hide-Name":"false","Privacy-Hide-Number":"false","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241847058,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"inbound","Billing-Seconds":4,"Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"CHANNEL_DESTROY","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.742+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      228
Exchange:     callevt
Routing keys: [<<"call.dialplan.66717c2c66232d6e">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33">>]
Properties:   [{<<"timestamp">>,signedint,63910205446737442},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","Disposition":"SUCCESS","Call-ID":"66717c2c66232d6e","Request":{"Export-Bridge-Variables":["hold_music"],"Timeout":20,"Ignore-Forward":"false","Dial-Endpoint-Method":"simultaneous","Endpoints":[{"To-Username":"user_42HqcPrjCA","To-User":"user_42HqcPrjCA","To-Realm":"4f5549.sip.2600hz.com","To-DID":"1001","Presence-ID":"1001@4f5549.sip.2600hz.com","Privacy-Method":"kazoo","Outbound-Callee-ID-Number":"1001","Outbound-Callee-ID-Name":"Alan Evans2","Ignore-Completed-Elsewhere":false,"Endpoint-Timeout":"20","Custom-SIP-Headers":{"X-KAZOO-INVITE-FORMAT":"contact","X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com"},"Custom-Channel-Vars":{"SIP-Invite-Domain":"4f5549.sip.2600hz.com","Media-Encryption-Enforce-Security":false,"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Authorizing-Type":"device","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379"},"Codecs":["PCMA","PCMU"],"Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Invite-Format":"contact"}],"Call-ID":"66717c2c66232d6e","Application-Name":"bridge","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"78f2dfa64bf9d4ca702eb65ac56470ab","Event-Name":"command","Event-Category":"call","App-Version":"4.0.0","App-Name":"callflow"},"Error-Message":"Could not execute dialplan action: bridge","Server-ID":"","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"78f2dfa64bf9d4ca702eb65ac56470ab","Event-Name":"dialplan","Event-Category":"error","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.742+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      229
Exchange:     callevt
Routing keys: [<<"call.dialplan.66717c2c66232d6e">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33
Properties:   [{<<"timestamp">>,signedint,63910205446737442},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","Disposition":"SUCCESS","Call-ID":"66717c2c66232d6e","Request":{"Export-Bridge-Variables":["hold_music"],"Timeout":20,"Ignore-Forward":"false","Dial-Endpoint-Method":"simultaneous","Endpoints":[{"To-Username":"user_42HqcPrjCA","To-User":"user_42HqcPrjCA","To-Realm":"4f5549.sip.2600hz.com","To-DID":"1001","Presence-ID":"1001@4f5549.sip.2600hz.com","Privacy-Method":"kazoo","Outbound-Callee-ID-Number":"1001","Outbound-Callee-ID-Name":"Alan Evans2","Ignore-Completed-Elsewhere":false,"Endpoint-Timeout":"20","Custom-SIP-Headers":{"X-KAZOO-INVITE-FORMAT":"contact","X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com"},"Custom-Channel-Vars":{"SIP-Invite-Domain":"4f5549.sip.2600hz.com","Media-Encryption-Enforce-Security":false,"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Authorizing-Type":"device","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379"},"Codecs":["PCMA","PCMU"],"Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Invite-Format":"contact"}],"Call-ID":"66717c2c66232d6e","Application-Name":"bridge","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"78f2dfa64bf9d4ca702eb65ac56470ab","Event-Name":"command","Event-Category":"call","App-Version":"4.0.0","App-Name":"callflow"},"Error-Message":"Could not execute dialplan action: bridge","Server-ID":"","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"78f2dfa64bf9d4ca702eb65ac56470ab","Event-Name":"dialplan","Event-Category":"error","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.742+00:00: Message received

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      182
Exchange:     callevt
Routing keys: [<<"call.CHANNEL_DESTROY.66717c2c66232d6e">>]
Queue:        kazoo_apps@debian12-kazoo.kageds.com-cf_listener-<0.1847.0>-32c81897
Properties:   [{<<"timestamp">>,signedint,63910205446728103},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"User-Agent":"tSIP 0.01.70.00","To-Uri":"1001@4f5549.sip.2600hz.com","To-Tag":"B7pjeDUNXS19p","To":"1001@4f5549.sip.2600hz.com","Timestamp":63910205446,"Switch-URL":"sip:mod_sofia@10.1.1.14:11000","Switch-URI":"sip:10.1.1.14:11000","Switch-Nodename":"freeswitch@debian12-kazoo.kageds.com","Switch-Hostname":"debian12-kazoo","Ringing-Seconds":1,"Request":"1001@4f5549.sip.2600hz.com","Remote-SDP":"v=0\r\no=- 628499421 1920275804 IN IP4 10.1.1.31\r\ns=-\r\nc=IN IP4 10.1.1.31\r\nt=0 0\r\nm=audio 1690 RTP/AVP 0 8 101\r\nb=AS:125\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=label:1\r\na=ptime:20\r\n","Presence-ID":"1000@4f5549.sip.2600hz.com","Other-Leg-Direction":"outbound","Other-Leg-Destination-Number":"user_42HqcPrjCA","Other-Leg-Caller-ID-Number":"1000","Other-Leg-Caller-ID-Name":"Alan Evans","Other-Leg-Call-ID":"338d3557-e3b7-4bd2-b253-81c905d474cd","Media-Server":"debian12-kazoo","Local-SDP":"v=0\r\no=FreeSWITCH 1742966878 1742966880 IN IP4 10.1.1.14\r\ns=FreeSWITCH\r\nc=IN IP4 10.1.1.14\r\nt=0 0\r\nm=audio 19364 RTP/AVP 0 101\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:101 telephone-event/8000\r\na=fmtp:101 0-15\r\na=ptime:20\r\na=sendrecv\r\n","Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","From-Uri":"user_p48egZdPh4@4f5549.sip.2600hz.com","From-Tag":"2628444714184456","From":"1000@4f5549.sip.2600hz.com","Duration-Seconds":5,"Disposition":"SUCCESS","Custom-SIP-Headers":{},"Custom-Channel-Vars":{"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Account-Name":"Kage Design Services Ltd","Account-Realm":"4f5549.sip.2600hz.com","Application-Name":"callflow","Application-Node":"kazoo_apps@debian12-kazoo.kageds.com","Authorizing-ID":"8d604a1881ea0c16e12971622e2a8cac","Authorizing-Type":"device","Bridge-ID":"66717c2c66232d6e","Call-Interaction-ID":"63910205441-db5e04cf","CallFlow-ID":"7c7290c92292369eb0737a157b8169be","Channel-Authorized":"true","Ecallmgr-Node":"kazoo_apps@debian12-kazoo.kageds.com","Fetch-ID":"83efe426-7b44-45f4-be35-5d3d90bea343","Owner-ID":"dbfb28b1de0750b697d26fb61e9ea863","Privacy-Hide-Name":"false","Privacy-Hide-Number":"false","Realm":"4f5549.sip.2600hz.com","Username":"user_p48egzdph4"},"Custom-Application-Vars":{},"Channel-State":"REPORTING","Channel-Name":"sofia/sipinterface_1/user_p48egZdPh4@4f5549.sip.2600hz.com","Channel-Created-Time":1742986241847058,"Channel-Call-State":"HANGUP","Caller-ID-Number":"1000","Caller-ID-Name":"Alan Evans","Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Call-Direction":"inbound","Billing-Seconds":4,"Call-ID":"66717c2c66232d6e","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"1742986246687088","Event-Name":"CHANNEL_DESTROY","Event-Category":"call_event","App-Version":"4.0.0","App-Name":"ecallmgr"}

================================================================================
2025-03-26T10:50:46.767+00:00: Message published

Node:         rabbit@debian12-kazoo
Connection:   127.0.0.1:58078 -> 127.0.0.1:5672
Virtual host: /
User:         guest
Channel:      228
Exchange:     callevt
Routing keys: [<<"call.dialplan.66717c2c66232d6e">>]
Routed queues: [<<"kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33">>]
Properties:   [{<<"timestamp">>,signedint,63910205446753419},
               {<<"content_type">>,longstr,<<"application/json">>}]
Payload: 
{"Hangup-Code":"sip:200","Hangup-Cause":"NORMAL_CLEARING","Disposition":"SUCCESS","Call-ID":"66717c2c66232d6e","Request":{"Export-Bridge-Variables":["hold_music"],"Timeout":20,"Ignore-Forward":"false","Dial-Endpoint-Method":"simultaneous","Endpoints":[{"To-Username":"user_42HqcPrjCA","To-User":"user_42HqcPrjCA","To-Realm":"4f5549.sip.2600hz.com","To-DID":"1001","Presence-ID":"1001@4f5549.sip.2600hz.com","Privacy-Method":"kazoo","Outbound-Callee-ID-Number":"1001","Outbound-Callee-ID-Name":"Alan Evans2","Ignore-Completed-Elsewhere":false,"Endpoint-Timeout":"20","Custom-SIP-Headers":{"X-KAZOO-INVITE-FORMAT":"contact","X-KAZOO-AOR":"sip:user_42HqcPrjCA@4f5549.sip.2600hz.com"},"Custom-Channel-Vars":{"SIP-Invite-Domain":"4f5549.sip.2600hz.com","Media-Encryption-Enforce-Security":false,"Account-ID":"47459457c634aff90b96f6af8a8eebb6","Owner-ID":"b96758fb45467d8555f42735cc5b39b3","Authorizing-Type":"device","Authorizing-ID":"9cabbb2ac44fbb1638218cbe47c83379"},"Codecs":["PCMA","PCMU"],"Callee-ID-Number":"1001","Callee-ID-Name":"Alan Evans2","Invite-Format":"contact"}],"Call-ID":"66717c2c66232d6e","Application-Name":"bridge","Server-ID":"kazoo_apps@debian12-kazoo.kageds.com-cf_exe-<0.3138.0>-a87d5a33","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"78f2dfa64bf9d4ca702eb65ac56470ab","Event-Name":"command","Event-Category":"call","App-Version":"4.0.0","App-Name":"callflow"},"Error-Message":"Could not execute dialplan action: bridge","Server-ID":"","Node":"kazoo_apps@debian12-kazoo.kageds.com","Msg-ID":"78f2dfa64bf9d4ca702eb65ac56470ab","Event-Name":"dialplan","Event-Category":"error","App-Version":"4.0.0","App-Name":"ecallmgr"}
```