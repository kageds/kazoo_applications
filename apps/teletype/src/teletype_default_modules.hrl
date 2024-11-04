-ifndef(TELETYPE_DEFAULT_MODULES).
-define(DEFAULT_MODULES, ['teletype_account_zone_change'
                         ,'teletype_bill_reminder'
                         ,'teletype_cnam_request'
                         ,'teletype_customer_update'
                         ,'teletype_denied_emergency_bridge'
                         ,'teletype_deregister'
                         ,'teletype_emergency_bridge'
                         ,'teletype_fax_inbound_error_to_email'
                         ,'teletype_fax_inbound_error_to_email_filtered'
                         ,'teletype_fax_inbound_to_email'
                         ,'teletype_fax_outbound_error_to_email'
                         ,'teletype_fax_outbound_smtp_error_to_email'
                         ,'teletype_fax_outbound_to_email'
                         ,'teletype_first_occurrence'
                         ,'teletype_low_balance'
                         ,'teletype_missed_call'
                         ,'teletype_new_account'
                         ,'teletype_new_user'
                         ,'teletype_number_feature_manual_action'
                         ,'teletype_password_recovery'
                         ,'teletype_port_cancel'
                         ,'teletype_port_comment'
                         ,'teletype_ported'
                         ,'teletype_port_pending'
                         ,'teletype_port_rejected'
                         ,'teletype_port_request_admin'
                         ,'teletype_port_request'
                         ,'teletype_port_scheduled'
                         ,'teletype_port_unconfirmed'
                         ,'teletype_service_added'
                         ,'teletype_system_alert'
                         ,'teletype_topup'
                         ,'teletype_transaction'
                         ,'teletype_transaction_failed'
                         ,'teletype_voicemail_deleted'
                         ,'teletype_voicemail_full'
                         ,'teletype_voicemail_to_email'
                         ,'teletype_webhook_disabled'
                         ]).
-define(TELETYPE_DEFAULT_MODULES, 'true').
-endif.
