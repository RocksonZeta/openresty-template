--file:image.lua 
local utils_os = require "utils.os"
local _ = require 'resty.underscore'
local _M = {}

function _M.icon(src,dst,w)
	local info = _M.identify(src)
	local cmd= string.format("convert %s -resize x%d -gravity center -extent %dx%d %s",src,w,w,w,dst)
	if info.width < info.height then
		cmd= string.format("convert %s -resize %dx -gravity center -extent %dx%d %s",src,w,w,w,dst)
	end
	os.execute(cmd)
end

function _M.resize(src,dst,width,height)
	if not utils_os.exists(src) then return end
	local info = _M.identify(src)
	if nil == info then return end
	local old_width,old_height  = info.width,info.height
	local wr,hr = old_width/width,old_height/height
	local mid_width,mid_height = width , height
	local x,y = 0,0
	if wr<=hr then --user wr
		mid_height = math.ceil(old_height/wr)
		y = math.ceil((mid_height-height)/2*0.6)
	else
		mid_width = math.ceil(old_width/hr)
		x = math.ceil((mid_width-width)/2)
	end
	-- -resize 1024x768 -crop widthxheight+x+y
	local command = string.format("convert %s -resize %dx%d -crop %dx%d+%d+%d %s",src,mid_width,mid_height,width,height,x,y,dst)
	return os.execute(command)
end


--d:/1.jpg	JPEG	2295x1530	2295x1530+0+0	8-bit	sRGB	1.89MB	0.031u	0:00.025
function _M.identify(img)
	local result = utils_os.exec("identify "..img)
	if nil == result then return nil end
	local file,format,size,geometry,depth,color_space,file_size,user_time,elapsed_time = result:match("(%S+) (%S+) (%S+) (%S+) (%S+) (%S+) (%S+) (%S+) (%S+)")
	if not size then return nil end
	local width,height = size:match("(%d+)x(%d+)")
	if not width or not height then
		return nil
	end
	return {width=tonumber(width),height=tonumber(height),file=file,format=format,size=size,geometry=geometry,depth=depth,color_space=color_space,file_size=file_size,user_time=user_time,elapsed_time=elapsed_time}
end

function _M.size_file(f , width,height)
	local i = _.last_index_of_str(f,'.')
	return string.sub(f,1, i)..width..'x'..height..'.'..string.sub(f,i+1)
end

function _M.get_md5_path(md5,ext,typ) 
	local typ = typ or 'image'
	local ext = ext or 'png'
	local root = ngx.var.static_root
	local dir = string.format("%s/%s/%s/%s",root,typ,string.sub(md5,1,2),string.sub(md5,3,4))
	local dst = string.format(dir.."/%s.%s",md5,ext)
	local relative_path = string.format("/%s/%s/%s/%s/%s.%s",_.suffix(root,'/'),typ,string.sub(md5,1,2),string.sub(md5,3,4),md5,ext)
	return relative_path,_.trim_right(dst,relative_path),dst
end
return _M