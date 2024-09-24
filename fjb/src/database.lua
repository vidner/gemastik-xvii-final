local sqlite3 = require "lsqlite3"
local bcrypt = require "bcrypt"

local _M = {}

function _M.register(username, password)
    local user = nil
    local err = nil

    local conn = sqlite3.open("/app/data/fjb.db", sqlite3.OPEN_READWRITE)
    local hashed_password = bcrypt.digest(password, 9)
    local stmt = conn:prepare("INSERT INTO users (username, password) VALUES (?, ?)")
    stmt:bind_values(username, hashed_password)
    local result = stmt:step()

    if result == sqlite3.DONE then
        user = conn:last_insert_rowid()
    elseif result == sqlite3.CONSTRAINT then
    else
        err = conn:errmsg()
    end

    conn:close()
    return user, err
end

function _M.login(username, password)
    local user = nil
    local err = nil

    local conn = sqlite3.open("/app/data/fjb.db")
    local stmt = conn:prepare("SELECT id, username, password FROM users WHERE username = ?")
    stmt:bind_values(username)
    local result = stmt:step()

    if result == sqlite3.ROW then
        local hashed_password = stmt:get_value(2)
        if bcrypt.verify(password, hashed_password) then
            user = {
                name = stmt:get_value(1),
                id = stmt:get_value(0),
            }
        end
    elseif result == sqlite3.DONE then
    else
        err = conn:errmsg()
    end

    conn:close()
    return user, err
end

function _M.get_user(id)
    local user = nil
    local err = nil

    local conn = sqlite3.open("/app/data/fjb.db")
    local stmt = conn:prepare("SELECT username FROM users WHERE id = ?")
    stmt:bind_values(id)
    local result = stmt:step()

    if result == sqlite3.ROW then
        user = stmt:get_value(0)
    else
        err = conn:errmsg()
    end

    conn:close()
    return user, err
end

function _M.get_wallet(id)
    local wallet = nil
    local err = nil

    local conn = sqlite3.open("/app/data/fjb.db")
    local stmt = conn:prepare("SELECT wallet FROM users WHERE id = ?")
    stmt:bind_values(id)
    local result = stmt:step()

    if result == sqlite3.ROW then
        wallet = stmt:get_value(0)
    else
        err = conn:errmsg()
    end

    conn:close()
    return wallet, err
end

function _M.add_item(uid, item_name, description, valuable, price)
    local id = nil
    local err = nil

    local conn = sqlite3.open("/app/data/fjb.db", sqlite3.OPEN_READWRITE)
    local created_at = os.date("!%Y-%m-%dT%H:%M:%S+00:00")
    local stmt = conn:prepare [[
        INSERT INTO catalog
            (user_id, item_name, description, value, price, created_at)
        VALUES (?, ?, ?, ?, ?, ?)
    ]]
    stmt:bind_values(uid, item_name, description, valuable, price, created_at)
    local result = stmt:step()
    if result == sqlite3.DONE then
        id = conn:last_insert_rowid()
    else
        err = conn:errmsg()
    end
    conn:close()
    return id, err
end

function _M.get_all_items(uid)
    local conn = sqlite3.open("/app/data/fjb.db")
    local query = "SELECT * FROM catalog"
    if uid then
        query = query .. " WHERE user_id = ?"
    end
    local stmt = conn:prepare(query)
    if uid then
        stmt:bind_values(uid)
    end
    local items = {}
    local result = stmt:step()
    while result == sqlite3.ROW do
        local id = stmt:get_value(0)
        local user_id = stmt:get_value(1)
        local item_name = stmt:get_value(2)
        local description = stmt:get_value(3)
        local value = stmt:get_value(4)
        local price = stmt:get_value(5)
        local date_posted = stmt:get_value(6)
        table.insert(items, {
            id = id,
            name = item_name,
            description = description,
            owner = user_id,
            value = uid == user_id and value or nil,
            price = price,
            date_posted = date_posted,
        })
        result = stmt:step()
    end
    conn:close()
    return items
end

function _M.get_item(uid, item_id)
    local conn = sqlite3.open("/app/data/fjb.db")
    local stmt = conn:prepare("SELECT * FROM catalog WHERE id = ?")
    stmt:bind_values(item_id)
    local result = stmt:step()
    if result ~= sqlite3.ROW then
        return nil
    end
    local user_id = stmt:get_value(1)
    if user_id ~= uid then
        return nil
    end
    local id = stmt:get_value(0)
    local item_name = stmt:get_value(2)
    local description = stmt:get_value(3)
    local value = stmt:get_value(4)
    local price = stmt:get_value(5)
    local date_posted = stmt:get_value(6)
    local item = {
        id = id,
        name = item_name,
        description = description,
        value = value,
        price = price,
        date_posted = date_posted,
    }
    conn:close()
    return item
end

function _M.add_to_cart(uid, item_id)
    local id = nil
    local err = nil

    local conn = sqlite3.open("/app/data/fjb.db", sqlite3.OPEN_READWRITE)

    local stmt = conn:prepare("SELECT user_id FROM catalog WHERE id = ?")
    stmt:bind_values(item_id)
    local result = stmt:step()
    if result ~= sqlite3.ROW then
        return nil, "invalid item_id"
    end

    if stmt:get_value(0) == uid then
        return nil, "cant add your own item to cart"
    end

    stmt = conn:prepare("INSERT INTO cart (user_id, item_id) VALUES (?, ?)")
    stmt:bind_values(uid, item_id)
    local result = stmt:step()
    if result == sqlite3.DONE then
        id = conn:last_insert_rowid()
    else
        err = conn:errmsg()
    end
    conn:close()
    return id, err
end

function _M.get_items_from_cart(uid, checkout)
    local pay = checkout ~= nil
    local conn = sqlite3.open("/app/data/fjb.db")
    local items = {}
    local stmt = conn:prepare [[
        SELECT car.id, cat.id, cat.item_name, cat.price, cat.value
        FROM cart car
        JOIN catalog cat ON car.item_id = cat.id
        WHERE car.user_id = ?
    ]]
    stmt:bind_values(uid)
    local result = stmt:step()
    while result == sqlite3.ROW do
        local id = stmt:get_value(0)
        local item_id = stmt:get_value(1)
        local name = stmt:get_value(2)
        local price = stmt:get_value(3)
        local valuable = stmt:get_value(4)
        table.insert(items, {
            id = id,
            item_id = item_id,
            name = name,
            price = price,
            valuable = pay and valuable or nil,
        })
        result = stmt:step()
    end
    conn:close()
    return items
end

function _M.delete_item_from_cart(uid, id)
    local err = nil
    local conn = sqlite3.open("/app/data/fjb.db")
    local stmt = conn:prepare [[
        DELETE FROM
            cart
        WHERE 
            user_id = ? AND id = ?
    ]]
    stmt:bind_values(uid, id)
    local result = stmt:step()
    if result ~= sqlite3.DONE then
        err = conn:errmsg()
    end
    conn:close()
    return err
end

return _M
