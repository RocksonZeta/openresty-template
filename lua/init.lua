-- file: init.lua
-- init app
CONF= require('conf')
C = require('constant')
app = require('resty.vicky'):new()
I = require('resty.request'):new()
O = require('resty.response'):new()

O.ok = function(data,status) ngx.header.content_type = 'application/json; charset=utf-8';return O.json({status=status or 0,data=data}) end

require('route.index')

if C.DEBUG then
	app.error_handle = function(e)
		res.status(500)
		ngx.say(e)
		ngx.say('<pre>'..debug.traceback()..'</pre>')
	end
end