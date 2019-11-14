-- import System.Environment (getArgs)
import Data.Char (digitToInt, toUpper, ord, isUpper)
import Data.Bits (shiftL, (.&.), (.|.))
import Data.List (isInfixOf, tails, isPrefixOf)

-- interactWith function inputFile outputFile = do
--   input <- readFile inputFile
--   writeFile outputFile (function input)

-- main = mainWith myFunction
--   where mainWith function = do
--           args <- getArgs
--           case args of
--             [input,output] -> interactWith function input output
--             _ -> putStrLn "error: exactly two arguments needed"

--         -- replace "id" with the name of our function below
--         myFunction = id
-- do 关键字 引入一个快，标识那些带有副作用的块
--      被 do 包围的 <- 操作符效果等同于复制


asInt :: String -> Int
loop :: Int -> String -> Int
asInt xs = loop 0 xs
loop acc [] = acc
loop acc (x:xs) = let acc1 = acc * 10 + digitToInt x
                  in loop acc1 xs

-- 对列表中的所有元素进行平方操作
square :: [Double] -> [Double]
square (x:xs) = x*x : square xs
square [] = []


upperCase :: String -> String
upperCase (x:xs) = toUpper x : upperCase xs
upperCase [] = []

-- 使用 map
square2 xs = map squareOne xs
  where squareOne x = x * x
upperCase2 xs = map toUpper xs

-- 自定义一个 map
myMap :: (a -> b) -> [a] -> [b]
myMap f (x:xs) = f x : myMap f xs
myMap _ [] = []

oddList :: [Int] -> [Int]
oddList (x:xs) | odd x = x:oddList xs
               | otherwise = oddList xs
oddList [] = []

-- reduce
mySum xs = helper 0 xs
  where helper acc (x:xs) = helper (acc + x) xs
        helper acc [] = acc

-- Adler-32 校验
base = 65521
adler32 xs = helper 1 0 xs
  where helper a b (x:xs) = let a' = (a + (ord x .&. 0xff)) `mod` base
                                b' = (a' + b) `mod` base
                            in helper a' b' xs
        helper a b [] = (b `shiftL` 16) .|. a


-- foldl 版 mySun
foldSum xs = foldl step 0 xs
  where step acc x = acc + x

niceSum :: [Integer] -> Integer
niceSum xs = foldl (+) 0 xs

niceSumFoldr :: [Int] -> Int
niceSumFoldr xs = foldr (+) 0 xs

-- foldr 定义 filter
myFilter p xs = foldr step [] xs
  where step x ys | p x = x :ys
                  | otherwise = ys

myFoldrMap :: (a -> b) -> [a] -> [b]
myFoldrMap f xs = foldr step [] xs
  where step x xs = f x : xs

myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldl f z xs = foldr step id xs z
  where step x g a = g (f a x)
-- 一种思考 foldr 的方式是，将它看成是对输入列表的一种转换（transform）：它的第一个参数决定了该怎么处理列表的 head 和 tail 部分；而它的第二个参数则决定了，当遇到空列表时，该用什么值来代替这个空列表。

-- 用 foldr 定义的恒等（identity）转换，在列表为空时，返回空列表本身；如果列表不为空，那么它就将列表构造器 (:) 应用于每个 head 和 tail 对（pair）
identity :: [a] -> [a]
identity xs = foldr (:) [] xs
append :: [a] -> [a] -> [a]
append xs ys = foldr (:) ys xs

-- 左折叠、惰性和内存泄漏
--    千万不要把 foldl 用在实际使用中

-- foldl (+) [1, 2, 3] 执行过程
-- foldl (+) 0 (1:2:3:[])
--           == foldl (+) (0 + 1)             (2:3:[])
--           == foldl (+) ((0 + 1) + 2)       (3:[])
--           == foldl (+) (((0 + 1) + 2) + 3) []
--           ==           (((0 + 1) + 2) + 3)
-- 最好不要在实际代码中使用 foldl ：即使计算不失败，它的效率也好不到那里去。更好的办法是，使用 Data.List 里面的 foldl' 来代替。

isInAny needle haystack = any inSequence haystack
  where inSequence s = needle `isInfixOf` s
-- 使用 lambda
isInAny2 needle haystack = any (\s -> needle `isInfixOf` s) haystack
-- lambda 函数的定义 只能有一条语句

-- 如果你要在 lambda 函数里使用模式，请千万小心，必须确保你的模式不会匹配失败。

-- 部分函数应用和柯里化
--    -> 只有一种作用， 表示一个函数接受一个参数， 并返回一个值
--    在 Haskell 中，所有函数都只接受一个参数， 如果一个函数接受了 多个参数，那么 除第一个参数外的参数 将组成一个函数，作为函数的返回值

niceSumPartial :: [Integer] -> Integer
niceSumPartial = foldl (+) 0

-- 节 section
--    用于对中序函数进行部分应用， 使用一个括号包围一个操作符， 在括号里提供一个参数， 产生一个部分函数

-- as-模式
suffixes :: [a] -> [[a]]
suffixes xs@(_:xs') = xs : suffixes xs'
suffixes [] = []
--    模式 xs@(:xs') 被称为as-模式， 意思是如果输入值能匹配@符号右边的模式， 那么将这个值绑定到@符号左边的变量中
--    as-模式 可以对输入数据进行共享，而不是复制它
--    没有 as模式时， 需要如下
noAsPattern :: [a] -> [[a]]
noAsPattern (x:xs) = (x:xs) : noAsPattern xs
noAsPattern [] = []

-- 通过组合模式来复用代码
-- 通过组合函数来进行代码复用
suffixes2 xs = init (tails xs)

compose :: (b -> c) -> (a -> b) -> a -> c
compose f g x = f (g x)
-- compose 函数可用于粘合两个函数
suffixes3 xs = compose init tails xs
-- 通过柯里化，去掉xs函数
suffixes4 = compose init tails
-- Haskell 内置了 compose 函数，在 Prelude 里
suffixes5 = init . tails

-- 案例 计算字符串中大写字母开头的单词的个数
capCount = length . filter (isUpper . head) .words
-- . 是 右关联的

-- 案例，提取 libpcap 包中提取 C 文件头中给定格式的宏名字
dlts :: String -> [String]
dlts = foldr step [] . lines
  where step l ds
          | "#define DLT_" `isPrefixOf` l = secondWord l : ds
          | otherwise = ds
        secondWord = head .tail . words 

dlts2 :: String -> [String]
dlts2 = map (head . tail . words) . filter ("#define DLT_" `isPrefixOf`) . lines

-- 通过 seq 函数避免内存泄露
--    我们成 非惰性求值的表达式 为严格的
--    fold' 就是左折叠的严格版本，它使用特殊的seq 函数来绕过 Haskell 默认的非严格求值

foldl' _ zero [] = zero
foldl' step zero (x:xs) =
  let new = step zero x
  in new `seq` foldl' step new xs

-- seq 函数， 强迫求值传入的第一个参数， 然后返回它的第二个参数
