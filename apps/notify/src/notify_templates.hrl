-define(NOTIFY_VOICEMAIL_FULL, [
    {'default_text_template', [<<"Your voicemail box '{{voicemail.name}}' is full.">>]},
    {'default_html_template', [
        <<"<html><body><h3>Your voicemail box '{{voicemail.name}}' is full.</h3></body></html>">>
    ]},
    {'default_subject_template', [<<"Voicemail box full">>]},
    {'default_support_number', [<<"(415) 886-7950">>]},
    {'default_support_email', [<<"support@2600hz.org">>]}
]).

-define(NOTIFY_VOICEMAIL_TO_EMAIL, [
    {'default_text_template', [
        <<"New Voicemail Message\n\nCaller ID: {{voicemail.caller_id_number}}\nCaller Name: {{voicemail.caller_id_name}}\n\nCalled To: {{voicemail.to_user}}   (Originally dialed number)\nCalled On: {{voicemail.date_called|date:\"l, F j, Y \\a\\t H:i\"}}\n\nTranscription: {{voicemail.transcription|default:\"Not Enabled\"}}\n\n\nFor help or questions using your phone or voicemail, please contact support at {{service.support_number}} or email {{service.support_email}}.">>
    ]},
    {'default_html_template', [
        <<"<html><body><h3>New Voicemail Message</h3><table><tr><td>Caller ID</td><td>{{voicemail.caller_id_name}} ({{voicemail.caller_id_number}})</td></tr><tr><td>Callee ID</td><td>{{voicemail.to_user}} (originally dialed number)</td></tr><tr><td>Call received</td><td>{{voicemail.date_called|date:\"l, F j, Y \\a\\t H:i\"}}</td></tr></table><p>For help or questions using your phone or voicemail, please contact {{service.support_number}} or email <a href=\"mailto:{{service.support_email}}\">Support</a></p><p style=\"font-size: 9px;color:#C0C0C0\">{{voicemail.call_id}}</p><p>Transcription: {{voicemail.transcription|default:\"Not Enabled\"}}</p></body></html>">>
    ]},
    {'default_subject_template', [
        <<"New voicemail from {{voicemail.caller_id_name}} ({{voicemail.caller_id_number}})">>
    ]},
    {'default_support_number', [<<"(415) 886-7950">>]},
    {'default_support_email', [<<"support@2600hz.org">>]}
]).

-define(NOTIFY_TRANSACTION, [
    {'default_text_template', [
        <<"{% if transaction %}Transaction\n{% for key, value in transaction %}{{ key }}: {{ value }}\n{% endfor %}\n{% endif %}{% if plan %}Service Plan\nID: {{plan.id}}\nCategory: {{plan.category}}\nItem: {{plan.item}}\nActivation-Charge: {{plan.activation_charge}}\n\n{% endif %}Account\nAccount ID: {{account.pvt_account_id}}\nAccount Name: {{account.name}}\nAccount Realm: {{account.realm}}\n\nService\nURL: {{service.url}}\nName: {{service.name}}\nService Provider: {{service.provider}}\n\nSent from {{service.host}}">>
    ]},
    {'default_html_template', [
        <<"<html><head><meta charset=\"utf-8\" /></head><body>{% if transaction %}<h2>Transaction</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\">{% for key, value in transaction %}<tr><td>{{ key }}: </td><td>{{ value }}</td></tr>{% endfor %}</table>{% endif %}{% if plan %}<h2>Service Plan</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>ID: </td><td>{{plan.id}}</td></tr><tr><td>Category: </td><td>{{plan.category}}</td></tr><tr><td>Item: </td><td>{{plan.item}}</td></tr><tr><td>Activation-Charge: </td><td>{{plan.activation_charge}}</td></tr></table>{% endif %}<h2>Account</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Account ID: </td><td>{{account.pvt_account_id}}</td></tr><tr><td>Account Name: </td><td>{{account.name}}</td></tr><tr><td>Account Realm: </td><td>{{account.realm}}</td></tr></table><h2>Service</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>URL: </td><td>{{service.url}}</td></tr><tr><td>Name: </td><td>{{service.name}}</td></tr><tr><td>Service Provider: </td><td>{{service.provider}}</td></tr></table><p style=\"font-size:9pt;color:#CCCCCC\">Sent from {{service.host}}</p></body></html>">>
    ]},
    {'default_subject_template', [
        <<"KAZOO: transaction notice for {{account.name}} - ${{transaction.amount}} (ID #{{account.pvt_account_id}})">>
    ]}
]).

-define(NOTIFY_TOPUP, [
    {'default_text_template', [
        <<"The account \"{{account.name}}\" has less than {{threshold}} of credit remaining.\n We are toping up the account for {{amount}}.">>
    ]},
    {'default_html_template', [
        <<"<html><body><h2>The account \"{{account.name}}\" has less than {{threshold}} of credit remaining.</h2><p> We are toping up the account for {{amount}}.</p></body></html>">>
    ]},
    {'default_subject_template', [<<"Account {{account.name}} has been top up">>]}
]).

