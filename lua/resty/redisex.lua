--file:redisex.lua
local log = require "resty.log"
local json = require('cjson')
local _M = {}

local function to_map(t)
	local r ={}
	for i =1,#t,2 do
		r[t[i]] = json.decode(t[i+1])
		if ngx.null == r[t[i]] then
			r[t[i]] = nil
		end
	end
	return r
end

function _M:new(redis , expire)
	local o = {redis=redis , expire = expire}
	_M.__index = _M
	setmetatable(o , _M)
	return o
end


function _M:get(k)
	local r,e= self.redis:get(k)
	if e then
		log.error("redisex get failed ",e)
		return nil,e
	end
	if ngx.null == r then
		return nil
	end
	return r
end

function _M:set(k,v)
	local ok,e;
	if nil == self.expire then 
		ok,e= self.redis:set(k,v)
	else
		ok,e= self.redis:setex(k,self.expire,v)
	end
	if e then
		log.error("redisex set failed ",e)
		return nil,e
	end
	return ok
end

function _M:get_json(k) 
	local r,e = self:get(k)
	if e then
		log.error("redisex get_json failed ",e)
		return nil,e
	end
	local r = json.decode(r)
	if ngx.null ==r then
		return nil
	end
	return r
end

function _M:set_json(k,v) 
	local jv = json.encode(v)
	if nil == self.expire then
		ok,e= self.redis:set(k,jv)
	else
		ok,e= self.redis:setex(k,self.expire,jv)
	end
	if e then
		log.error("redisex set_json failed ",e)
		return nil,e
	end
	return ok
end
--@param v : {k=v} , v is table
function _M:hmset_json(k,v)
	local r = {}
	for i,j in pairs(v) do
		r[i] = json.encode(j)
	end
	local ok,e= self.redis:hmset(k,r)
 	if e then
 		log.error("redisex hmset_json failed ",e)
		return nil,e
	end
	if nil ~= self.expire then
		self.redis:expire(self.expire)
	end
	return ok
end

function _M:hmget_json(k)
	local r ,e = self.redis:hgetall(k)
	if e then
		log.error("redisex hmget_json failed ",e)
		return nil,e
	end
	if ngx.null == r or 0 == #r then
		return nil
	end
	
	return to_map(r)
end

return _M