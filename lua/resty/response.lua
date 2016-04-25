-- file: response.lua
local json = require('cjson')
local template = require('resty.template')

local ngx_say = ngx.say
local ngx_redirect = ngx.redirect
local json_encode = json.encode
local _M  = {};


function _M:new()
	local o ={}
	setmetatable(o , _M)
	self.__index = self
	return o
end


function _M.status(code)
	ngx.status = code
end

function _M.append(field , value)

end

function  _M.get(field)
	return ngx.header[field]
end

function  _M.set(field , value)
	ngx.header[field] = value
end

function _M.attachment(filename)

	local ua = ngx.req.get_headers()["User-Agent"];
	local f,t= ngx.re.find(ua,"MSIE (?:6.0|7.0|8.0" , "ix")
	if nil == f then
		_M.set('Content-Disposition: attachment; filename="'..ngx.escape_uri(filename)..'"');
	else
	  _M.set('Content-Disposition: attachment; filename*=UTF-8\'\''..ngx.escape_uri(filename));
	end
	_M.set('X-Content-Type-Options: nosniff');
	_M.set('Cache-Control: max-age=0');
end

function _M.cookie(name,value, options)

end

function _M.clearCookie(name , options)

end

function _M.download(path,filename,fn)

end




function _M.json(body)
	ngx_say(json_encode(body))
end

function _M.jsonp(body , cbName)
	if cbName then
		ngx_say(cbName..'('..json_encode(body)..')')
	else
		ngx_say('callback('..json_encode(body)..')')
	end
end

function  _M.sendStatus()

end

function  _M.location(url)
	ngx.header["Location"] = url
	ngx.exit(302)
end

function  _M.redirect(url , status)
	ngx_redirect(url ,status or ngx.HTTP_MOVED_TEMPORARILY)
end

function _M.render(...) 
	template.render(...)

end
function  _M.send(body)
	ngx_say(body)
end
function  _M.sendFile(path,options)

end

return _M