-define(NOTIFY_SYSTEM_ALERT, [
    {'default_text_template', [
        <<"Alert\n{{message}}\n\nProducer:\n{% for key, value in request %}{{ key }}: {{ value }}\n{% endfor %}\n{% if details %}Details\n{% for key, value in details %}{{ key }}: {{ value }}\n{% endfor %}\n{% endif %}{% if account %}Account\nAccount ID: {{account.pvt_account_id}}\nAccount Name: {{account.name}}\nAccount Realm: {{account.realm}}\n\n{% endif %}{% if admin %}Admin\nName: {{admin.first_name}} {{admin.last_name}}\nEmail: {{admin.email}}\nTimezone: {{admin.timezone}}\n\n{% endif %}{% if account.pvt_wnm_numbers %}Phone Numbers\n{% for number in account.pvt_wnm_numbers %}{{number}}\n{% endfor %}\n{% endif %}Service\nURL: {{service.url}}\nName: {{service.name}}\nService Provider: {{service.provider}}\n\nSent from {{service.host}}">>
    ]},
    {'default_html_template', [
        <<"<html><head><meta charset=\"utf-8\" /></head><body><h2>Alert</h2><p>{{message}}</p><h2>Producer</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\">{% for key, value in request %}<tr><td>{{ key }}: </td><td>{{ value }}</td></tr>{% endfor %}</table>{% if details %}<h2>Details</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\">{% for key, value in details %}<tr><td>{{ key }}: </td><td>{{ value }}</td></tr>{% endfor %}</table>{% endif %}{% if account %}<h2>Account</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Account ID: </td><td>{{account.pvt_account_id}}</td></tr><tr><td>Account Name: </td><td>{{account.name}}</td></tr><tr><td>Account Realm: </td><td>{{account.realm}}</td></tr></table>{% endif %}{% if admin %}<h2>Admin</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Name: </td><td>{{admin.first_name}} {{admin.last_name}}</td></tr><tr><td>Email: </td><td>{{admin.email}}</td></tr><tr><td>Timezone: </td><td>{{admin.timezone}}</td></tr></table>{% endif %}{% if account.pvt_wnm_numbers %}<h2>Phone Numbers</h2><ul>{% for number in account.pvt_wnm_numbers %}<li>{{number}}</li>{% endfor %}</ul>{% endif %}<h2>Service</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>URL: </td><td>{{service.url}}</td></tr><tr><td>Name: </td><td>{{service.name}}</td></tr><tr><td>Service Provider: </td><td>{{service.provider}}</td></tr></table><p style=\"font-size:9pt;color:#CCCCCC\">Sent from {{service.host}}</p></body></html>">>
    ]},
    {'default_subject_template', [<<"2600hz-Platform: {{request.level}} from {{request.node}}">>]}
]).

