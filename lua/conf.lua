-- global config

local function create_url(protocol,domain,port,path)
    return protocol..'://'..domain..(80==tonumber(port) and "" or ":"..port)..(nil==path and '' or path)
end
local _M = {}

_M.debug = true

_M.mysql = {
    host = "127.0.0.1",
    port = 3306,
    database = "db",
    user = "root",
    password = "password",
    charset = "utf-8",
    max_packet_size = 1024 * 1024
}

_M.redis = {
	host="127.0.0.1",
    port = 6379
}

_M.host= {
    domain="localhost",
    port=6000,
    protocol='http'
}
_M.host.url = create_url(_M.host.protocol,_M.host.domain,_M.host.port)


return _M