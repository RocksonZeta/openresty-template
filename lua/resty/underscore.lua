--file: underscore.lua
--author: rockson zeta
--version 0.0.1
local ngx_null = ngx and ngx.null

local ok, new_tab = pcall(require, "table.new")
if not ok or type(new_tab) ~= "function" then
    new_tab = function (narray, nhash) return {} end
end

local _M = {
	_VERSION = 0.1
}

-- general methods

function _M.is_userdata_nil(o)
	if ngx_null then 
		return ngx_null == o
	end
	if tostring(n) == 'userdata: NULL' then return true end
	return false
end

function _M.is_null(o)
	if nil == o then return true end
	if 'userdata' == type(o) then return is_userdata_nil(o) end

end

function _M.is_false(o)
	if o==nil or o==0 or false==o or ''==o or _M.is_userdata_nil(o) then return true else return false end
end



-- collection methods
function _M.is_empty_table(t)
	if t == nil or next(t) == nil then return true else return false end

end
function _M.is_not_empty_table(t)
	return not _M.is_empty_table(t)
end

function _M.each(list,iteratee)
	if nil == list then return nil end
	for k, v in next, list do
		iteratee(v,k)
	end
end
function _M.map(list,iteratee)
	if nil == list then return nil end
	local r = new_tab(#list,0)
	for k, v in next, list do
		r[i]= iteratee(v,k) 
	end
	return r
end
function _M.reduce(list,iteratee,memo)
	if nil == list then return nil end
	local r = new_tab(#list,0)
	for k, v in next, list do
		memo= iteratee(memo,v,k) 
	end
	return memo
end
function _M.reduce_right(list,iteratee,memo)
	if nil == list then return nil end
	for i,v in ipairs(list) do
		memo= iteratee(memo,k,i)
	end
	return memo
end
function _M.find(list,predicate)
	if nil == list then return nil end
	local t = 'function' == type(predicate) and true or false
	for k, v in next, list do
		if t and predicate(v,k) or v == predicate then return v,k end
	end
end
function _M.filter(list,predicate)
	if nil == list then return nil end
	local r = {}
	local t = 'function' == type(predicate) and true or false
	for k, v in next, list do
		if t and predicate(v,k) or v == predicate then table.insert(r,v) end
	end

end
function _M.where(list,properties)

end
function _M.find_where(list,properties)

end
function _M.reject(list,predicate)

end
function _M.every(list,predicate)

end
function _M.some(list,predicate)

end
function _M.contains(list,value,from_index)

end
function _M.invoke(list,method_name)

end
function _M.pluck(list,property_name)

end
function _M.max(list,iteratee)

end
function _M.min(list,iteratee)

end
function _M.sort_by(list,iteratee)

end
function _M.group_by(list,iteratee)

end
function _M.index_by(list,iteratee)

end
function _M.count_by(list,iteratee)

end
function _M.shuffle(list)

end
function _M.sample(list,n)

end
function _M.to_array(list)

end
function _M.size(list)

end
function _M.partition(list,predicate)

end
-- array methods 
function _M.first(array,n)

end
function _M.initial(array,n)

end
function _M.last(array,n)

end
function _M.rest(array,index)

end
function _M.compact(array)

end
function _M.flatten(array,shallow)

end
function _M.without(array,values)

end

function _M.union(arrays)

end
function _M.intersection(arrays)

end
function _M.difference(arrays,others)

end
function _M.uniq(arrays,is_sorted, iteratee)

end
function _M.zip(arrays)

end
function _M.unzip(array)

end
function _M.object(list, values)

end
function _M.index_of(array,value,is_sorted)

end

function _M.sorted_index(array,value,iteratee)

end
function _M.find_index(array,predicate)

end
function _M.find_lastI_index(array,predicate)

end
function _M.range(start, stop, step)

end
-- function methods
function _M.partial(fn,args)

end
function _M.memoize(fn,hash_function)

end
function _M.delay(fn,wait,args)

end
function _M.throttle(fn,wait,options)

end
function _M.debounce(fn,wait,immediate)

end
function _M.once(fn)

end
function _M.after(count,fn)

end
function _M.before(count,fn)

end
function _M.wrap(fn,wrapper)

end
function _M.negate(predicate)

end
function _M.compose(fns)

end

-- object methods
function _M.keys(object)
	local r = {}
	for k,v in pairs(object) do
		r.insert(k)
	end
	return k
end
function _M.all_keys(object)

end
function _M.values(object)
	local r = {}
	for k,v in pairs(object) do
		r.insert(v)
	end
	return k
end
function _M.map_object(object,iteratee)

end
function _M.pairs(object)
	if nil == list then return nil end
	local r = {}
	for k, v in next, list do
		table.insert({k,v})
	end
	return r
end
function _M.unpairs(list_array)
	if nil == list then return nil end
	local r = new_tab(0 , math.ceil(#list_array/2))
	for i,v in ipairs(list_array) do
		r[v[1]] = v[2]
	end
	return r
end
function _M.invert(object)

end
function _M.create(object)

end
function _M.functions(object)

end
function _M.find_key(object,predicate)

end
function _M.extend(dst, ...)
	if nil == dst and 0==#{...} then return nil end
	for i,v in ipairs({...}) do
		if nil ~= v and 'table' == type(v) then
			for k,y in pairs(v) do
				dst[k] = y
			end
		end
	end
	return dst
end
function _M.extend_own(dst, ...)
	if nil == dst and 0==#{...} then return nil end
	for i,v in ipairs({...}) do
		if nil ~= v and 'table' == type(v) then
			for k,y in pairs(v) do
				if nil~=dst[k] then 
					dst[k] = y
				end
			end
		end
	end
	return dst
end
function _M.pick(object,...)
	if nil == object or 0==#{...} then return object end
	local r = new_tab(0,#{...})
	for i,v in ipairs({...}) do
		r[v] = object[v]
	end
	return r
end
function _M.omit(object,keys)

end
function _M.defaults(object,defaults)

end
function _M.clone(object)

end
function _M.tap(object,interceptor)

end
function _M.has(object,key)

end
function _M.property(key)

end
function _M.property_of(object)

end
function _M.matcher(object)

end
function _M.is_equal(object)

end
function _M.is_match(object)

end
function _M.is_array(object)

end
function _M.is_object(object)

end
function _M.is_function(object)

end
function _M.is_string(object)

end
function _M.is_number(object)

end
function _M.is_finite(object)

end
function _M.is_boolean(object)

end
function _M.is_nan(object)

end

function _M.isError(object)

end

--utility methods
function _M.no_conflict()

end

function _M.identity(value)

end
function _M.constant(value)

end
function _M.noop()

end
function _M.times(n, iteratee)

end
function _M.random(min,max)

end
function _M.mixin(object)

end
function _M.iteratee(value)

end
function _M.escape(value)

end
function _M.unescape(value)

end
function _M.result(object, property)

end
function _M.now()

end
function _M.template(value)

end

-- string methods

-- Determines if the specified character is white space. A character is a  whitespace character if and only if it satisfies one of the following criteria: ◦ It is a Unicode space character (SPACE_SEPARATOR, LINE_SEPARATOR, or PARAGRAPH_SEPARATOR) but is not also a non-breaking space ('\u00A0', '\u2007', '\u202F'). 
-- ◦ It is '\t', U+0009 HORIZONTAL TABULATION. 
-- ◦ It is '\n', U+000A LINE FEED. 
-- ◦ It is '\u000B', U+000B VERTICAL TABULATION. 
-- ◦ It is '\f', U+000C FORM FEED. 
-- ◦ It is '\r', U+000D CARRIAGE RETURN. 
-- ◦ It is '\u001C', U+001C FILE SEPARATOR. 
-- ◦ It is '\u001D', U+001D GROUP SEPARATOR. 
-- ◦ It is '\u001E', U+001E RECORD SEPARATOR. 
-- ◦ It is '\u001F', U+001F UNIT SEPARATOR. 
-- or '\u000B'==char or '\u001C'==char or '\u001D'==char or '\u001E'==char or '\u001F'==char
function _M.is_whitespace(char)
	local b = string.byte(char)
	return _M.is_whitespace_byte(b)
end
function _M.is_whitespace_byte(b)
	return (b>=9 and b<=13) or (b>=28 and b<=32)
end
function _M.is_not_empty_str(str)
	return not _M.is_empty_str(str)
end
function _M.is_empty_str(str)
	if nil ==str or '' == str then return true end;
	for i=1,#str do
		if not _M.is_whitespace_byte(string.byte(str,i)) then return false end
	end
	return true
end
function _M.utf8_len(str)
	local len = #str;
	local left = len;
	local cnt = 0;
	local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc};
	while left ~= 0 do
	local tmp=string.byte(str,-left);
	local i=#arr;
	while arr[i] do
	if tmp>=arr[i] then left=left-i;break;end
	i=i-1;
	end
	cnt=cnt+1;
	end
	return cnt;
end

function _M.is_blank(str)

end

function _M.start_with(str,prefix)

end
function _M.end_with(str,suffix)

end
function _M.index_of(str,sub,from_index)

end
function _M.index_of_str(str,sub,from_index)
	if nil == str then return nil end
	from_index = from_index or 1
	local count = 0
	local b
	for j=from_index,#str do
		for i=1,#sub do
			if string.byte(str,j+count) == string.byte(sub,i) then
				count = count+1
				if count == #sub then return j end
			else
				count = 0
				break
			end
		end
	end
end
function _M.last_index_of_str(str,sub,end_index)
	if nil == str then return nil end
	end_index = end_index or #str
	local count = 0
	for j=(#str-#sub+1),1,-1 do
		for i=1,#sub do
			if string.byte(str,j+count) == string.byte(sub,i) then
				count = count+1
				if count == #sub then return j end
			else
				count = 0
				break
			end
		end
	end
end

function _M.last_index_of(countable,sub,from_index)
	if nil == countable or sub==nil then return nil end
	from_index = from_index or 1
	if 'string' == type(countable) then
		return _M.last_index_of_str(countable,sub,from_index)
	end
	if 'table' == type(countable) then
		for i=#countable,from_index,-1 do
			if countable[i] == sub then
				return i
			end
		end

	end
end

function _M.suffix(str,sep)
	sep = sep or '.'
	local i = _M.last_index_of_str(str,sep)
	if nil == i then return nil end
	return string.sub(str, i+#sep)
end
function _M.prefix(str,sep)
	sep = sep or '.'
	local i = _M.index_of_str(str,sep)
	if nil == i then return nil end
	return string.sub(str, 1,i-#sep)
end
function _M.equal_ignore_case(str1,str2)

end
function _M.char_at(str,i)

end

-- Each of these functions return a 2nd value letting
-- the caller know if the string was changed at all
function _M.ltrim(s)
	local res = s
	local tmp = string.find(res, '%S')

	-- string.sub() will create a duplicate if
	-- called with the first and last index
	-- (str_sub() in lstrlib.c)

	if not tmp then
		res = ''
	elseif tmp ~= 1 then
		res = string.sub(res, tmp)
	end

	return res, res ~= s
end
function _M.rtrim(s)
	local res = s
	local tmp = string.find(res, '%S%s*$')

	if not tmp then
		res = ''
	elseif tmp ~= #res then
		res = string.sub(res, 1, tmp)
	end
			
	return res, res ~= s
end

function _M.trim(s)
	local res1, stat1 = ltrim(s)
	local res2, stat2 = rtrim(res1)
	return res2, stat1 or stat2
end

function _M.split(s,delim)
	if type(delim) ~= "string" or string.len(delim) <= 0 then
        return
    end
    local start = 1
    local t = {}
    while true do
    local pos = string.find (s, delim, start, true) -- plain find
        if not pos then
          break
        end

        table.insert (t, string.sub (s, start, pos - 1))
        start = pos + string.len (delim)
    end
    table.insert (t, string.sub (s, start))

    return t
end

function _M.left(str,n)
	if n<=#str then return string.sub(str,1,n) else return str end
end
function _M.right(str,n)
	if n<=#str then return string.sub(str,#str-n+1) else return str end
end
function _M.capitalize(str)
	if nil == str then return nil end
	local b = string.byte(str,1)
	if b > 96 and b < 123 then return string.char(b-32)..string.sub(str,2) end
end
function _M.uncapitalize(str)
	if nil == str then return nil end
	local b = string.byte(str,1)
	if b > 64 and b < 91 then return string.char(b+32)..string.sub(str,2) end
end
function _M.chomp(str,n)

end
function _M.has_sub(str,sub)

end
function _M.is_numeric(str,sub)

end

-- object list methods , such as {{name="jim",age=20},{name="tom",age=22}}
function _M.index(list,key)
	local r = {}
	for i,v in ipairs(list) do
		if nil~= v[key] then
			if nil == r[v[key]] then r[v[key]]={v} else table.insert(r[v[key]] , v) end
		end
	end 
	return r
end

function _M.index_one(list,key)
	local r = {}
	for i,v in ipairs(list) do
		if nil~= v[key] then
			r[v[key]]=v
		end
	end 
	return r
end

-- os methods

function _M.copy(src, dst)

end

return _M