-define(NOTIFY_PORTED, [
    {'default_text_template', [
        <<"Number {{request.number}} port completedr\n\nRequest\nService Provider: {{request.port.service_provider}}\n\nBilling Name: {{request.port.billing_name}}\nBilling Account ID: {{request.port.billing_account_id}}\nBilling Street Address: {{request.port.billing_street_address}}\nBilling Extended Address: {{request.port.billing_extended_address}}\nBilling Locality: {{request.port.billing_locality}}\nBilling Postal Code: {{request.port.billing_postal_code}}\nBilling Telephone Number(BTN): {{request.port.billing_telephone_number}}\nRequested Port Date: {{request.port.requested_port_date}}\nCustomer Contact: {{request.port.customer_contact}}\n\nNumber\nNumber: {{request.number}}\nState: {{request.number_state}}\nLocal-Number: {{request.local_number}}\n\nAccount\nAccount ID: {{account.pvt_account_id}}\nAccount Name: {{account.name}}\nAccount Realm: {{account.realm}}\n\n{% if admin %}Admin\nFirst Name: {{admin.first_name}}\nLast Name: {{admin.last_name}}\nEmail: {{admin.email}}\nTimezone: {{admin.timezone}}\n\n{% endif %}{% if devices %}SIP Credentials\n{% for device in devices %}User: {{device.user.first_name}} {{device.user.last_name}}\nEmail: {{device.user.email|default:\"\"}}\nSIP Username: {{device.sip.username}}\nSIP Password: {{device.sip.password}}\nSIP Realm: {{account.realm}}\n\n{% endfor %}{% endif %}{% if account.pvt_wnm_numbers %}Phone Numbers\n{% for number in account.pvt_wnm_numbers %}{{number}}\n{% endfor %}\n{% endif %}Service\nURL: {{service.url}}\nName: {{service.name}}\nProvider: {{service.provider}}\n\nSent from {{service.host}}">>
    ]},
    {'default_html_template', [
        <<"<html><head><meta charset=\"utf-8\" /></head><body><h3>Number {{request.number}} port complete</h3><h2>Request</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Service Provider: </td><td>{{request.port.service_provider}}</td></tr><tr><td>Billing Name: </td><td>{{request.port.billing_name}}</td></tr><tr><td>Billing Account ID: </td><td>{{request.port.billing_account_id}}</td></tr><tr><td>Billing Street Address: </td><td>{{request.port.billing_street_address}}</td></tr><tr><td>Billing Extended Address: </td><td>{{request.port.billing_extended_address}}</td></tr><tr><td>Billing Locality: </td><td>{{request.port.billing_locality}}</td></tr><tr><td>Billing Postal Code: </td><td>{{request.port.billing_postal_code}}</td></tr><tr><td>Billing Telephone Number(BTN): </td><td>{{request.port.billing_telephone_number}}</td></tr><tr><td>Requested Port Date: </td><td>{{request.port.requested_port_date}}</td></tr><tr><td>Customer Contact: </td><td>{{request.port.customer_contact}}</td></tr></table><h2>Number</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Number: </td><td>{{request.number}}</td></tr><tr><td>State: </td><td>{{request.number_state}}</td></tr><tr><td>Local-Number: </td><td>{{request.local_number}}</td></tr></table><h2>Account</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Account ID: </td><td>{{account.pvt_account_id}}</td></tr><tr><td>Account Name: </td><td>{{account.name}}</td></tr><tr><td>Account Realm: </td><td>{{account.realm}}</td></tr></table>{% if admin %}<h2>Admin</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Name: </td><td>{{admin.first_name}} {{admin.last_name}}</td></tr><tr><td>Email: </td><td>{{admin.email}}</td></tr><tr><td>Timezone: </td><td>{{admin.timezone}}</td></tr></table>{% endif %}{% if devices %}<h2>SIP Credentials</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"1\"><tr><th>User</th><th>Email</th><th>SIP Username</th><th>SIP Password</th><th>SIP Realm</th></tr>{% for device in devices %}<tr><td>{{device.user.first_name}}{{device.user.last_name}}</td><td>{{device.user.email|default:\"\"}}</td><td>{{device.sip.username}}</td><td>{{device.sip.password}}</td><td>{{account.realm}}</td></tr>{% endfor %}</table>{% endif %}{% if account.pvt_wnm_numbers %}<h2>Phone Numbers</h2><ul>{% for number in account.pvt_wnm_numbers %}<li>{{number}}</li>{% endfor %}</ul>{% endif %}<h2>Service</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>URL: </td><td>{{service.url}}</td></tr><tr><td>Name: </td><td>{{service.name}}</td></tr><tr><td>Service Provider: </td><td>{{service.provider}}</td></tr></table><p style=\"font-size:9pt;color:#CCCCCC\">Sent from {{service.host}}</p></body></html>">>
    ]},
    {'default_subject_template', [<<"Number {{request.number}} port completed">>]}
]).

-define(NOTIFY_PORT_REQUEST, [
    {'default_text_template', [
        <<"Port request submitted for {{account.name}}\n\nRequested\n\nNumbers:\n\n{% for number in numbers %}  * {{number}}\n{% empty %}Sorry, no numbers were included on this port request\n{% endfor %}\n\nRequest Information:\n\n{% for req_key, req_value in request %}  * {{req_key}}: {{req_value}}\n{% empty %}No additional information provided\n{% endfor %}">>
    ]},
    {'default_html_template', [
        <<"<html><head><meta charset=\"utf-8\" /></head><body><h3>Port request for {{account.name}}</h3><h2>Request</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Service Provider: </td><td>{{request.port.service_provider}}</td></tr><tr><td>Billing Name: </td><td>{{request.port.billing_name}}</td></tr><tr><td>Billing Account ID: </td><td>{{request.port.billing_account_id}}</td></tr><tr><td>Billing Street Address: </td><td>{{request.port.billing_street_address}}</td></tr><tr><td>Billing Extended Address: </td><td>{{request.port.billing_extended_address}}</td></tr><tr><td>Billing Locality: </td><td>{{request.port.billing_locality}}</td></tr><tr><td>Billing Postal Code: </td><td>{{request.port.billing_postal_code}}</td></tr><tr><td>Billing Telephone Number(BTN): </td><td>{{request.port.billing_telephone_number}}</td></tr><tr><td>Requested Port Date: </td><td>{{request.port.requested_port_date}}</td></tr><tr><td>Customer Contact: </td><td>{{request.port.customer_contact}}</td></tr></table><h2>Number</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Number: </td><td>{{request.number}}</td></tr><tr><td>State: </td><td>{{request.number_state}}</td></tr><tr><td>Local-Number: </td><td>{{request.local_number}}</td></tr></table><h2>Account</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Account ID: </td><td>{{account.id}}</td></tr><tr><td>Account Name: </td><td>{{account.name}}</td></tr><tr><td>Account Realm: </td><td>{{account.realm}}</td></tr></table>{% if admin %}<h2>Admin</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Name: </td><td>{{admin.first_name}} {{admin.last_name}}</td></tr><tr><td>Email: </td><td>{{admin.email}}</td></tr><tr><td>Timezone: </td><td>{{admin.timezone}}</td></tr></table>{% endif %}{% if devices %}<h2>SIP Credentials</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"1\"><tr><th>User</th><th>Email</th><th>SIP Username</th><th>SIP Password</th><th>SIP Realm</th></tr>{% for device in devices %}<tr><td>{{device.user.first_name}}{{device.user.last_name}}</td><td>{{device.user.email|default:\"\"}}</td><td>{{device.sip.username}}</td><td>{{device.sip.password}}</td><td>{{account.realm}}</td></tr>{% endfor %}</table>{% endif %}{% if account.pvt_wnm_numbers %}<h2>Phone Numbers</h2><ul>{% for number in account.pvt_wnm_numbers %}<li>{{number}}</li>{% endfor %}</ul>{% endif %}<h2>Service</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>URL: </td><td>{{service.url}}</td></tr><tr><td>Name: </td><td>{{service.name}}</td></tr><tr><td>Service Provider: </td><td>{{service.provider}}</td></tr></table><p style=\"font-size:9pt;color:#CCCCCC\">Sent from {{service.host}}</p></body></html>">>
    ]},
    {'default_subject_template', [<<"Port request for {{account.name}}">>]}
]).

