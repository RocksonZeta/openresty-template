-- file :hash.lua
local resty_string = require "resty.string"
local resty_md5 = require "resty.md5"

local _M = {}

function _M.md5_file(file)
	local md5 = resty_md5:new()
	local infile = io.open(file, "rb")
	local block = 4096
	while true do
		local bytes = infile:read(block)
		if not bytes then break end
		local ok = md5:update(bytes)
	end
	infile:close()
	local digest = md5:final()
	return resty_string.to_hex(digest)
end

return _M