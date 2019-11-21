-- 第6章， 列表内包
-- list comprehension 
-- 指的是， Haskell提供一种精简的语法来对列表中的元素进行处理

-- 1.列表生成器
-- Prelude> [x^2|x <- [0..100], x<10]
-- [0,1,4,9,16,25,36,49,64,81]
--    x <- [0..100] 为生成器， x 取自 [0.。100] 的集合
--    x < 10, 是对x 的限制条件
--    x^2, 是对符合条件的 x 进行转换
--  生成列表可以使用多个生成器，但生成的过程为，写在后边的先被遍历
--    使用列表生成器实现 map 函数 
map' f xs = [f x | x <- xs]
-- 列表内包可以对元素进行有条件的限制，如， 和上边的 x<10
filter' f xs = [x | x <- xs, f x]
-- 限定条件可能不止一个，可以再加入一些限定条件，这些限定条件之前是且的关系
-- Prelude> [x| x <- [0..], even x, x < 100]
-- [0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98

-- 使用列表内包时， 如果不用到生成器中产生的值，可以使用通配符来匹配
length' xs = sum [1 | _ <- xs]

-- 使用列表内包很容易地表达顺序式语言中的循环
-- 用户可以十分方便的生成各种类型的值
-- *Main> [show x ++ "x" ++ show y ++ "=" ++ show (x*y) | y<-[1..9], x<-[1..9]], 打印乘法表




-- 2.素数相关的趣题
-- 素数（质数）
-- factors 得到一个数的因数
factors :: Integral a => a -> [a]
factors n = [x| x<-[1..n], mod n x == 0]
-- 检验一个数是否是素数
isPrime :: Integral a => a -> Bool
isPrime n = factors n == [1, n] 
-- 1 不是素数
-- 素数生成器
primes :: Integral a => a -> [a]
primes n = [x| x <- [1..n], isPrime x]
-- 以上做法，每次求因数的时候，要从 1~n遍历一次
-- 简化
--    除2以外所有素数都是奇数
--    素数必须是大于等于2的整数
--    对于一个整数 N，若他有一个因为为 p1, 必有另一个因子 p2, 使得 N=p1*p2, 并且 x^2=N, p1 p2 分布在 x 两端，或者 p1=p2=x
--    因为比2大的素数都是奇数，所以一定不会有 偶因数
-- 所以对2单独讨论， 其他的数只需要用它除以所有 3~x (x^2=N)的所有奇数， 若余数全不为0则这个数为素数
isPrime' :: Integral a => a -> Bool
isPrime' 2 = True
isPrime' p = p>1 && (all (\n-> mod p n /= 0) $ takeWhile (\n -> n*n <= p) [3,5..])
-- takeWhile (\n -> n*n <= p) [3,5..] 是求出 3~x 的所有奇数列表
-- 用 (\n-> mod p n /= 0) 检验其中的摸一个
-- 用 all 函数检验是否所有的是否不余0的条件
-- 这个测试不正确，不知道怎么改
nextPrime :: Integer -> Integer
nextPrime a | odd a = if isPrime a then a else nextPrime (a+2)
            | otherwise = nextPrime(a+1)
