local pxconfig = require("px.pxconfig")
local pxtimer = require("px.utils.pxtimer")
local pxconstants = require("px.utils.pxconstants")
local px = require("px.pxnginx")
local MODULE_VERSION = "4.0.5"
local MODULE_VERSION_FULL = "Kong Plugin v" .. MODULE_VERSION
local ngx_now = ngx.now

local PXHandler = {
    VERSION = MODULE_VERSION,
    PRIORITY = 2500,
}

-- Example: additional_activity_handler() function
--function additional_activity_handler(event_type, ctx, details)
--	local cjson = require "cjson"
--	if (event_type == 'block') then
--		ngx.log(ngx.ERR, "PerimeterX: [" .. event_type .. "] blocked with score: " .. ctx.block_score .. ". Details: " .. cjson.encode(details))
--	else
--		ngx.log(ngx.ERR, "PerimeterX: [" .. event_type .. "]. Details: " .. cjson.encode(details))
--	end
--end


local function get_now()
    return ngx_now() * 1000
end

function PXHandler:init_worker()
     pxconstants.MODULE_VERSION = MODULE_VERSION_FULL
     pxtimer.application(pxconfig)
end

function PXHandler:access(config)
    local ngx_ctx = ngx.ctx
    ngx_ctx.KONG_HEADER_FILTER_STARTED_AT = get_now()

    -- config.additional_activity_handler = additional_activity_handler

    local params = config.enrich_custom_parameters
    if params ~= nil and type(params) == "table" then
        local code_string = table.concat(params, "\n")

        local dynamic_function, err = load(code_string)

        if dynamic_function then
            config.enrich_custom_parameters = dynamic_function()
        else
            ngx.log(ngx.ERR, "[PerimeterX - ERROR]: Failed to load `enrich_custom_parameters` function: " .. tostring(err))
            config.enrich_custom_parameters = nil
        end

    end

    px.application(config)
end

return PXHandler

