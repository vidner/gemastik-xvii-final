local cjson = require "cjson"

local _M = {}

function _M.handler(r)
    r.content_type = "application/json"
    r:write(cjson.encode({
        user = {
            id = r.notes.kauth_id,
            name = r.notes.kauth_name,
        }
    }))
    return apache2.OK
end

return _M
