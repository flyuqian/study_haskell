-- 高阶函数与复合函数


-- 高阶函数：以其他函数作为参数，或者 以函数作为返回结果
--    由于以参数作为返回结果只是柯里化函数的特点，所以高阶函数常常特指那些以函数作为参数的函数



-- 简单高阶函数

-- 自定义 只考虑二元函数 的 curry uncurry
-- curry:: ((a, b) -> c) -> (a -> b -> c)
-- uncurry :: (a -> b -> c) -> (a, b) -> c

-- 高阶函数常常是某一些有共同特点的函数更为一般的形式
-- 一个列表中所有数字的平方
power2 :: Num a => [a] -> [a]
power2 [] = []
power2 (x:xs) = x^2 : power2 xs
-- 列表所有元素 +1
plus1 :: Num a => [a] -> [a]
plus1 [] = []
plus1 (x:xs) = (x+1): plus1 xs

-- 这两个函数等价于 map(^2) map(+1)
-- 那么 map 则是可以表达 plus1 和 power1 这一类函数的 更为一般的函数

-- 5.8 章中定义的很多不动点函数，都是高阶函数，比如：
fix1 :: (a->a) -> a
fix1 f = (fix1 f)

-- fix2 :: (a -> a) -> a
-- fix2 f x | x == f x = x
--          | otherwise = fix2 f (f x)

fix3 :: (t -> t -> Bool) -> (t -> t) -> t -> t
fix3 c f x | c x (f x) = x
           | otherwise = fix3 c f (f x)
-- 这一类函数就是为了应用一个函数多次而编写的更为一般函数


-- 在4章中， 介绍过 iterate 函数计算等比数列，但是有时不想得到该数列，而是得到数列的某一项，这是可以这样定义

geopro n = last $ take n (iterate (*2) 1)
-- 这样写， 计算过程中存储了很多不必要的东西
apply :: (a -> a) -> Int -> a -> a
apply f 0 x = x
apply f n x = apply f (n-1) (f x)
-- apply f _ x = x -- 编译器提示 多余




-- 折叠函数 foldr foldl
-- foldr 向右折叠， foldl 向左折叠
-- 定义 sum 和 and
sum' xs = foldr (+) 0 xs
and' xs = foldr (&&) True xs

insert :: Ord a => a -> [a] -> [a]
insert x [] = [x]
insert x (y:ys) | x < y = x : y : ys
                | otherwise = y : insert x ys
isort :: Ord a => [a] -> [a]
isort xs = foldr insert [] xs

-- 讲一个有多个连续元素的列表 压缩为一个没有连续相同元素的列表
-- skip 元素插入 列表，若列表首元素与该元素相同则不插入
skip :: Eq a => a -> [a] -> [a]
skip x [] = [x]
skip x (y:ys) | x == y = (y:ys)
              | otherwise = x:y:ys
compress :: Eq a => [a] -> [a]
compress = foldr skip []
{-
compress [1, 1, 3, 3]
foldr skip [] [1, 1, 3, 3]
skip 1 (foldr skip [] [1, 3, 3])
-}