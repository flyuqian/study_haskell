{-
Bool 类型， 只有 True False 值的数据类型
Char 类型
Int 有符号整数
Word 无符号整数
Integer 任意精度整数
Float 单精度浮点数
Double 双精度浮点数
Rational 有理数类型，用两个任意精度的整数来表示一个小数
String 字符串 [Char]
tuple
  二元元组， 函数 fst snd 返回第一个、第二个元素
list 列表
  [] 空列表
  一个列表可以是 x:xs
  使用 x:[x] 加入列表
函数类型 T1 -> T2, 如果T1/T2 为函数类型，那么该函数为高阶函数
  柯里化： 当函数有多个参数时，参数可以一个一个的依次输入，参数不足，将返回一个函数作为结果
  多态函数， 如：
    列表的 
      length 长度
      head 第一个元素
      zip 将两个列表的元素意义对应的结合在一起
  重载类型函数
    Prelude> :type 5
    5 :: Num p => p
    => 是类型类的限定符号， 5有一个任意的a 类型，但这个类型必须限定在 Num 的类型中
    ！ Haskell 中，函数或运算符的定义是唯一的，不可以出现第二种不同的定义
类型的别名
  type

类型类
  Haskell 给很多类型分成了了类型类，归为一类的类型有着共同的属性，不同类型所归的类就是类型类
  Prelude> :t 5
  5 :: Num p => p
  Prelude> :t (==)
  (==) :: Eq a => a -> a -> Bool
  相等类型类 Eq, 数字类型类Num, Ord 有序类型类

  相等类型类 Eq
    一个类型实现了相等类型类，就可以比较相等了
    == 相等
    /= 不等
  有序类型类 Ord
    < <= > >=

枚举类型 Enum
  [1..10] ['a'..'z'], 是因为 Integer 和 Char 都实现了枚举类型
  一个类型如果实现了枚举类型类，那么给定一个元素（若该元素不是最后一个）总是可以用枚举类型类中定义的 succ 函数得到下一个元素，若不是第一个，总能用 pred函数得到它的前一个值

有界类型类 Bounded
  可以枚举定义的数据往往是有界的

数字类型类 Num

数字转换型函数
  fromInteger :: Num a => Integer -> a
  toInteger :: Integer a => a -> Integer
  fromeRational :: Fractional a => Rational -> a 
  toRational :: Real a => a -> Rational
  fromeIntegral :: (Integral a, Num b) => a -> b 函数讲一个实现整数类型类的类型转换为一个一般数字类型类的类型
  truncate :: (Integral b, RealFrac a) => a -> b 函数可以将一个小数的整数部分取出来
  properFraction :: (Integral b, RealFrac a) => a -> (b, a) 函数则会将一个小数的两部分纷争整数与小数部分返回一个元组
  floor, ceiling, round :: (Integral b, RealFrac a) => a -> b 这三个函数分别是下取整， 上取整，四舍五入

可现实类型 Show

在定义函数的时候，函数的类型（函数的标签）可以省去

函数
  Haskell 中的值
      变量的值绑定后不会改变，变量在一定意义上可以理解为定值
      纯函数，函数的行为在运行过程中不会改变，对于摸一个特定的输入返回的结果总是确定的
  函数思想入门
    函数与值在Haskell中没有本质区别，函数可以是一个单一的定值，也可以说是任意两个函数间的映射
    函数的定义
      函数名 :: 参数1的类型 ->参数2的类型 -> ... -> 结果的类型
      函数名 :: 参数1 参数2 ... = 函数体
      类型类也可以合并在一起，中间用逗号分隔
      add, sub :: Int -> Int -> Int
      多个类型类限定在一个类型上的时候，它们需要用括号写在一起
      function :: (Show a, Ord a) => a -> a -> a
      .hs 文件的全局函数的名必须要从每行最前端开始写
      函数名不能以大写字母和数字开头， 大写字母开头的位另行或类型数据（Bool True False）
      看一个二元一次函数 f(x,y) = 4x+5y+1
      f :: Num a => (a, a) -> a
      f (x, y) = 4*x + 5*y + 1
      (x, y) 是一个元组
      f' :: Num a => a -> a -> a
      f' x y = 4*x + 5*y + 1
      从 f 到 f' 就是柯里化
    
    λ 表达式
      函数的另一种书写方式
      函数类型 :: 参数的类型 -> 参数的类型 -> 结果的类型
      函数名 = \参数 -> \参数 -> 函数体
      f' :: Num a => a -> a -> a
      上面函数可以这么定义
      f' :: Num a => a -> a -> a
      f' = \x -> \y -> 4*x + 5*y + 1
      可以看出函数的类型和函数的定义非常好的对应上了，在代码编译后，函数最终都会被化入 λ表达式
      在Haskell中可以上去参数间的箭头而简写成
      f'=\x y -> 4*x + 5*y + 1

      Haskell 为了避免重复计算和类型的歧义，引入单一同态限定
      λ演算中的 α替换、β简化、η简化
        α替换: 在不出现命名冲突的前提下可以将函数的参数重命名
          \x->\y->x+y = \a -> \y -> a+y
          \x->\y->x+y /= \y -> \y -> y+y
        β简化：是参数到函数体的替换，应用参数N与函数
        x->M,相当于在不出现明明冲突的前提下把M中出现的x替换为N
          (\x->M)N
        这块再去看书
      单一同态限定
        避免重复计算、消除类型歧义
      λ表达式的应用
        柯里化
          在不给定前一个参数的前提下给定后一个
        匿名函数

    参数的绑定
      let .. in ..
      where

Haskell 中的表达式
  条件表达式 if.. then.. else..
    else 后的表达式 不可以省略，因为需要保证函数的完整性，在不同条件下返回类型相同
  情况分析表达式 switch case
  守卫表达式
    使用|将函数的参数按特定的条件分开，像一个守卫一样，只让满足条件的表达式运算, 不同条件的守卫表达式需要对齐
      abs :: Num a => a -> a
      abs n | n > 0 = n
            | otherwise = -n
  模式匹配
    一个类型的值或者定义成的形式
      useful :: Int -> Bool
      useful 1 -> True
      useful 8 -> True
      useful _ -> False

  运算符和函数
    Haskell所有运算符都是基于函数定义的
    我们可以将一些 二元函数用反单引号 ` ` 转换成 位于参数中间的运算符
  自定义运算符
    运算符的属性
      优先级 0~9
      结合性 左结合性 又结合性 无结合性
      位置 前缀 中缀 后缀
-}