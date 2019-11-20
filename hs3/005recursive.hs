
-- 递归函数

{-
1. 递归的概念
  一个递归的函数，其定义分为两部分
    递归的基本条件
    递归步骤
  递归函数会从给定的值一直调用自己，函数的参数不断发生变化，向基本条件靠拢，直到满足递归的基本条件才停止

2. 简单递归函数
  定义乘方函数 power
-}
power :: Int -> Int -> Int
power _ 0 = 1
-- power x n = x * power x (n - 1)
-- 避免 x^n 的重复计算
power x n | odd n = let p = power x ((n - 1) `div` 2) in x * p * p
          | otherwise = let p = power x (n `div` 2) in p * p

-- 自定义 product 函数
product' [] = 1
product' (x:xs) = x * product' xs 

-- 定义一个 snoc 函数，将一个元素添加在一个列表的左后
snoc :: a -> [a] -> [a]
snoc x [] = [x]
snoc x (y:ys) = y: snoc x ys

-- last' 函数返回列表的最后一个元素
last' :: [a] -> a
last' [] = error "empty list"
last' [x] = x
last' (_ : xs) = last' xs

take' n _  | n <= 0 = []
take' _ [] = []
take' n (x:xs) = x : take' (n -1) xs

elem' :: Eq a => a -> [a] -> Bool
elem' _ [] = False
elem' a (x:xs) = if a == x then True else elem' a xs

-- 练习 删除给定的元素
delete' :: Eq a => a -> [a] -> [a]
delete' _ [] = []
delete' a (x:xs) = if a == x then delete' a xs
                   else x: delete' a xs
-- 练习 定义 drop函数
-- drop' :: Eq a, Num n => n -> [a] -> [a] 这个定义不对
drop' _ [] = []
drop' n [a] | n <= 0 = [a]
drop' n (x:xs) = drop' (n - 1) xs


-- 3 扩展递归与尾递归
--  在函数未达到递归的基本条件前，所有的中介结果会暂存在内存的栈中，这样的递归叫做扩展递归， 即在递归步中除调用递归函数以外还参与了其他函数的计算
--  不必展开就可以计算的递归函数式尾递归，， 即除递归调用以外没有任何的计算，在计算过程中也可以不必展开，这样的递归是尾递归，在递归的是够不必要向内存中暂存任何的值

-- 定义 total函数 （扩展递归）
total [] = 0
total (x:xs) = x + total xs
-- 这个递归将会暂存每一步的值， 内存使用效率低

-- 使用尾递归
total' [] n = n
total' (x:xs) n = total' xs (x+n)

-- 由于惰性求值，尾递归 total', 在函数调用到递归基本条件前，参数n只参与x的加法运算，并不作为结果使用，即n的具体值在未达到递归条件前不被调用，由Haskell暂存在内存中，到需要的时候才计算
-- 此时需要使用 ! 模式匹配 或者 $! 运算符来强制 Haskell 对 total'的第二参数求值
--    ! 模式 是强制在参数匹配前来计算参数的值
--    $! 为在调用函数时计算参数的值


-- 4. 互调递归
--    两个函数的定义都分别用到了对方
even' 0 = True
even' n = odd' (n-1)
odd' 0 = False
odd' n = even' (n-1)
-- 调用 even' 3 , 过程
-- even' 3
-- odd' 2
-- even' 1
-- odd' 0
-- False


-- 5.麦卡锡的 91 函数
--    当 n<=100 时，函数结果为91， n>100时， 所有的结果为 n-10
mc n | n > 100 = n - 10
     | otherwise = mc (mc (n+11))


-- 6.斐波那契数列
--  前一个数和后一个数的比值逼近黄金分割值 ((5开平方根) - 1) / 2
--  4个相连的整数的内积与外积相差1
-- fibonacci :: (Num a) => a -> a
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n = fibonacci (n-1) + fibonacci (n-2)
fibs n = map fibonacci [0..n]
-- fibonacci / fibs 都不要尝试 n>30
-- 以上写法， n, 变大后，计算变慢，因为要递归 fib(n-1) 和 fib (n-2)两部分
-- fibStep :: Num a => (a, a) -> (a, a)
fibStep (u, v) = (v, u+v)
-- fibPair :: Num a => a -> (a, a)
fibPair 0 = (0, 1)
fibPair n = fibStep (fibPair (n-1))
fastFib = fst . fibPair
fibs' n = map fastFib [1..n]
-- 进一步， 因为在求第 n 项的时候， 前 n-1 项不需要计算了
fibs'' n = take n (map fst ( iterate fibStep (0, 1)))

-- 使用尾调用优化
fib 0 f1 f2 = f2
fib n f1 f2 = fib (n-1) f2 (f1+f2)
fibonacci' n = fib n 1 1

-- 特性验证
golden :: Fractional a => Int -> [a]
golden n = take n (map (\(x, y) -> x/y) (iterate fibStep (0, 1)))

combine :: [(a, a)] -> [(a, a, a)]
combine ((f1,f2):(f3, f4):fs) = (f1, f2, f4):combine ((f3,f4):fs)
combine _ = []
fibPairs :: Int -> [(Int, Int)]
fibPairs n = map fibPair [1..n]
difference :: Int -> [Int]
difference n = map (\(f1, f2, f3) -> f1*f3-f2*f2) (combine $ fibPairs n)



