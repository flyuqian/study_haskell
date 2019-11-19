
-- 库函数及其应用

-- 预加载函数库 Prelude
{-
常用函数
  恒值函数 id :: a -> a, 给定一个任何值，返回这个给定的值
  常值函数 const :: a -> b -> a, 给定两个元素，只返回第一个
    恒值函数可以用来占位，如：定义一个给定两个参数，返回第二个元素的函数， 可以定义为 const id
    Prelude> :t const
    const :: a -> b -> a
    Prelude> :t id
    id :: a -> a
    Prelude> :t const id
    const id :: b -> a -> a

    const id True 3 函数为左结合
    (const id True) 3 应用 const函数 返回id
    id 3 = 3
  参数反之函数 flip
    flip :: (a->b->c)->b->a->c
    可以将一个二元函数的第二个参数的书序颠倒
  错误函数 error
    error :: String -> a 破除异常的函数

  undefined 函数
    undefined函数是由error定义的
    undefined :: a
    undefined = error "Prelude; undefined"
      由于undefined是一个多态函数，因此有时有些函数可以先不定义，保证编译器不报错
      month :: Int -> Int
      month = undefined
      days :: (Int, Int) -> Int
      days (m, d) = month m + d
  
  min max
    min :: Ord a => a -> a -> a


基于列表的函数

  null 判断一个列表是否为空 [a] -> Bool
  length 返回一个列表的常德 [a] -> Int
  !! :: [a] -> Int -> a 取得给定列表中从0开始的第n个元素
  reverse 倒序
  (head, last) :: [a] -> a 取列表第一个、最后一个元素
  (init, tail) 取列表除最后一个、第一个 元素的列表
  map :: (a -> b) -> [a] -> [b] 将一个函数应用到列表中的每一个元素
    传入的函数可以为复杂函数，此时借助 λ匿名函数 更容易定义它
      Prelude> map (\x -> x^2 + 1) [1, 2, 3, 4, 5]
      [2,5,10,17,26]
  filter 过滤函数
  (take, drop) :: Int -> [a] -> [a]
    take, 从头任意连续的取列表的多个元素
    drop 将列表中前 多个元素舍弃
  (span, break) :: (a -> Bool) -> [a] -> ([a], [a])
    span 从左到右，遇到第一个不符合条件的元素时停止，将列表分成两个列表组成的元组
    break 是遇到第一个符合条件的元素停止
  takeWhile dropWhile
  splitAt :: Int -> [a] -> ([a], [b])
    splitAt' n xs = (take n xs, drop n xs)
  repeat replicate
    repeat 讲一个元素重复无数次
    replicate 复制函数 Int -> a -> [a], 将一个元素复制给定次数
  (any, all) :: (a -> Bool) -> [a] -> Bool
    any 查询一个列表中是否存在符合条件的元素
    all 查询一个列表的元素是否都符合给定条件
  elem, notElem
    elem :: Eq a => a -> [a] -> Bool, 判断列表中是否存在某一元素
  iterate
    迭代函数 iterate :: (a -> a) -> a -> [a]
    它可以将第一个函数应用在第二个参数上多次，借助 iterate函数来生成以1为首项，2为公比的等比数列
  until :: (a -> Bool) -> (a -> a) -> a -> a
    迭代的生成数据直到满足给定的条件为止
  zip 将两个列表组合成一个元组的列表
    当两个列表length不对等时，多与元素会被忽略
    unzip 将一个二元元素列表分成两个列表的函数
    zip3, unzip3
  concat :: [[a]] -> [a]
    将一个列表中的列表相连
  concatMap
    这个函数先使用 map 函数将 [a] 计算为 [[b]], 在使用 concat 函数的到类型为 [b]的结果
      Prelude> concatMap (replicate 3) [1, 2, 3]
      [1,1,1,2,2,2,3,3,3]
      Prelude> concat (map (replicate 3) [1, 2, 3])
      [1,1,1,2,2,2,3,3,3]
-}