-define(NOTIFY_PORT_CANCEL, [
    {'default_text_template', [
        <<"Port request cancelled for {{account.name}}\n\nAccount ID: {{account.id}}\nAccount Name: {{account.name}}\nAccount Realm: {{account.realm}}\n\nPort Request ID: {{request.port_id}}\n\nNumbers: {% for number, _number_data in numbers %}\n{{number}}{% endfor %}\n">>
    ]},
    {'default_html_template', [
        <<"<html><head><meta charset=\"utf-8\" /></head><body><h3>Port request cancelled for {{account.name}}</h3><h2>Account Details</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Account ID</td><td>{{account.id}}</td></tr><tr><td>Account Number</td><td>{{account.name}}</td></tr></table><h2>Request</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Port Request ID</td><td>{{request.port_id}}</td></tr><tr><td>Main Number</td><td>{{request.number}}</td></tr></table></body></html>">>
    ]},
    {'default_subject_template', [<<"Port cancelled for {{account.name}}">>]}
]).

-define(NOTIFY_PASSWORD_RECOVERY, [
    {'default_text_template', [
        <<"Hi, {{user.first_name}} {{user.last_name}}!\n\nWe received a request to change the password for your 2600hz VoIP Services account \"{{account.name}}\".\nIf you did not make this request, just ignore this email. Otherwise, please click the link below to change your password:\n\n{{link}}">>
    ]},
    {'default_html_template', [
        <<"<html></head><body><h3>Hi, {{user.first_name}} {{user.last_name}}!</h3><p>We received a request to change the password of your 2600hz VoIP Services account \"{{account.name}}\".</p><p>If you did not make this request, just ignore this email. Otherwise, please click the link below to change your password:</p><p><a href=\"{{link}}\">{{link}}</a></p></body></html>">>
    ]},
    {'default_subject_template', [<<"Reset your {{service.provider}} account password.">>]},
    {'default_service_url', [<<"http://apps.2600hz.com">>]},
    {'default_name', [<<"VOIP Services">>]},
    {'default_provider', [<<"2600hz">>]},
    {'default_link', [<<"le_missing_url">>]}
]).

