local cjson = require "cjson"

local db = require "database"
local util = require "lib.utils"

local _M = {}

function _M.post(r)
    local cost = 0x0
    r.content_type = "application/json"

    local items = db.get_items_from_cart(tonumber(r.notes.kauth_id), true)
    for i = 1, #items do
        cost = cost + items[i].price
    end

    local wallet, err = db.get_wallet(tonumber(r.notes.kauth_id))
    if err then
        r.status = 500
        r:write(cjson.encode({
            error = "Internal error: " .. err,
        }))
        return apache2.OK
    end

    if wallet < cost then
        r.status = 401
        r:write(cjson.encode({
            error = "Unathorized: not enough balance",
        }))
        return apache2.OK    
    end

    r:write(cjson.encode({
        items = items,
    }))
    return apache2.OK
end

return _M
