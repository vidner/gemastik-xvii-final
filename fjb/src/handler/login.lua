local cjson = require "cjson"
local kauth = require "kauth"

local utils = require "lib.utils"
local db = require "database"
local secret = require "secret"

local _M = {}

function _M.handler(r)
    local input = r:requestbody()
    local spec = cjson.decode(input or "{}")

    r.content_type = "application/json"

    if utils.isempty(spec.username) or utils.isempty(spec.password) then
        r.status = 400
        r:write(cjson.encode({
            error = "Bad Request: missing username or password"
        }))
        return apache2.OK
    end

    local user, err = db.login(spec.username, spec.password)
    if err then
        r.status = 500
        r:write(cjson.encode({
            error = "Internal error: " .. err
        }))
        return apache2.OK
    end

    if not user then
        r.status = 401
        r:write(cjson.encode({
            error = "Unathorized: invalid password or username"
        }))
        return apache2.OK
    end

    local ok, token = pcall(function ()
        return kauth.encode(secret.key, user)
    end)
    if not ok then
        r.status = 500
        r:write(cjson.encode({
            error = "Internal error: failed to generate token"
        }))
        return apache2.OK
    end

    r:setcookie({
        key = "session",
        value = token,
        expires = os.time() + 1800,
    })

    r:write(cjson.encode({
        user = user,
        token = token,
    }))
    return apache2.OK
end

return _M
