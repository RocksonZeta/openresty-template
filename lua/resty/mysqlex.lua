--name: mysqlex.lua
--version: 0.0.1

local _M = require "resty.mysql"
local log = require "resty.log"

-- {name} -> 'name'
function _M.escape_sql(sql , params)
	if nil == params then
		return sql
	end
	return ngx.re.gsub(sql,'\\{(\\w+)\\}' , function(m) 
		local key = m[1]
		local value = params[key]
		return _M.escape_value(value);
	end)
end

function _M.escape_value(value)
	if nil == value or ngx.null == value then
		return 'null'
	end
	local t = type(value)
	if 'string' == t then 
		return ngx.quote_sql_str(value)
	end
	if 'boolean' == t then
		if t then return 1 else return 0 end
	end
	return value
end

function _M:q(sql,params,rows)
	local esql = _M.escape_sql(sql,params);
	local r, err, errno, sqlstate = self:query(esql , rows)
	if err~=nil then 
		log.error(string.format("sql:%s,%s,errno:%d,sqlstate:%s",esql,err,errno,sqlstate))
		return nil , {err=err ,errno=errno, sqlstate=sqlstate}
	end
	return r
end

function _M:q1(sql,params)
	local r,e= self:q(sql , params,1)
	if e then return nil ,e end;
	if nil == r or ngx.null==r then return nil end
	if r and 'table' == type(r) and #r>0 then 
		if #r>1 then
			log.warn(string.format("rultset size >1 in q1,%s",_M.escape_sql(sql,params)))
		end
		return r[1]
	else
		for k,v in pairs(r) do
			return r
		end
		return nil
	end
end

function _M:qs(sqls , params) 
	local esql = _M.escape_sql(sqls,params);
    local rs = {}
	local r, err, errno, sqlstate = self:query(esql)
    if err then
        log.error(string.format("sql:%s,%s,errno:%d,sqlstate:%s",esql,err,errno,sqlstate))
        return nil , {err=err ,errno=errno, sqlstate=sqlstate}
    end
    table.insert(rs,r)
    local i = 2
    while err == "again" do
        r, err, errno, sqlstate = self:read_result()
        if not r then
            log.error(string.format("sql:%s,%s,errno:%d,sqlstate:%s",esql,err,errno,sqlstate))
            return nil , {err=err ,errno=errno, sqlstate=sqlstate}
        end
        i = i+1
        table.insert(rs,r)
    end
    return rs
end


return _M