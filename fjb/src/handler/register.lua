local cjson = require "cjson"

local utils = require "lib.utils"
local db = require "database"

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

    local uid, err = db.register(spec.username, spec.password)
    if err then
        r.status = 500
        r:write(cjson.encode({
            error = "Internal error: " .. err
        }))
        return apache2.OK
    end

    if uid == nil then
        r.status = 400
        r:write(cjson.encode({
            error = "Bad Request: invalid password or username"
        }))
        return apache2.OK
    end

    r:write(cjson.encode({
        message = "Successfully registered"
    }))
    return apache2.OK
end

return _M
