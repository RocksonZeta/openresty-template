local _ = require('resty.underscore')
local log = require('resty.log')
app['/'] = function()
	O.render('index.html')
end
