

local _M = {}
function _M.now()
	return math.ceil(ngx.now()*1000)
end
function _M.format_datetime(ms)
	if nil == ms then return nil end
	return os.date("%Y-%m-%d %H:%M" , ms/1000)
end
function _M.format_date(ms)
	if nil == ms then return nil end
	return os.date("%Y-%m-%d", ms/1000)
end
function _M.format_time(ms)
	if nil == ms then return nil end
	return os.date("%H:%M", ms/1000)
end
function _M.parse(str)
	if nil == str then return nil end
	if not str or 'string' ~= type(str) then return nil end
	local p
	local y, mon,d,h,min,s 
	if not str:find(':') then
		p = "(%d+)-(%d+)-(%d+)"
		y, mon,d = str:match(p)
	elseif not str:find('-') then
		p = "(%d+):(%d+):(%d+)"
		h,min,s = str:match(p)
	else 
		p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
		y, mon,d,h,min,s = str:match(p)
		if not y then
			p = "(%d+)-(%d+)-(%d+) (%d+):(%d+)"
			y, mon,d,h,min = str:match(p)
		end
	end
	return 1000*os.time({year=y or 1970,month=mon or 1,day=d or 1,hour=tonumber(h) or 0,min=tonumber(min) or 0,sec=tonumber(s) or 0})
end
return _M