-- Keep this file sync with pxconfig.lua
local typedefs = require "kong.db.schema.typedefs"

return {
    name = "perimeterx",
    fields = {
    { consumer = typedefs.no_consumer },
    { config = {
        type = "record",
        fields = {
        -- ## Required Parameters ##
        { px_appId = {type = "string", required = true} },
        { cookie_secret = {type = "string", required = true} },
        { auth_token = {type = "string", required = true} },

        -- ## Blocking Parameters ##
        { blocking_score = {type = "number", default = 100} },
        { block_enabled = {type = "boolean", default = false} },
        { advanced_blocking_response = {type = "boolean", default = false} },

        -- ## Additional Configuration Parameters ##
        { sensitive_headers = {type = "array", elements = { type = "string" }, default = {'cookie', 'cookies'}} },
        { ip_headers = {type = "array", elements = { type = "string" }, default = {}} },
        { score_header_name = {type = "string", default = 'X-PX-SCORE'} },
        { score_header_enabled = {type = "boolean", default = false} },
        { sensitive_routes_prefix = {type = "array", elements = { type = "string" }, default = {}} },
        { sensitive_routes_suffix = {type = "array", elements = { type = "string" }, default = {}} },
        { sensitive_routes = {type = "array", elements = { type = "string" }, default = {}} },
        -- custom_sensitive_routes
        -- additional_activity_handler
        { enabled_routes = {type = "array", elements = { type = "string" }, default = {}} },
        -- custom_enabled_routes
        { monitored_routes = {type = "array", elements = { type = "string" }, default = {}} },
        { first_party_enabled = {type = "boolean", default = true} },
        { reverse_xhr_enabled = {type = "boolean", default = true} },
        { proxy_url = {type = "string"} },
        { proxy_authorization = {type = "string"} },
        { custom_cookie_header = {type = "string"} },
        { bypass_monitor_header = {type = "string"} },
        -- pxhd_secure_enabled

        { enrich_custom_parameters = {type = "array", elements = { type = "string" }, default = {}} },

        -- ## API protection mode ##
        { api_protection_mode = {type = "boolean", default = false} },
        { api_protection_block_url = {type = "string"} },
        { api_protection_default_redirect_url = {type = "string"} },

        -- ## Blocking Page Parameters ##
        { custom_logo = {type = "string"} },
        { css_ref = {type = "string"} },
        { js_ref = {type = "string"} },

        { custom_block_url = {type = "string"} },
        { redirect_on_custom_url = {type = "boolean", default = false} },

        -- ## Debug Parameters ##
        { px_debug = {type = "boolean", default = false} },
        { s2s_timeout = {type = "number", default = 1000} },
        { client_timeout = {type = "number", default = 2000} },

        -- ## Filter Configuration ##
        { whitelist_uri_full = {type = "array", elements = { type = "string" }, default = {}} }, -- custom_block_url value should be a member of this array
        { whitelist_uri_prefixes = {type = "array", elements = { type = "string" }, default = {}} },
        { whitelist_uri_suffixes = {type = "array", elements = { type = "string" }, default = { '.css', '.bmp', '.tif', '.ttf', '.docx', '.woff2', '.js', '.pict', '.tiff', '.eot', '.xlsx', '.jpg', '.csv', '.eps', '.woff', '.xls', '.jpeg', '.doc', '.ejs', '.otf', '.pptx', '.gif', '.pdf', '.swf', '.svg', '.ps', '.ico', '.pls', '.midi', '.svgz', '.class', '.png', '.ppt', '.mid', '.webp', '.jar' }} },
        { whitelist_ip_addresses = {type = "array", elements = { type = "string" }, default = {}} },
        { whitelist_ua_full = {type = "array", elements = { type = "string" }, default = {}} },
        { whitelist_ua_sub = {type = "array", elements = { type = "string" }, default = {}} },
        { whitelist_hosts = {type = "array", elements = { type = "string" }, default = {}} },


        -- ## Login Credentials extraction
        { px_enable_login_creds_extraction = {type = "boolean", default = false} },
        { px_login_creds_settings_filename = {type = "string"} },
        -- px_login_creds_settings =
        { px_compromised_credentials_header_name = {type = "string", default = "px-compromised-credentials"} },
        { px_login_successful_reporting_method = {type = "string", default = "none"} },
        { px_login_successful_header_name = {type = "string", default = "x-px-login-successful"} },
        -- px_login_successful_status = {type = "array", default = {200}},
        { px_send_raw_username_on_additional_s2s_activity = {type = "boolean", default = false} },
        { px_credentials_intelligence_version = {type = "string", default = "v2"} },
        { px_additional_s2s_activity_header_enabled = {type = "boolean", default = false} },
        --custom_login_successful =

        -- ## GraphQL
        { px_sensitive_graphql_operation_types = {type = "array", elements = { type = "string" }, default = {}} },
        { px_sensitive_graphql_operation_names = {type = "array", elements = { type = "string" }, default = {}} },
        { px_graphql_routes = {type = "array", elements = { type = "string" }, default = {}} },

        -- ## User Identifiers
        { px_jwt_cookie_name = {type = "string"} },
        { px_jwt_cookie_user_id_field_name = {type = "string"} },
        { px_jwt_cookie_additional_field_names = {type = "array", elements = { type = "string" }, default = {}} },
        { px_jwt_header_name = {type = "string"} },
        { px_jwt_header_user_id_field_name = {type = "string"} },
        { px_jwt_header_additional_field_names = {type = "array", elements = { type = "string" }, default = {}} },

        -- ## CORS support
        { px_cors_support_enabled = {type = "boolean", default = false} },
        -- px_cors_custom_preflight_handler = nil
        { px_cors_preflight_request_filter_enabled = {type = "boolean", default = false} },
        { px_cors_create_custom_block_response_headers = {type = "string"} },
        },
    },
    },
    },
}
