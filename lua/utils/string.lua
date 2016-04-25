
local _M = {}
function _M.suffix(name,sep)
	sep = sep or "."
	local need_escape_str = "().%+-*?[]^$"
	if string.find(need_escape_str,sep) then sep = '%'..sep end
	local s,e= string.find(name,sep.."[%w|_%%]+$")
	if nil == s then return nil end
	return string.sub(name , s+1,e)
end
function _M.is_empty(str)
	if nil == str or ngx.null==str or ''==str then return true end
end

function _M.is_false(o)
	if nil==o or 0==o or ngx.null==o or ''==o then return true end
end

return _M
