local cjson = require "cjson"
cjson.encode_empty_table_as_object(false)

local db = require "database"
local util = require "lib.utils"

local _M = {}

function _M.get(r)
    local items = db.get_items_from_cart(tonumber(r.notes.kauth_id))
    r.content_type = "application/json"
    r:write(cjson.encode({
        items = items,
    }))
    return apache2.OK
end

function _M.delete(r)
    local spec = r:parseargs()
    if util.isempty(spec.id) then
        r.status = 400
        r:write(cjson.encode({
            error = "Bad Request: missing id"
        }))
        return apache2.OK
    end

    r.content_type = "application/json"

    local err = db.delete_item_from_cart(tonumber(r.notes.kauth_id), tonumber(spec.id))
    if err then
        r:write(cjson.encode({
            error = "Internal error: " .. err,
        }))
        return apache2.OK
    end

    r:write(cjson.encode({
        message = "Successfully removed from cart",
    }))
    return apache2.OK
end


function _M.post(r)
    local input = r:requestbody()
    local spec = cjson.decode(input or "{}")

    if util.isempty(spec.item) then
        r.status = 400
        r:write(cjson.encode({
            error = "Bad Request: missing name"
        }))
        return apache2.OK
    end

    r.content_type = "application/json"

    local _, err = db.add_to_cart(tonumber(r.notes.kauth_id), tonumber(spec.item))
    if err then
        r:write(cjson.encode({
            error = "Internal error: " .. err,
        }))
        return apache2.OK            
    end

    r:write(cjson.encode({
        message = "Successfully added to cart",
    }))
    return apache2.OK
end

return _M
