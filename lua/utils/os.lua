
local _M = {}
function _M.is_win()
	return '/' ~= package.config:sub(1,1)
end

function _M.mkdirs(path)
	local cmd = "mkdir -p "..path
	if _M.is_win() then
		cmd = "mkdir "..string.gsub(path , '/','\\')
	end
	return os.execute(cmd)
end

function _M.mv(src,dst)
	local cmd = "mv "..src..' '..dst
	if _M.is_win() then
		cmd = "move /Y "..string.gsub(src , '/','\\')..' '..string.gsub(dst , '/','\\')
	end
	return os.execute(cmd)
end

function _M.exists_dir(dst)
	return 0 == os.execute( "cd " .. string.gsub(dst , '/','\\') )
end

function _M.exists(name)
	if nil == name then return false end
	if _M.is_win() then
		name = string.gsub(name , '/','\\')
	end
    if type(name)~="string" then return false end
    return os.rename(name,name) and true or false
end
function _M.exec(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	return result
end
return _M