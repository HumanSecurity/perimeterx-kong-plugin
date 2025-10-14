![image](https://storage.googleapis.com/perimeterx-logos/primary_logo_red_cropped.png)

# [PerimeterX](http://www.perimeterx.com) Kong Plugin

## Table of Contents

- [Getting Started](#gettingstarted)
  - [Dependencies](#dependencies)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Installing on Amazon Linux](#awsinstall)
  - [Basic Usage Example](#basic-usage)
  - [Demonstration Docker](#docker)
- [Upgrading](*upgrade)
- [Configuration](#configuration)

  - [First-Party Configuration](#first_party_config)
    - [First-Party Mode](#first-party)
    - [PerimeterX First-Party JS Snippet](#perimeterx_first_party_js_snippet)
  - [Blocking Score](#blocking-score)
  - [Monitoring mode](#monitoring-mode)
  - [Enabled Routes](#enabled-routes)
  - [Sensitive Routes](#sensitive-routes)
  - [Extracting Real IP Address](#real-ip)
  - [Filter Sensitive Headers](#sensitive-headers)
  - [API Timeout](#api-timeout)
  - [Send Page Activities](#send-page-activities)
  - [Debug Mode](#debug-mode)
  - [Custom Block Page](#customblockpage)
  - [API Protection Mode](#api-protection)
  - [Multiple App Support](#multipleapps)
  - [Additional Activity Handler](#add-activity-handler)
  - [Enrich Custom Parameters](#custom-parameters)
  - [Whitelisting](#whitelisting)
  - [Custom Cookie Header](#custom-cookie-header)

- [Advanced Blocking Response](#advancedBlockingResponse)
- [Additional Information](#additional-information)
- [Contributing](#contributing)

## <a name="gettingstarted"></a> Getting Started

## <a name="dependencies"></a> Dependencies

- [Kong](https://getkong.org/) (2.x and 3.x Kong versions are supported)
- [LuaJIT](http://luajit.org/)
- [Lua CJSON](http://www.kyne.com.au/~mark/software/lua-cjson.php)
- [Lua Resty HTTP](https://github.com/pintsized/lua-resty-http)
- [Lua Resty Nettle](https://github.com/bungle/lua-resty-nettle)
- [lustache](https://github.com/Olivine-Labs/lustache)
- [GNU Nettle >= v3.2](https://www.lysator.liu.se/~nisse/nettle/)

To install package dependencies on Ubuntu run:

`sudo apt-get update && sudo apt-get install lua-cjson nettle-dev luarocks luajit libluajit-5.1-dev ca-certificates make`

All Lua dependecies are automatically fulfilled with Luarocks.

## <a name="installation"></a> Installation

Installation can be done using [luarocks](https://luarocks.org/).

```sh
luarocks install kong-plugin-perimeterx
```

Manual installation can accomplished by downloading the sources for this repository and running `sudo make install`.

<a name="awsinstall"></a> Additional steps for installing on Amazon Linux

Make sure to change the path shown below in the "Lua CA Certificates" section as Amazon Linux stores the CA required in a different location than shown.

If running Amazon Linux this is the trusted certificate path please use:

```
lua_ssl_trusted_certificate "/etc/pki/tls/certs/ca-bundle.crt";
```

## <a name="requirements"></a> NGINX Configuration File Requirements

### Resolver

Add the directive `resolver A.B.C.D;` in the HTTP section of your configuration. This is required so NGINX can resolve the PerimeterX API DNS name. `A.B.C.D` is the IP address of your DNS resolver.

### Lua CA Certificates

To support TLS to PerimeterX servers, you must point Lua to the trusted certificate location (actual location may differ between Linux distributions).

```
lua_ssl_trusted_certificate "/etc/ssl/certs/ca-certificates.crt";
lua_ssl_verify_depth 3;
```

In CentOS/RHEL systems, the CA bundle location may be located at `/etc/pki/tls/certs/ca-bundle.crt`.

### <a name="basic-usage"></a> Basic Usage Example

Ensure that you followed the NGINX Configuration Requirements section before proceeding.

Load the plugin by adding `perimeterx` to the `plugins` section in your Kong configuration (on each Kong node).

`kong.yaml` "plugins" section example:

```
...
plugins:
    - name: perimeterx
      config:
          px_appId: --REPLACE--
          auth_token: --REPLACE--
          cookie_secret: --REPLACE--
          px_debug: true
          block_enabled: true
```

Note: you can also set this property via its environment variable equivalent: `KONG_CUSTOM_PLUGINS`.

To apply PerimeterX enforcement, add the perimeterx plugin to your API(s):

```bash
curl -i -X POST \
      --url http://localhost:8001/apis/<api-name>/plugins/ \
      --data 'name=perimeterx' \
      --data 'config.px_appId=PX_APP_ID' \
      --data 'config.auth_token=AUTH_TOKEN' \
      --data 'config.cookie_secret=COOKIE_KEY'
```

You can find your app ID, authentication token, and cookie key under your account's admin section in [PerimeterX Portal](https://console.perimeterx.com)

### <a name=docker></a> Demonstration Docker

To run the demonstration Docker image:

1. Copy `kong/config/kong.yml` to `kong/config/kong.dev.yml` and adjust it with your PerimeterX app id, cookie secret and auth token.

2. From the root folder execute `./scripts/run-kong.sh  3.9.1`.

3. Navigate to <http://127.0.0.1:8000>.

4. You can find the PerimeterX module output in your terminal.

## <a name="upgrade"></a> Upgrading

To upgrade to the latest Enforcer version run the following command in luarocks:

`luarocks install perimeterx-kong-plugin`

Your Enforcer version is now upgraded to the latest enforcer version.

For more information, contact [PerimeterX Support](support@perimeterx.com).

### <a name="configuration"></a> Configuration Options

#### Configuring Required Parameters

Configuration options are set via Kong's admin API, as config parameter.

#### Required parameters

- px_appId
- cookie_secret
- auth_token

#### <a name="first_party_config"></a> First-Party Configuration

##### <a name="first-party"></a> First-Party Mode

First-Party Mode enables the module to send/receive data to/from the sensor, acting as a reverse-proxy for client requests and sensor activities.

First-Party Mode may require additional changes on the [JS Sensor Snippet](#perimeterx_first_party_js_snippet). For more information, refer to the PerimeterX Portal.

```bash
--data 'config.first_party_enabled=true'
```

The following routes must be enabled for First-Party Mode for the PerimeterX Kong plugin:

- `/<PX_APP_ID without PX prefix>/xhr/*`
- `/<PX_APP_ID without PX prefix>/init.js`
- `/<PX_APP_ID without PX prefix>/captcha/*`

- If the PerimeterX Kong module is enabled on `location /`, the routes are already open and no action is necessary.

> NOTE: The PerimeterX Kong Plugin Configuration Requirements must be completed before proceeding to the next stage of installation.

##### <a name="perimeterx_first_party_js_snippet"></a> First-Party JS Snippet

Ensure the PerimeterX Kong Plugin is configured before deploying the PerimeterX First-Party JS Snippet across your site. (Detailed instructions for deploying the PerimeterX First-Party JS Snippet can be found <a href="https://docs.perimeterx.com/pxconsole/docs/managing-applications#section-snippet" onclick="window.open(this.href); return false;">here</a>.)

To deploy the PerimeterX First-Party JS Snippet:

##### 1. Generate the First-Party Snippet

- Go to <a href="https://console.perimeterx.com/#/app/applicationsmgmt" onclick="window.open(this.href); return false;">**Applications**</a> >> **Snippet**.
- Select **First-Party**.
- Select **Use Default Routes**.
- Click **Copy Snippet** to generate the JS Snippet.

##### 2. Deploy the First-Party Snippet

- Copy the JS Snippet and deploy using a tag manager, or by embedding it globally into your web template for which websites you want PerimeterX to run.

#### <a name="blocking-score"></a> Changing the Minimum Score for Blocking

**Default blocking value:** 100

```bash
--data 'config.blocking_score=60'
```

#### <a name="monitoring-mode"></a> Blocking Mode

**Default:** false

```bash
--data 'config.block_enabled=true'
```

The PerimeterX plugin is enabled in monitor only mode by default.

Setting the block*enabled flag to \_true* will activate the module to enforce the blocking score. The PerimeterX module will block users crossing the block score threshold that you define. If a user crosses the minimum block score then the user will receive the block page.

#### <a name="enabled-routes"></a> Enabled Routes

The enabled routes variable allows you to implicitly define a set of routes which the plugin will be active on. Supplying an empty list will set all application routes as active.

**Default: Empty list (all routes)**

```bash
--data 'config.enabled_routes=/blockhere'
```

#### <a name="sensitive-routes"></a> Sensitive Routes

Lists of route prefixes and suffixes. The PerimeterX module will always match the request URI with these lists, and if a match is found will create a server-to-server call, even if the cookie is valid and its score is low.

**Default: Empty list**

```bash
--data 'config.sensitive_routes_prefix=/login,/user/profile'
--data 'config.sensitive_routes_suffix=/download'
```

#### <a name="sensitive-headers"></a> Filter sensitive headers

A list of sensitive headers can be configured to prevent specific headers from being sent to PerimeterX servers (lower case header names). Filtering cookie headers for privacy is set by default, and can be overridden on the `pxConfig` variable.

**Default: cookie, cookies**

```bash
--data 'config.sensitive_headers=cookie,cookies,secret-header'
```

#### <a name="api-timeout"></a>API Timeout Milliseconds

> Note: Controls the timeouts for PerimeterX requests. The API is called when a Risk Cookie does not exist, or is expired or invalid.

API Timeout in milliseconds (float) to wait for the PerimeterX server API response.

**Default:** 1000

```bash
--data 'config.s2s_timeout=250'
```

#### <a name="debug-mode"></a> Debug Mode

Enables debug logging mode.

**Default:** false

```bash
--data 'config.px_debug=true'
```

#### <a name="real-ip"></a> Extracting the real IP address from a request

> Note: It is important that the real connection IP is properly extracted when your NGINX server sits behind a load balancer or CDN. The PerimeterX module requires the user's real IP address.

For the PerimeterX NGINX module to see the real user's IP address, you need to set `ip_headers`, a list of headers to extract the real IP from, ordered by priority.

**Default with no predefined header: `ngx.var.remote_addr`**

Example:

```bash
--data 'config.ip_headers=X-TRUE-IP,X-Forwarded-For'
```

#### <a name="customblockpage"></a> Custom Block Page

Customizing block page can be done by 2 methods:

##### Modifying default block pages

PerimeterX default block page can be modified by injecting custom css, javascript and logo to page

**default values:** nil

Example:

```bash
--data 'config.custom_logo= http://www.example.com/logo.png'
--data 'config.css_ref=http://www.example.com/style.css'
--data 'config.js_ref=http://www.example.com/script.js'
```

##### Redirect to a custom block page url

Users can customize the blocking page to meet their branding and message requirements by specifying the URL to a blocking page HTML file. The page can also implement reCaptcha. See [NGINX plugin docs](https://github.com/PerimeterX/perimeterx-nginx-plugin/tree/master/examples) for examples of a customized Captcha page.

**default:** nil

```bash
--data 'config.custom_block_url=http://www.example.com/block.html'
```

> Note: This URI **MUST** be whitelisted under `config.whitelist.uri_full` to avoid infinite redirects to the block page.

#### <a name="api-protection"></a> API Protection Mode

For the case where kong is used for API calls and not serving HTML pages, users can set the plugin into API protection mode.

In this mode, when the system decides to block a request, instead of rendering an HTML block/captcha page, it will return a JSON object
that contains a URL for optional redirect on the user's client side.

The end user can be redirected this way to a custom captcha page, and after solving the captcha challenge, will be redirected back to the page they came from or to a default location.

##### Note

When setting the configuration of `api_protection_mode` to `true`, users must also set `api_protection_block_url` which is the address of the custom block page,
and api_protection_default_redirect_url which is the default location for redirect after solving captcha.

Example:

```bash
--data 'config.api_protection_mode=true'
--data 'config.api_protection_block_url=http://www.example.com/block.html'
--data 'config.api_protection_default_redirect_url=http://www.example.com/home.html'
```

Response may look like:

```json
{
    "reason": "blocked",
    "redirect_to": "http://www.example.com/block.html?url=aHR0cDovL2xvY2FsaG9zdDo4MDAwLz9nZmQ9ZmdkZmc=&uuid=11a12b80-b40c-11e7-8050-eb8403f523e5&vid=ef77a690-9bc8-11e7-9c31-970ffdcc0e6d"
}
```

#### <a name="redirect_on_custom_url"></a> Redirect on Custom URL

The `_M.redirect_on_custom_url` flag provides 2 options for redirecting users to a block page.

**default:** false

```bash
--data 'config.redirect_on_custom_url=false'
```

By default, when a user crosses the blocking threshold and blocking is enabled, the user will be redirected to the block page defined by the `_M.custom_block_url` variable, responding with a 307 (Temporary Redirect) HTTP Response Code.

Setting the flag to flase will *consume* the page and serve it under the current URL, responding with a 403 (Unauthorized) HTTP Response Code.

> *Setting the flag to **false** does not require the block page to include any of the coming examples, as they are injected into the blocking page via the PerimeterX Nginx Enforcer.*

Setting the flag to **true** (enabling redirects) will result with the following URL upon blocking:

```
http://www.example.com/block.html?url=L3NvbWVwYWdlP2ZvbyUzRGJhcg==&uuid=e8e6efb0-8a59-11e6-815c-3bdad80c1d39&vid=08320300-6516-11e6-9308-b9c827550d47
```

> Note: the **url** variable is comprised of URL Encoded query parameters (of the originating request) and then both the original path and variables are Base64 Encoded (to avoid collisions with block page query params).

###### Custom blockpage requirements

When captcha is enabled, and `_M.redirect_on_custom_url` is set to **true**, the block page **must** include the following:

- The `<body>` section **must** include:

````html
<div id="px-captcha"></div>
<script>
    window._pxAppId = '<APP_ID>';
    window._pxJsClientSrc = 'https://client.perimeterx.net/<APP_ID>/main.min.js';
    window._pxHostUrl = 'https://collector-<APP_ID>.perimeterx.net';
</script>
<script src="https://captcha.px-cdn.net/<APP_ID>/captcha.js?a=c&m=0"></script>

#### Configuration example: ```bash --data 'config.custom_block_url=/block.html' --data 'config.redirect_on_custom_url=true'
````

#### Block page implementation full example

```html
<html>
    <head> </head>
    <body>
        <h1>You are Blocked</h1>
        <p>Try and solve the captcha</p>
        <div id="px-captcha"></div>
        <script>
            window._pxAppId = '<APP_ID>';
            window._pxJsClientSrc = 'https://client.perimeterx.net/<APP_ID>/main.min.js';
            window._pxHostUrl = 'https://collector-<APP_ID>.perimeterx.net';
        </script>
        <script src="https://captcha.px-cdn.net/<APP_ID>/captcha.js?a=c&m=0"></script>
    </body>
    <html></html>
</html>
```

#### <a name="multipleapps"></a> Multiple App Support

The PerimeterX Enforcer allows for multiple configurations for different apps.

If your PerimeterX account contains several Applications (as defined via the portal), follow these steps to create different configurations for each Application.

Since Kong supports multiple APIs, you can also use the same PerimeterX Application with different configuration for different APIs, but for best results in our detection,
it is best to use different Applications and policies for different APIs.

#### <a name="add-activity-handler"></a> Additional Activity Handler

Adding an additional activity handler is done by setting `additional_activity_handler` property with an user defined function. The 'additional_activity_handler' function will be executed before sending the data to the PerimeterX portal.
Because of technical limitations of the Kong platform, you can't set this function using the admin API. Instead, you need to edit the PerimeterX plugin's `handler.lua`
file, and add the function directly to the configuration.

Default: nil

```lua
function additional_activity_handler(event_type, ctx, details)
 local cjson = require "cjson"
 if (event_type == 'block') then
  ngx.log(ngx.ERR, "PerimeterX: [" .. event_type .. "] blocked with score: " .. ctx.block_score .. ". Details: " .. cjson.encode(details))
 else
  ngx.log(ngx.ERR, "PerimeterX: [" .. event_type .. "]. Details: " .. cjson.encode(details))
 end
end

function PXHandler:init_worker(config)
    ...
    config.additional_activity_handler = additional_activity_handler
end
```

### <a name="custom-parameters"> Enrich Custom Parameters

Adding an Enrich Custom Parameters function is done by setting `enrich_custom_params` property with an user defined anonymous function. With the `enrich_custom_params` function you can add up to 10 custom parameters to be sent back to PerimeterX servers. When set, the function is called before setting the payload on every request to PerimeterX servers. The parameters should be passed according to the correct order (1-10).
You must return the `px_custom_params` object at the end of the function.

Default: nil

```lua
plugins:
    - name: perimeterx
      config:
          ...
          enrich_custom_parameters:
              - |
                  -- Must return an anonymous function that accepts a table as an argument
                  return function(px_custom_params)
                  -- custom_params is a table you can add values to.

                  -- custom_param 1: Add a static value
                  px_custom_params["custom_param1"] = "gold"

                  -- custom_param 2: Add a value from the request headers
                  local user_id = kong.request.get_header("X-User-ID")
                  if user_id then
                      px_custom_params["custom_param2"] = user_id
                  end

                  -- custom_param 3: Add the consumer's username if available
                  local consumer = kong.client.get_consumer()
                  if consumer and consumer.username then
                      px_custom_params["custom_param3"] = consumer.username
                  end

                  -- return the updated px_custom_params table
                  return px_custom_params
                  end


```

#### <a name=""></a> Additional Activity Handler

Adding an additional activity handler is done by setting 'additional_activity_handler' configuration directive with a user defined function. The 'additional_activity_handler' function will be executed before sending the data to the PerimeterX portal.
Because of technical limitations of the Kong platform, you can't set this function using the admin API. Instead, you need to edit the PerimeterX plugin's `handler.lua`
file, and add the function directly to the configuration.

Default: not set.

```lua
function additional_activity_handler(event_type, ctx, details)
 local cjson = require "cjson"
 if (event_type == 'block') then
  ngx.log(ngx.ERR, "PerimeterX: [" .. event_type .. "] blocked with score: " .. ctx.block_score .. ". Details: " .. cjson.encode(details))
 else
  ngx.log(ngx.ERR, "PerimeterX: [" .. event_type .. "]. Details: " .. cjson.encode(details))
 end
end

function PXHandler:init_worker(config)
    ...
    --add function to pxconfig here
    config.additional_activity_handler = additional_activity_handler
end
```

#### <a name="custom-cookie-header"></a> Custom Cookie Header

When set, this property specifies a header name which will be used to extract the PerimeterX cookie from, instead of the Cookie header.

> NOTE: Using a custom cookie header requires client side integration to be done as well. Please refer to the relevant [docs](https://docs.perimeterx.com/pxconsole/docs/advanced-client-integration#section-custom-cookie-header) for details.

**Default:** nil

Example:

```bash
--data 'config.config.custom_cookie_header=x-px-cookies'
```

## <a name="whitelisting"></a> Whitelisting

Whitelisting (bypassing enforcement) is configured under in the `whitelist` table.

There are several different types of filters that can be configured.

```
whitelist_uri_full = { _M.custom_block_url },
whitelist_uri_prefixes = {},
whitelist_uri_suffixes = {'.css', '.bmp', '.tif', '.ttf', '.docx', '.woff2', '.js', '.pict', '.tiff', '.eot', '.xlsx', '.jpg', '.csv', '.eps', '.woff', '.xls', '.jpeg', '.doc', '.ejs', '.otf', '.pptx', '.gif', '.pdf', '.swf', '.svg', '.ps', '.ico', '.pls', '.midi', '.svgz', '.class', '.png', '.ppt', '.mid', 'webp', '.jar'},
whitelist_ip_addresses = {},
whitelist_ua_full = {},
whitelist_ua_sub = {},
whitelist_hosts = {}
```

- **whitelist_uri_full** : for value `{'/api_server_full'}` - will filter requests to `/api_server_full?data=1` but not to `/api_server?data=1`
- **whitelist_uri_prefixes** : for value `{'/api_server'}` - will filter requests to `/api_server_full?data=1` but not to `/full_api_server?data=1`
- **whitelist_uri_suffixes** : for value `{'.css'}` - will filter requests to `/style.css` but not to `/style.js`
- **whitelist_ip_addresses** : for value `{'192.168.99.1'}` - will filter requests coming from any of the listed ips.
- **whitelist_ua_full** : for value `{'Mozilla/5.0 (compatible; pingbot/2.0; http://www.pingdom.com/)'}` - will filter all requests matching this exact UA.
- **whitelist_ua_sub** : for value `{'GoogleCloudMonitoring'}` - will filter requests containing the provided string in their UA.
- **whitelist_hosts** : for value `{'www.example.com'}` - will filter requests coming from the provided host.

## <a name="advancedBlockingResponse"></a> Advanced Blocking Response

In special cases, (such as XHR post requests) a full Captcha page render might not be an option. In such cases, using the Advanced Blocking Response returns a JSON object continaing all the information needed to render your own Captcha challenge implementation, be it a popup modal, a section on the page, etc. The Advanced Blocking Response occurs when a request contains the *Accept* header with the value of `application/json`. A sample JSON response appears as follows:

```javascript
{
    "appId": String,
    "jsClientSrc": String,
    "firstPartyEnabled": Boolean,
    "vid": String,
    "uuid": String,
    "hostUrl": String,
    "blockScript": String
}
```

Once you have the JSON response object, you can pass it to your implementation (with query strings or any other solution) and render the Captcha challenge.

In addition, you can add the `_pxOnCaptchaSuccess` callback function on the window object of your Captcha page to react according to the Captcha status. For example when using a modal, you can use this callback to close the modal once the Captcha is successfullt solved. <br/> An example of using the `_pxOnCaptchaSuccess` callback is as follows:

```javascript
window._pxOnCaptchaSuccess = function (isValid) {
    if (isValid) {
        alert('yay');
    } else {
        alert('nay');
    }
};
```

For details on how to create a custom Captcha page, refer to the [documentation](https://docs.perimeterx.com/pxconsole/docs/customize-challenge-page)

## <a name="additional-information"></a> Additional Information

### URI Delimiters

PerimeterX processes URI paths with general- and sub-delimiters according to RFC 3986. General delimiters (e.g., `?`, `#`) are used to separate parts of the URI. Sub-delimiters (e.g., `$`, `&`) are not used to split the URI as they are considered valid characters in the URI path.

## <a name="contributing"></a> Contributing

The following steps are welcome when contributing to our project.

### Fork/Clone

[Create a fork](https://guides.github.com/activities/forking/) of the repository, and clone it locally.
Create a branch on your fork, preferably using a descriptive branch name.

### Pull Request

After you have completed the process, create a pull request. Please provide a complete and thorough description explaining the changes. Remember, this code has to be read by our maintainers, so keep it simple, smart and accurate.

### Thanks

After all, you are helping us by contributing to this project, and we want to thank you for it.
We highly appreciate your time invested in contributing to our project, and are glad to have people like you - kind helpers.
