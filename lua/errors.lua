
local _M = {}
_M.MYSQL =10
_M.REDIS =20
_M.HTTP_REQUEST_PARAM_INVALID =100

function _M.new(error_code,error_msg) {
	return {error_code=error_code , error_msg=error_msg}
}
_M.mysql = _M.new(_M.MYSQL)
_M.redis = _M.new(_M.REDIS)

return _M