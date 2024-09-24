local kauth = require "kauth"
local cjson = require "cjson"

local database = require "database"
local secret = require "secret"

local _M = {}

function _M.auth(r, fn)
    local session = r:getcookie("session")
    if not session then
        r.status = 401
        r.content_type = "application/json"
        r:write(cjson.encode({
            error = "Unathorized: invalid session"
        }))
        return apache2.OK
    end
    local ok, res = pcall(function ()
        return kauth.decode(secret.key, session)
    end)
    if not ok then
        r.status = 401
        r.content_type = "application/json"
        r:write(cjson.encode({
            error = "Unathorized: " .. res
        }))
        return apache2.OK
    end

    local _, err = database.get_user(res.id)
    if err then
        r.status = 401
        r.content_type = "application/json"
        r:write(cjson.encode({
            error = "Unathorized: invalid session"
        }))
        return apache2.OK
    end

    r.user = res.name
    r.notes.kauth_name = res.name
    r.notes.kauth_id = res.id
    return fn(r)
end

return _M
