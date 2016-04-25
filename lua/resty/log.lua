-- file log.lua
-- version 0.0.1

local _M = {_VERSION="0.0.1"}

function _M.alert(...)
	ngx.log(ngx.ALERT,...)
end
function _M.emerg(...)
	ngx.log(ngx.EMERG,...)
end
function _M.stderr(...)
	ngx.log(ngx.STDERR,...)
end
function _M.crit(...)
	ngx.log(ngx.CRIT,...)
end
function _M.error(...)
	ngx.log(ngx.ERR,...)
end
function _M.warn(...)
	ngx.log(ngx.WARN,...)
end
function _M.notice(...)
	ngx.log(ngx.NOTICE,...)
end
function _M.info(...)
	ngx.log(ngx.INFO,...)
end
function _M.debug(...)
	ngx.log(ngx.DEBUG,...)
end
function _M.log(level,...)
	ngx.log(level,...)
end

return _M