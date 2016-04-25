-- file utils

local _M ={}
function _M.copy(src, dst)
	local infile = io.open(src, "rb")
	local outfile = io.open(dst, "wb+")
	local block = 4096
	while true do
		local bytes = infile:read(block)
		if not bytes then break end
		outfile:write(bytes)
	end
	infile:close()
	outfile:close()
end


return _M