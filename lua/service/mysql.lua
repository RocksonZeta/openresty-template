local mysql = require "resty.mysqlex"
local log = require "resty.log"
local errors = require "errors"

local _M ={}
function _M.get_cli()
	local db, err = mysql:new()
    if not db then
        log.error("failed to instantiate mysql: ", err)
        return
    end
    db:set_timeout(3000) -- 1 sec
	local ok, err, errno, sqlstate = db:connect(CONF.mysql_iqidao)

    if not ok then
        log.error("failed to connect: ", err, ": ", errno, " ", sqlstate)
        return
    end
    return db
end

function  _M.keepalive(db)
	local ok, err = db:set_keepalive(10000, 100)
    if not ok then
        log.error("failed to set keepalive: ", err)
        return
    end
end


function _M.with(cb)
	local db = _M.get_cli()
    if nil == db then return end
    local e,r = xpcall(cb,function(e) log.error(debug.traceback()) end, db)
    _M.keepalive(db)
    return r
end
function _M.with_transaction(cb)
    local db = _M.get_cli()
    if nil == db then return end
	db:query("START TRANSACTION");
	local e,r = xpcall(cb,function(e) db:query("ROLLBACK"); log.error(debug.traceback()) end, db)
	db:query("COMMIT")
	_M.keepalive(db)
    return r
end

function _M.q(sql , params)
    return _M.with(function(mysql)
        local r,e = mysql:q(sql, params)
        if e then log.error(e.err,e.errno,e.sqlstate);return nil,errors.mysql end
        return r
    end)
end
function _M.q1(sql , params)
    return _M.with(function(mysql)
        local r,e = mysql:q1(sql, params)
        if e then log.error(e.err,e.errno,e.sqlstate);return nil,errors.mysql end
        return r
    end)
end
function _M.limit(sql , params)
    if params and nil~=params.ps then
        params.si = tonumber(params.si) or 0
        params.ps = tonumber(params.ps)
        sql=sql.." limit {si},{ps}"
    else
        sql = sql.." limit 0,20"
    end
    return sql
end
function _M.page(items , total)
    return {items=items,total=total}
end
function _M.qp(items_sql , count_sql , params)
    return _M.with(function(mysql)
        return _M.qp_with(mysql , items_sql , count_sql,params)
    end)
end
function _M.qp_with(mysql,items_sql , count_sql , params)
    local rs,e = mysql:qs(items_sql..";"..count_sql, params);
    if e then log.error(e.err,e.errno,e.sqlstate);return nil,errors.mysql end
    return _M.page(rs[1] , rs[2][1].count)
end

function _M.post_sql(table,entity)
    local sql = "insert `"..table.."` ("
    local vsql = " values("
    for k,v in pairs(entity) do
        sql = sql..'`'..k..'`,'
        vsql = vsql..mysql.escape_value(v)..','
    end
    return string.sub(sql,1,-2)..')'..string.sub(vsql,1,-2)..')'
end

function _M.put_sql(table, id , values)
    local sql = "update `"..table.."` set "
    for k,v in pairs(values) do
        sql = sql..'`'..k..'`='..mysql.escape_value(v)..','
    end
    return string.sub(sql ,1,-2)..' where id='..mysql.escape_value(id)
end
function _M.get_sql(table, id)
    return "select * from `"..table.."` where id="..mysql.escape_value(id)
end
function _M.del_sql(table, id)
    return "delete from `"..table.."` where id="..mysql.escape_value(id)
end

function _M.post(table,entity)
    return _M.with(function(mysql)
        return mysql:q1(_M.post_sql(table,entity))
    end)
end
function _M.del(table,id)
    return _M.with(function(mysql)
        local r,e = mysql:q1(_M.del_sql(table,id))
        if e then log.error(e.err,e.errno,e.sqlstate);return nil,errors.mysql end
        return r;
    end)
end
function _M.get(table,id)
    return _M.with(function(mysql)
        local r,e = mysql:q1(_M.get_sql(table,id))
        if e then log.error(e.err,e.errno,e.sqlstate);return nil,errors.mysql end
        return r;
    end)
end
function _M.put(table,id,values)
    return _M.with(function(mysql)
        local r,e = mysql:q1(_M.put_sql(table,id,values))
        if e then log.error(e.err,e.errno,e.sqlstate);return nil,errors.mysql end
        return r;
    end)
end
return _M