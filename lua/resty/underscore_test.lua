local _ = require './underscore'
local json = require('cjson')
local function printj(o) print(json.encode(o)) end

assert(_.is_userdata_nil({}) == false)
assert(_.is_false(false) == true)
assert(_.is_false(0) == true)
assert(_.is_false('') == true)
assert(_.is_false({}) == false)
assert(_.is_empty_table() == true)
assert(_.is_empty_table({}) == true)
assert(_.is_empty_table({1}) == false)

-- print(json.encode(_.pick({a=1,b=2},'a',"")))
-- print(json.encode(_.extend({a=1,b=2},'a',"")))
-- print(json.encode(_.extend({a=1,b=2},{c="213",b=123})))
-- print(json.encode(_.index({{a=1,b=2},{c="213",b=123}}, "a")))


assert(1==_.utf8_len("张"))

assert(1 == _.index_of_str('hello.jpg','hello'))

assert('jpg' == _.suffix('hello.jpg'))
assert(nil == _.suffix('hello'))

assert('hello' == _.prefix('hello.jpg'))
assert('jpg' == _.suffix('hello..jpg','..'))
assert(7 == _.last_index_of_str('hello..jpg','.'))
assert(1==_.last_index_of_str('.jpg1','.jpg'))
assert('hello' == _.trim_right('hello.jpg','.jpg'))
assert('hello.jpg' == _.trim_right('hello.jpg   '))
assert('hello' == _.trim_right('hello.jpg','.jpg'))
assert('.jpg' == _.trim_left('hello.jpg','hello'))
assert('Abc' == _.capitalize("abc"))
assert('A' == _.capitalize("a"))
assert('a' == _.uncapitalize("A"))
assert('a' == _.left("abc",1))
assert('c' == _.right("abc",1))

printj(_.split("a_b" ,"_"))
printj(_.split("_b_" ,"_"))
printj(_.split("_b_c_" ,"_"))
printj(_.split("__b_c_d" ,"__"))
