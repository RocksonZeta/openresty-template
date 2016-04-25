local redis = require "resty.redis"
local redisex = require "resty.redisex"
local log = require "resty.log"
local _M = {}

function _M.get() 
    local red = redis:new()

    red:set_timeout(1000) -- 1 sec

    -- or connect to a unix domain socket file listened
    --     local ok, err = red:connect("unix:/path/to/redis.sock")
    local ok, err = red:connect(CONF.redis.host, CONF.redis.port)
    if not ok then
        ngx.log(ngx.ERR, "failed to connect redis",err)
        return
    end
    return red

end


function _M.keepalive(red)
    if nil == red then return end
    local ok, err = red:set_keepalive(10000, 100)
    if not ok then
        log.error( "failed to keepalive redis",err)
    return
    end
end

function _M.with(cb)
    local red = _M.get()
    local e,r = xpcall(cb,function(e) log.error(debug.traceback()) end, redisex:new(red , 3600))
    _M.keepalive(red)
    return r
end

return _M