-- 7. 十进制数字转成罗马数字
--  这里只考虑 5000 以内的罗马数字
romeNotation :: [String]
romeNotation = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
romeAmount :: [Int]
romeAmount = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
pair :: [(Int, String)]
pair = zip romeAmount romeNotation
subtrahend :: Int -> (Int, String)
subtrahend n = head (dropWhile (\(a, _) -> a > n) pair)
convert :: Int -> (Int, String)
convert 0 = (0, "")
convert n = let (i, st) = subtrahend n in 
            let (i', st') = convert (n-i) in (i', st++st')



-- 8.二分查找
search :: (Ord a) => a -> [a] -> Bool
search a [] = False
search a xs | m < a = search a behind
            | m > a = search a front
            |otherwise = True
              where (front, m:behind) = splitAt (length xs `div` 2) xs



-- 9.汉诺塔


-- 10.排序算法

--    插入排序
insert :: Ord a => a -> [a] -> [a]
insert x [] = [x]
insert x (y:ys) | x < y = x:y:ys
                | otherwise = y:insert x ys
insertionSort :: Ord a => [a] -> [a] -> [a]
insertionSort xs [] = xs
insertionSort xs (y:ys) = insertionSort (insert y xs) ys

insertionSort' :: Ord a => [a] -> [a]
insertionSort' [] = []
insertionSort' (x:xs) = insert x (insertionSort' xs)

-- 两种插入的方法是完全一样的，只不过第一个用了中间表来存储，是尾递归，而后一种是 扩展递归

--    冒泡排序
swaps :: Ord a => [a] -> [a]
swaps [] = []
swaps [x] = [x]
swaps (x1:x2:xs) | x1 > x2 = x2 : swaps (x1:xs)
                 | otherwise = x1: swaps (x2:xs)
-- 定义一个不动点函数，这个函数可以一直调用 swaps, 直到列表不会发生变化

fix :: Eq a => (a -> a) -> a -> a
fix f x = if x ==x' then x else fix f x'
            where x' = f x
bublleSort :: Ord a => [a] -> [a]
bublleSort xs = fix swaps xs

-- 把 fix 隐藏在 bubbleSort 里
bubbleSort :: Ord a => [a] -> [a]
bubbleSort xs | swaps xs == xs = xs
              | otherwise = bubbleSort $ swaps xs
-- 下一次不需要校对已经校对过得数据
bubbleSort' :: Ord a => [a] -> [a]
bubbleSort' [] = []
bubbleSort' xs = bubbleSort' initialElements ++ [lastElement]
  where swappedxs = swaps xs
        initialElements = init swappedxs
        lastElement = last swappedxs


-- 选择排序
delete :: Eq a => a -> [a] -> [a]
delete _ [] = []
delete x (l:ls) | x == l = ls
                | otherwise = l:delete x ls
selectionSort [] = []
selectionSort xs = mini : selectionSort xs'
  where mini = minimum xs
        xs' = delete mini xs


-- 快速排序
quickSort :: Ord a => [a] -> [a]
quickSort [] = []
quickSort (x:xs) = quickSort mini ++ [x] ++ quickSort maxi
  where mini = filter (<x) xs
        maxi = filter (>=x) xs

filterSplit :: (a -> Bool) -> [a] -> ([a], [a])
filterSplit _ [] = ([], [])
filterSplit f (x:xs) | f x = ((x:l), r)
                     | otherwise = (l, (x:r))
  where (l, r) = filterSplit f xs
-- 这个函数会把成立的数放在左边，不成立的放在右边，这里，用where做替换的时候，Haskell会把l/r匹配到递归调用 filterSplit函数的结果上
quickSort' :: Ord a => [a] -> [a]
quickSort' [] = []
quickSort' [x] = [x]
quickSort' (x:xs) = quickSort' l ++ [x] ++ quickSort' r
  where (l, r) = filterSplit (<x) xs


-- 并归排序
merge :: Ord a => [a] -> [a] -> [a]
merge xs [] = xs
merge [] ys = ys
merge (x:xs) (y:ys) | x > y = y:merge (x:xs) ys
                    | otherwise = x:merge xs (y:ys)
msort :: Ord a => [a] -> [a]
msort xs = merge (msort x1) (msort x2)
  where (x1, x2) = halve xs
        halve xs = (take 1 xs, drop 1 xs)
        1 = (length xs) `div` 2



-- 11.递归基本条件和程序终止
--     基本条件可达成是程序终止的必要条件
-- 12 递归与不动点
--    冒泡排序中的 fix 函数就是不动点函数
--    函数的不动点意为当参数应用到这个函数时，结果是这个参数本身

-- 观察 不动点函数 fix 的定义
{- 
fix :: (a -> a) -> a
fix f = f (fix f)

fix 函数无限的调用 函数 f
fix f 
= f (fix f)
= f (f (fix f))
...
如：
fix (1:)
= 1: (fix (1:))
= 1:1: (fix (1:))
-}