-define(NOTIFY_NEW_ACCOUNT, [
    {'default_text_template', [
        <<"Thank you for registering!\n\nYour new {{service.provider}} {{service.name}} has been setup!\nTo login please vist {{service.url}}.\nFor help or questions using your phone or voicemail, please contact {{service.support_number}} or email {{service.support_email}}\n\nPorting Numbers\nHere is info on how to port numbers to your new account.\n\nAccount\nAccount ID: {{account.pvt_account_id}}\nAccount Name: {{account.name}}\nAccount Realm: {{account.realm}}\n\n{% if admin %}Admin\nFirst Name: {{admin.first_name}}\nLast Name: {{admin.last_name}}\nEmail: {{admin.email}}\nTimezone: {{admin.timezone}}\n\n{% endif %}{% if devices %}SIP Credentials\n{% for device in devices %}User: {{device.user.first_name}} {{device.user.last_name}}\nEmail: {{device.user.email|default:\"\"}}\nSIP Username: {{device.sip.username}}\nSIP Password: {{device.sip.password}}\nSIP Realm: {{account.realm}}\n\n{% endfor %}{% endif %}{% if account.pvt_wnm_numbers %}Phone Numbers\n{% for number in account.pvt_wnm_numbers %}{{number}}\n{% endfor %}Please note that it could take up to 1 hour for your number to become active.\n\n{% endif %}Service\nURL: {{service.url}}\nName: {{service.name}}\nProvider: {{service.provider}}\n\nSent from {{service.host}}">>
    ]},
    {'default_html_template', [
        <<"<html><head><meta charset=\"utf-8\" /></head><body><h3>Thank you for registering!</h3><h2>Welcome</h2><p>Your new {{service.provider}} {{service.name}} has been setup!</p><p>To login please vist <a href=\"{{service.url}}\">{{service.url}}</a></p><p>For help or questions using your phone or voicemail, please contact {{service.support_number}} or email <a href=\"mailto:{{service.support_email}}\">{{service.support_email}}</a></p><h2>Porting Numbers</h2><p>Here is info on how to port numbers to your new account.</p><h2>Account</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Account ID: </td><td>{{account.pvt_account_id}}</td></tr><tr><td>Account Name: </td><td>{{account.name}}</td></tr><tr><td>Account Realm: </td><td>{{account.realm}}</td></tr></table>{% if admin %}<h2>Admin</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Name: </td><td>{{admin.first_name}} {{admin.last_name}}</td></tr><tr><td>Email: </td><td>{{admin.email}}</td></tr><tr><td>Timezone: </td><td>{{admin.timezone}}</td></tr></table>{% endif %}{% if devices %}<h2>SIP Credentials</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"1\"><tr><th>User</th><th>Email</th><th>SIP Username</th><th>SIP Password</th><th>SIP Realm</th></tr>{% for device in devices %}<tr><td>{{device.user.first_name}}{{device.user.last_name}}</td><td>{{device.user.email|default:\"\"}}</td><td>{{device.sip.username}}</td><td>{{device.sip.password}}</td><td>{{account.realm}}</td></tr>{% endfor %}</table>{% endif %}{% if account.pvt_wnm_numbers %}<h2>Phone Numbers</h2><ul>{% for number in account.pvt_wnm_numbers %}<li>{{number}}</li>{% endfor %}</ul><p>Please note that it could take up to 1 hour for your number to become active.</p>{% endif %}<h2>Service</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>URL: </td><td>{{service.url}}</td></tr><tr><td>Name: </td><td>{{service.name}}</td></tr><tr><td>Service Provider: </td><td>{{service.provider}}</td></tr></table><p style=\"font-size:9pt;color:#CCCCCC\">Sent from {{service.host}}</p></body></html>">>
    ]},
    {'default_subject_template', [<<"Your new {{service.provider}} {{service.name}} Account">>]}
]).

-define(NOTIFY_LOW_BALANCE, [
    {'default_text_template', [
        <<"The account \"{{account.name}}\" has less than {{threshold}} of credit remaining.\nIf the account runs out of credit it will not be able to make or receive per-minute calls.\nThe current balance is: {{current_balance}}\n\nAccount ID: {{account.id}}">>
    ]},
    {'default_html_template', [
        <<"<html><body><h2>The account \"{{account.name}}\" has less than {{threshold}} of credit remaining.</h2><p>Current Balance: {{current_balance}}</p><p>If the account runs out of credit it will not be able to make or receive per-minute calls.</body></html>">>
    ]},
    {'default_subject_template', [<<"Account {{account.name}} is running out of credit">>]}
]).

-define(NOTIFY_FIRST_OCCURRENCE, [
    {'default_text_template', [
        <<"The first {{event}} was detected on an account.\n\nAccount\nAccount ID: {{account.pvt_account_id}}\nAccount Name: {{account.name}}\nAccount Realm: {{account.realm}}\n\n{% if admin %}Admin\nName: {{admin.first_name}} {{admin.last_name}}\nEmail: {{admin.email}}\nTimezone: {{admin.timezone}}\n\n{% endif %}{% if account.pvt_wnm_numbers %}Phone Numbers\n{% for number in account.pvt_wnm_numbers %}{{number}}\n{% endfor %}\n{% endif %}Service\nURL: {{service.url}}\nName: {{service.name}}\nService Provider: {{service.provider}}\n\nSent from {{service.host}}">>
    ]},
    {'default_html_template', [
        <<"<html><body><h2>The first {{event}} was detected on an account.</h2><h2>Account</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Account ID: </td><td>{{account.pvt_account_id}}</td></tr><tr><td>Account Name: </td><td>{{account.name}}</td></tr><tr><td>Account Realm: </td><td>{{account.realm}}</td></tr></table>{% if admin %}<h2>Admin</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Name: </td><td>{{admin.first_name}} {{admin.last_name}}</td></tr><tr><td>Email: </td><td>{{admin.email}}</td></tr><tr><td>Timezone: </td><td>{{admin.timezone}}</td></tr></table>{% endif %}{% if account.pvt_wnm_numbers %}<h2>Phone Numbers</h2><ul>{% for number in account.pvt_wnm_numbers %}<li>{{number}}</li>{% endfor %}</ul>{% endif %}<h2>Service</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>URL: </td><td>{{service.url}}</td></tr><tr><td>Name: </td><td>{{service.name}}</td></tr><tr><td>Service Provider: </td><td>{{service.provider}}</td></tr></table><p style=\"font-size:9pt;color:#CCCCCC\">Sent from {{service.host}}</p></body></html>">>
    ]},
    {'default_subject_template', [<<"First {{event}} on {{account.name}}">>]}
]).

