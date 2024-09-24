local cjson = require "cjson"

local middleware = require "middleware"
local login = require "handler.login"
local register = require "handler.register"
local user = require "handler.user"
local catalog = require "handler.catalog"
local cart = require "handler.cart"
local checkout = require "handler.checkout"

function handle(r)
    if r.uri == "/api/login" and r.method == "POST" then
        return login.handler(r)
    elseif r.uri == "/api/register" and r.method == "POST" then
        return register.handler(r)
    elseif r.uri == "/api/user" and r.method == "GET" then
        return middleware.auth(r, user.handler)
    elseif r.uri == "/api/catalog" and r.method == "GET" then
        return catalog.get(r)
    elseif r.uri == "/api/catalog/me" and r.method == "GET" then
        return middleware.auth(r, catalog.get_me)
    elseif r.uri == "/api/catalog" and r.method == "POST" then
        return middleware.auth(r, catalog.post)
    elseif r.uri == "/api/cart" and r.method == "GET" then
        return middleware.auth(r, cart.get)
    elseif r.uri == "/api/cart" and r.method == "POST" then
        return middleware.auth(r, cart.post)
    elseif r.uri == "/api/cart" and r.method == "DELETE" then
        return middleware.auth(r, cart.delete)
    elseif r.uri == "/api/checkout" and r.method == "POST" then
        return middleware.auth(r, checkout.post)
    else
        r.status = 404
        r.content_type = "application/json"
        r:write(cjson.encode({
            error = "Not found"
        }))
        return apache2.OK
    end
end