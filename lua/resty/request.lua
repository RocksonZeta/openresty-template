-- file: request.lua

local ngx_req = ngx.req
local ngx_var = ngx.var

local _M ={}

function _M:new()
	local o = {}
	setmetatable(o ,self)
	self.__index = self
	return o
end


local ps = {
	["method"]  = ngx_req.get_method,
	["url"]  = function() return ngx_var.uri end,
	["query"]  = ngx_req.get_uri_args,
	["body"]  = function() ngx_req.read_body();return ngx_req.get_post_args() end,
	["header"]  = ngx_req.get_headers,
	["cookie"]  = function() return ngx_req.get_headers()["cookie"] end,
	["hostname"]  = function() return ngx_var.server_name end,
	["ip"]  = function() return ngx_var.remote_addr end,
	["ips"]  = function() return ngx_var.remote_addr end,
	["xhr"]  = function() return 'XMLHttpRequest'==ngx_req.get_headers()["X-Requested-With"] end,
	["protocol"]  = function() return ngx_var.scheme end,

}
function _M.gets(t,k)
	local pfn = ps[k]
	if pfn then 
		return pfn()
	end

end
setmetatable(_M , {__index = _M.gets})

return _M