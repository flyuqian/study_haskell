import Data.Char (ord, chr, isLower)
import Data.List (delete, tails)
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

-- 埃拉托斯特尼 筛法
sieve :: (Integral a) => [a] -> [a]
sieve (p:xs) = p: sieve [x| x<-xs, mod x p /= 0]

-- 练习 定义一个函数 primeFactors, 可以将一个整数做质因数的分解， 如 36=2*2*3*3
-- primeFactors :: Integral a => a -> [(a, a)]
-- primeFactors p = isPrime p = []
-- primeFactors p | mod p $ head $ primes p == 0 





-- 3 凯撒加密
-- 这里默认明文中只有小写字母
char2int :: Char -> Int
char2int c = ord c - ord 'a'
int2char :: Int -> Char
int2char n = chr (ord 'a' + n)
-- 下面这个函数可以将字符串 转换成数字，进行移位，然后在转换成密文
shift :: Int -> Char -> Char
shift n c | isLower c = int2char ((char2int c + n) `mod` 26)
          | otherwise = c
encode :: Int -> String -> String 
encode n xs = [shift n x | x <- xs]
encodeTestStr = "The design of the Olympic medals will be unveiled tonight in a live ceremony from Trafalgar Square.Over at the brand new Aquatics Centre, Britain's star diver Tom Daley is going to perform an official launch dive into the Olympic pool."
--    解密
chisqr :: [Float] -> [Float] -> Float
chisqr os es = sum [((o-e)^2)/e | (o,e) <- zip os es]
-- 这个公式就是在度量某一文本与大量英文本文各个字母出现的概率的距离，如果这个距离最小，则最有可能是想要的结果
-- 这是英文字符 a~z 在英文文本中出现的百分比
table :: [Float]
table = [8.2, 1.5, 2.8, 4.3, 12.7, 2.2, 2.0, 6.1, 7.0, 0.2, 0.8, 4.0, 2.4, 6.7, 7.5, 1.9, 0.1, 6.0, 6.3, 9.1, 2.8, 1.0, 2.4, 0.2, 2.0, 0.1]
-- 首先，定义count 函数来统计某一英文字符在文本出现的次数
count :: Char -> String -> Int
count x xs = length [x'| x' <- xs, x == x']
-- 接下来，定义统计概率需要的函数，首先是求百分比函数。 由于是小数，因此需要使用 fromIntegral 将Int 转化为一个具有 Num b => b 的类型的值，最后求 比值
percent :: Int -> Int -> Float
percent n m = (fromIntegral n / fromIntegral m) * 100
-- 统计文本中有多少个小写英文字母
lowers :: String -> Int
lowers xs = length [x| x<-xs, isLower x]
-- 定义统计文本中各个字母出现的概率的函数
freqs :: String -> [Float]
freqs xs = [percent (count x xs) n | x<-['a'..'z']]
  where n = lowers xs
-- 我们需要将统计出的概率 移位25次，以便将移位的每一次都与table中的概率应用于 chisqr函数来计算与table中概率的距离，定义rotate 函数来移动列表中元素所在的位置
rotate :: Int -> [a] -> [a]
rotate n xs = drop n xs ++ take n xs

-- 最后，需要定义解密函数 crack, 从 25组值中找出最小的，它在表中所在的位置就是移动的次数。首先得到密文中各个英文字符的频率，记为table', table' 与 table 依次应用 chispr， 得到所有的距离，从这些距离中找到最小的，其所在位置就是解密需要的移动次数
crack :: String -> String
crack xs = encode (-factor) xs
  where
    factor = head (positions (minimum chitab) chitab)
    chitab = [chisqr (rotate n table') table | n<-[0..25]]
    table' = freqs xs
positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i| (x',i) <- zip xs [0..], x==x']




-- 排列与组合问题
--    通过生成一个列表的全排列解决某个问题，这些方法常常成为蛮力法
--  定义函数 insert 将某一元素插入列表中的所有位置
insert :: a -> [a] -> [[a]]
insert n [] = [[n]]
insert n (n':ns) = (n:n':ns):[n':ns'| ns' <- insert n ns]
-- 全排列 就是将第一个x插入到后边列表全排列的每一个元素中
permutation [] = [[]]
permutation (x:xs) = concat [insert x permuxs | permuxs <- permutation xs]

-- 另一种递归思路： 在全排列的过程中，所有列表中的元素必须开头至少一次，然后，当某一元素p开头是，只要对除这一元素的列表进行排列，就可以得到p开头的排列，那么若生成每一个元素开头的排列，就得到了整个列表的全排列

permutation' :: Eq a => [a] -> [[a]]
permutation' [] = [[]]
permutation' xs = [y:ys | y<-xs, ys<-permutation' (delete y xs)]
-- 但是这里需要使用 delete 函数， 类型a需要可以比较相等。有些情况下，不需要得到所有的元素的全排列，只需要得到n中的m个的排列
permutation'' :: Eq a => Int -> [a] -> [[a]]
permutation'' 0 _ = [[]]
permutation'' n l = [x:xs|x<-l,xs<-permutation'' (n-1) (delete x l)]


--    错位排列问题
--    假定一列从 1开始的连续的n个整数， 需要的到一些排列， 这些排列满座数字 i 不在第 i 个位置；只要将给定的数字，一次取出放在第 n, 第n-1 个位置，直到第1个位置，但是放的过程中，这个整数与余下的整数的总个数不能相等，即即 i 不在 第i个 位置上，由于Haskell列表的定义方式是一个元素跟一个列表，所以左手边视为高位，右手边视为低位，从右到左的来放置这些整数，最后，只需要将他们依次倒置即可
derangements :: [Int] -> [[Int]]
derangements [] = [[]]
derangements l = [x:xs| x<-l, xs<-derangements (delete x l), x/= length l]
derangements' n = map reverse (derangements [1..n])


--     组合问题
--    得到一个集合的所有子集
powerSet :: [a] -> [[a]]
powerSet [] = [[]]
powerSet (x:xs) = [x:r| r<-powerSet xs] ++ powerSet xs

combinations :: Int -> [a] -> [[a]]
combinations 0 _ = [[]]
combinations n xs = [y:ys| y:xs' <- tails xs, ys <- combinations (n-1) xs']







--    八皇后问题
--    回溯算法的典型
--    在 8*8 的表格上摆放8个皇后，皇后不能相互攻击，即 任意两个皇后不能在同一行同一列同一对角线
--    用列表递归的生成所有皇后可能的位置，假定棋盘为 n*n,每一列的皇后都有n中选择，我们只需要一列一列的色河南工程，，如果不为0时，只需要将第k列皇后能在的n个位置与递归生成的k-1列的所有棋盘即可
positions1 0 n = [[]]
positions1 k n = [x:xs| x<-[1..n], xs<-positions1 (k-1) n]
-- 判断任意两个皇后不在同一行
noSameRow [] = True
noSameRow (x:xs) = (not $ elem x xs) && noSameRow xs

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- 不看了，从排列组合就看不懂了