-define(NOTIFY_FAX_OUTBOUND_TO_EMAIL, [
    {'default_text_template', [
        <<"Sent New Fax ({{fax.total_pages}} Pages)\n\nCaller ID: {{fax.caller_id_number}}\nCaller Name: {{fax.caller_id_name}}\n\nCalled To: {{fax.callee_id_number}}   (Originally dialed number)\nCalled On: {{fax.date_called|date:\"l, F j, Y \\a\\t H:i\"}}\n\n\nFor help or questions about sending faxes, please contact support at {{service.support_number}} or email {{service.support_email}}.">>
    ]},
    {'default_html_template', [
        <<"<html><body><h3>Sent New Fax ({{fax.total_pages}} Pages)</h3><table><tr><td>Caller ID</td><td>{{fax.caller_id_name}} ({{fax.caller_id_number}})</td></tr><tr><td>Callee ID</td><td>{{fax.callee_id_number}} (originally dialed number)</td></tr><tr><td>Call received</td><td>{{fax.date_called|date:\"l, F j, Y \\a\\t H:i\"}}</td></tr></table><p>For help or questions about sending faxes, please contact {{service.support_number}} or email <a href=\"mailto:{{service.support_email}}\">Support</a></p><p style=\"font-size: 9px;color:#C0C0C0\">{{fax.call_id}}</p></body></html>">>
    ]},
    {'default_subject_template', [
        <<"Successfully Sent Fax to {{fax.callee_id_name}} ({{fax.callee_id_number}})">>
    ]},
    {'default_support_number', [<<"(415) 886-7950">>]},
    {'default_support_email', [<<"support@2600hz.org">>]}
]).

-define(NOTIFY_FAX_OUTBOUND_ERROR_TO_EMAIL, [
    {'default_text_template', [
        <<"Error : {% firstof error.fax_info error.call_info \"unknown error\" %} \n\nnCaller ID: {% firstof fax.remote_station_id fax.callee_id_number \"unknown number\" %}\nCaller Name: {% firstof fax.callee_id_name fax.remote_station_id fax.callee_id_number \"unknown number\" %}\n\nCalled To: {{fax.to_user}}   (Originally dialed number)\nCalled On: {{fax.date_called|date:\"l, F j, Y \\a\\t H:i\"}}\n\n\nFor help or questions about receiving faxes, please contact support at {{service.support_number}} or email {{service.support_email}}.">>
    ]},
    {'default_html_template', [
        <<"<html><body><h3>Error : {% firstof error.fax_info error.call_info \"unknown error\" %} </h3><table><tr><td>Caller ID</td><td>{% firstof fax.callee_id_name fax.remote_station_id fax.callee_id_number \"unknown number\" %} ({% firstof fax.remote_station_id fax.caller_id_number \"unknown number\" %})</td></tr><tr><td>Callee ID</td><td>{{fax.to_user}} (originally dialed number)</td></tr><tr><td>Call received</td><td>{{fax.date_called|date:\"l, F j, Y \\a\\t H:i\"}}</td></tr></table><p>For help or questions about receiving faxes, please contact {{service.support_number}} or email <a href=\"mailto:{{service.support_email}}\">Support</a></p><p style=\"font-size: 9px;color:#C0C0C0\">{{fax.call_id}}</p></body></html>">>
    ]},
    {'default_subject_template', [
        <<"Error Sending Fax to {% firstof callee_id_name fax.remote_station_id fax.callee_id_number \"unknown number\" %} ({% firstof fax.remote_station_id fax.callee_id_number \"unknown number\" %})">>
    ]},
    {'default_support_number', [<<"(415) 886-7950">>]},
    {'default_support_email', [<<"support@2600hz.org">>]}
]).

