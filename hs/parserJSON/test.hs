-- 类型推到 是一把双刃剑
--    案例， 预计如下函数返回 String类型的值

import Data.Char (toUpper)
upcaseFirst (c:cs) = toUpper c 
-- 这里忘记了 :cs
-- 这个函数应该是 String -> String, 却推导成 String -> Char

camelCase :: String -> String 
camelCase xs = concat (map upcaseFirst (words xs))
-- 这里编译不会通过
-- 如果这里不调用，那么编译将会通过，而完成不了预期需求