local cjson = require "cjson"
cjson.encode_empty_table_as_object(false)

local db = require "database"
local util = require "lib.utils"

local _M = {}

function _M.get(r)
    local items = db.get_all_items()
    r.content_type = "application/json"
    r:write(cjson.encode({
        items = items,
    }))
    return apache2.OK
end

function _M.get_me(r)
    local items = db.get_all_items(tonumber(r.notes.kauth_id))
    r.content_type = "application/json"
    r:write(cjson.encode({
        items = items,
    }))
    return apache2.OK
end

function _M.post(r)
    local input = r:requestbody()
    local spec = cjson.decode(input or "{}")

    if util.isempty(spec.name) then
        r.status = 400
        r:write(cjson.encode({
            error = "Bad Request: missing name"
        }))
        return apache2.OK
    end

    if util.isempty(spec.description) then
        r.status = 400
        r:write(cjson.encode({
            error = "Bad Request: missing description"
        }))
        return apache2.OK
    end

    if util.isempty(spec.valuable) then
        r.status = 400
        r:write(cjson.encode({
            error = "Bad Request: missing valuable"
        }))
        return apache2.OK
    end

    if util.isempty(spec.price) or tonumber(spec.price) <= 0 then
        r.status = 400
        r:write(cjson.encode({
            error = "Bad Request: missing price"
        }))
        return apache2.OK
    end

    r.content_type = "application/json"

    local id, err = db.add_item(tonumber(r.notes.kauth_id), spec.name, spec.description, spec.valuable, tonumber(spec.price))
    if err then
        r:write(cjson.encode({
            error = "Internal error: " .. err,
        }))
        return apache2.OK            
    end

    r:write(cjson.encode({
        message = "Successfully added to catalog",
    }))
    return apache2.OK
end

return _M