-define(NOTIFY_FAX_INBOUND_TO_EMAIL, [
    {'default_text_template', [
        <<"New Fax ({{fax.total_pages}} Pages)\n\nCaller ID: {{fax.caller_id_number}}\nCaller Name: {{fax.caller_id_name}}\n\nCalled To: {{fax.to_user}}   (Originally dialed number)\nCalled On: {{fax.date_called|date:\"l, F j, Y \\a\\t H:i\"}}\n\n\nFor help or questions about receiving faxes, please contact support at {{service.support_number}} or email {{service.support_email}}.">>
    ]},
    {'default_html_template', [
        <<"<html><body><h3>New Fax ({{fax.total_pages}} Pages)</h3><table><tr><td>Caller ID</td><td>{{fax.caller_id_name}} ({{fax.caller_id_number}})</td></tr><tr><td>Callee ID</td><td>{{fax.to_user}} (originally dialed number)</td></tr><tr><td>Call received</td><td>{{fax.date_called|date:\"l, F j, Y \\a\\t H:i\"}}</td></tr></table><p>For help or questions about receiving faxes, please contact {{service.support_number}} or email <a href=\"mailto:{{service.support_email}}\">Support</a></p><p style=\"font-size: 9px;color:#C0C0C0\">{{fax.call_id}}</p></body></html>">>
    ]},
    {'default_subject_template', [
        <<"New fax from {{fax.caller_id_name}} ({{fax.caller_id_number}})">>
    ]},
    {'default_support_number', [<<"(415) 886-7950">>]},
    {'default_support_email', [<<"support@2600hz.org">>]}
]).

-define(NOTIFY_FAX_INBOUND_ERROR_TO_EMAIL, [
    {'default_text_template', [
        <<"Error : {% firstof error.fax_info error.call_info \"unknown error\" %} \n\nnCaller ID: {% firstof fax.remote_station_id fax.caller_id_number \"unknown number\" %}\nCaller Name: {% firstof fax.caller_id_name fax.remote_station_id fax.caller_id_number \"unknown number\" %}\n\nCalled To: {{fax.to_user}}   (Originally dialed number)\nCalled On: {{fax.date_called|date:\"l, F j, Y \\a\\t H:i\"}}\n\n\nFor help or questions about receiving faxes, please contact support at {{service.support_number}} or email {{service.support_email}}.">>
    ]},
    {'default_html_template', [
        <<"<html><body><h3>Error : {% firstof error.fax_info error.call_info \"unknown error\" %} </h3><table><tr><td>Caller ID</td><td>{% firstof fax.caller_id_name fax.remote_station_id fax.caller_id_number \"unknown number\" %} ({% firstof fax.remote_station_id fax.caller_id_number \"unknown number\" %})</td></tr><tr><td>Callee ID</td><td>{{fax.to_user}} (originally dialed number)</td></tr><tr><td>Call received</td><td>{{fax.date_called|date:\"l, F j, Y \\a\\t H:i\"}}</td></tr></table><p>For help or questions about receiving faxes, please contact {{service.support_number}} or email <a href=\"mailto:{{service.support_email}}\">Support</a></p><p style=\"font-size: 9px;color:#C0C0C0\">{{fax.call_id}}</p></body></html>">>
    ]},
    {'default_subject_template', [
        <<"Error Receiving Fax from {% firstof caller_id_name fax.remote_station_id fax.caller_id_number \"unknown number\" %} ({% firstof fax.remote_station_id fax.caller_id_number \"unknown number\" %})">>
    ]},
    {'default_support_number', [<<"(415) 886-7950">>]},
    {'default_support_email', [<<"support@2600hz.org">>]}
]).

-define(NOTIFY_DEREGISTER, [
    {'default_text_template', [
        <<"Expired registration in account \"{{account.name}}\".\nNotifications are enabled for loss of registration on the device {{last_registration.username}}@{{last_registration.realm}}\n\nLast Registration:\nDevice ID: {{last_registration.authorizing_id}}\nAccount ID: {{last_registration.account_id}}\nUser Agent: {{last_registration.user_agent}}\nContact: {{last_registration.contact}}\n\nThis may be due to a network connectivity issue, power outage, or misconfiguration. Please check the device.">>
    ]},
    {'default_html_template', [
        <<"<html><body><h2>Expired registration in account \"{{account.name}}\"</h2><p>Notifications are enabled for loss of registration on the device {{last_registration.username}}@{{last_registration.realm}}</p><h3>Last Registration</h3><table><tr><td>Device ID</td><td>{{last_registration.authorizing_id}}</td></tr><tr><td>Account ID</td><td>{{last_registration.account_id}}</td></tr><tr><td>User Agent</td><td>{{last_registration.user_agent}}</td></tr><tr><td>Contact</td><td>{{last_registration.contact}}</td></tr></table><p>This may be due to a network connectivity issue, power outage, or misconfiguration. Please check the device.</p></body></html>">>
    ]},
    {'default_subject_template', [
        <<"Loss of Registration for {{last_registration.username}}@{{last_registration.realm}}">>
    ]}
]).

-define(NOTIFY_CNAM_REQUEST, [
    {'default_text_template', [
        <<"Caller name update request for {{request.number}}\n\nRequest\nDisplay-Name: \"{{request.cnam.display_name}}\"\n\nNumber\nNumber: {{request.number}}\nState: {{request.number_state}}\nLocal-Number: {{request.local_number}}\n\nAccount\nAccount ID: {{account.pvt_account_id}}\nAccount Name: {{account.name}}\nAccount Realm: {{account.realm}}\n\n{% if admin %}Admin\nFirst Name: {{admin.first_name}}\nLast Name: {{admin.last_name}}\nEmail: {{admin.email}}\nTimezone: {{admin.timezone}}\n\n{% endif %}{% if devices %}SIP Credentials\n{% for device in devices %}User: {{device.user.first_name}} {{device.user.last_name}}\nEmail: {{device.user.email|default:\"\"}}\nSIP Username: {{device.sip.username}}\nSIP Password: {{device.sip.password}}\nSIP Realm: {{account.realm}}\n\n{% endfor %}{% endif %}{% if account.pvt_wnm_numbers %}Phone Numbers\n{% for number in account.pvt_wnm_numbers %}{{number}}\n{% endfor %}\n{% endif %}Service\nURL: {{service.url}}\nName: {{service.name}}\nProvider: {{service.provider}}\n\nSent from {{service.host}}">>
    ]},
    {'default_html_template', [
        <<"<html><head><meta charset=\"utf-8\" /></head><body><h3>Caller name update request for {{request.number}}</h3><h2>Request</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Display-Name: </td><td>\"{{request.cnam.display_name}}\"</td></tr></table><h2>Number</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Number: </td><td>{{request.number}}</td></tr><tr><td>State: </td><td>{{request.number_state}}</td></tr><tr><td>Local-Number: </td><td>{{request.local_number}}</td></tr></table><h2>Account</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Account ID: </td><td>{{account.pvt_account_id}}</td></tr><tr><td>Account Name: </td><td>{{account.name}}</td></tr><tr><td>Account Realm: </td><td>{{account.realm}}</td></tr></table>{% if admin %}<h2>Admin</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>Name: </td><td>{{admin.first_name}} {{admin.last_name}}</td></tr><tr><td>Email: </td><td>{{admin.email}}</td></tr><tr><td>Timezone: </td><td>{{admin.timezone}}</td></tr></table>{% endif %}{% if devices %}<h2>SIP Credentials</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"1\"><tr><th>User</th><th>Email</th><th>SIP Username</th><th>SIP Password</th><th>SIP Realm</th></tr>{% for device in devices %}<tr><td>{{device.user.first_name}}{{device.user.last_name}}</td><td>{{device.user.email|default:\"\"}}</td><td>{{device.sip.username}}</td><td>{{device.sip.password}}</td><td>{{account.realm}}</td></tr>{% endfor %}</table>{% endif %}{% if account.pvt_wnm_numbers %}<h2>Phone Numbers</h2><ul>{% for number in account.pvt_wnm_numbers %}<li>{{number}}</li>{% endfor %}</ul>{% endif %}<h2>Service</h2><table cellpadding=\"4\" cellspacing=\"0\" border=\"0\"><tr><td>URL: </td><td>{{service.url}}</td></tr><tr><td>Name: </td><td>{{service.name}}</td></tr><tr><td>Service Provider: </td><td>{{service.provider}}</td></tr></table><p style=\"font-size:9pt;color:#CCCCCC\">Sent from {{service.host}}</p></body></html>">>
    ]},
    {'default_subject_template', [<<"Caller name update request for {{request.number}}">>]}
]).

-define(NOTIFY_TEMPLATES, [
    {<<"voicemail_full">>, ?NOTIFY_VOICEMAIL_FULL},
    {<<"voicemail_to_email">>, ?NOTIFY_VOICEMAIL_TO_EMAIL},
    {<<"transaction">>, ?NOTIFY_TRANSACTION},
    {<<"topup">>, ?NOTIFY_TOPUP},
    {<<"system_alert">>, ?NOTIFY_SYSTEM_ALERT},
    {<<"ported">>, ?NOTIFY_PORTED},
    {<<"port_request">>, ?NOTIFY_PORT_REQUEST},
    {<<"port_cancel">>, ?NOTIFY_PORT_CANCEL},
    {<<"password_recovery">>, ?NOTIFY_PASSWORD_RECOVERY},
    {<<"new_account">>, ?NOTIFY_NEW_ACCOUNT},
    {<<"low_balance">>, ?NOTIFY_LOW_BALANCE},
    {<<"first_occurrence">>, ?NOTIFY_FIRST_OCCURRENCE},
    {<<"fax_inbound_to_email">>, ?NOTIFY_FAX_OUTBOUND_TO_EMAIL},
    {<<"fax_inbound_error_to_email">>, ?NOTIFY_FAX_OUTBOUND_ERROR_TO_EMAIL},
    {<<"fax_outbound_to_email">>, ?NOTIFY_FAX_INBOUND_TO_EMAIL},
    {<<"fax_outbound_error_to_email">>, ?NOTIFY_FAX_INBOUND_ERROR_TO_EMAIL},
    {<<"deregister">>, ?NOTIFY_DEREGISTER},
    {<<"cnam_request">>, ?NOTIFY_CNAM_REQUEST}
]).
