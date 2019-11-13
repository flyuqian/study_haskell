-- 定义新的数据类型
--      使用 data 关键字定义数据类型
--      Haskell 不允许使用两个结构相同但类型不同的值
data BookInfo = Book Int String [String]
    deriving(Show)
--      BookInfo 新类型的名字， 类型构造器， 首字母大写
--      Book 值构造器， 首字母大写
--      值构造器后面是 类型的组成部分， 域
--      类型构造器和值构造器的相互独立，类型构造器只出现在类型的定义、类型签名中，值构造器只出现在实际代码中，因此，可以使用相同的名字

myInfo = Book 9780135072455 "Algebra of Programming"
              ["Richard Bird", "Oege de Moor"]
--      使用type给类型起别名
data BookReview = BookReview BookInfo Int String
type CustomerID = Int
type ReviewBody = String
data BetterReview = BetterReview BookInfo CustomerID ReviewBody
type BookRecord = (BookInfo, BetterReview)

-- 代数数据类型
--      Bool类型是代数数据类型
data Bool = False | True --一个代数类型可以有多于一个值构造器
--      当一个类型拥有一个以上 值构造器 时， 这些值构造器通常被称为备选、分支
--      同一个类型的 所有分支，创建出来的值 类型都是相同的
--      代数数据类型的各个值构造器可以接受任意个数的参数
--      代数数据类型 的成分是 匿名且按位置排序的
-- 案例 (付款方式)
type CardHolder = String
type CardNumber = String
type Address = [String]
data BillingInfo = CreditCard CardNumber CardHolder Address
                    | CashOnDelivery
                    | Invoice CustomerID
                    deriving(Show)

-- 案例 二维向量
data Cartesian2D = Cartesian2D Double Double
    deriving(Eq, Show)
data Polar2D = Polar2D Double Double
    deriving(Eq, Show)

-- 模式匹配
--      对于某个类型的值来说，可以做到下面两点
--          如果这个类型有一个以上的构造器， 那么应该可以知道，这个值是由哪个构造器创建的
--          如果一个构造器包含不同的成分，那么应该有办法提取这些成分
myNot Prelude.True = Prelude.False
myNot Prelude.False = Prelude.True
--      Haskell 允许将函数定义 为 一系列的等式， myNot 的两个等式分别对应了输入参数在不同模式下的行为， 对于每行等式，模式定义放在函数名之后， = 符号之前

sumList (x:xs) = x + sumList(xs)
sumList [] = 0
--      Haskell里， [1, 2] 是 (1:(2:[])) 的一种简单的标识方式
--      (:)用于狗仔列表

-- 组成和解构
-- 模式匹配的过程就像是逆转一个值构造的过程， 因此有时也被成为解构

-- 元组模式匹配
third (a, b, c) = c
--      模式匹配没有深度限制， 如
complicated (Prelude.True, a, x:xs, 5) = (a, xs)

--      BookInfo的匹配
bookID (Book id title autors) = id
bookTitle (Book id title autors) = title
bookAuthors (Book id title autors) = autors
book3 = (Book 3 "Probability Theory" ["E.T.H. Jaynes"])
--     上边模式匹配中使用不到的变量，可以使用通配符 _ 代替

-- 穷举匹配模式和通配符
--     在给一个类型写一组匹配模式时， 很重要的一点就是一定要涵盖构造器的所有情况， 如果我们要探查一个列表， 就应该写一个匹配非空构造器 (:)的方程和一个匹配空构造器[]的方程
badExample (x:xs) = x + badExample xs
-- badExample [] = 0
badExample _ = 0
-- 如果我们并不在乎某些特定的构造器， 我们可以用 通配符匹配模式来定义一个默认行为

-- 记录语法
-- 使用下面方式可以 定义一种数据类型的同事，定义每个成分的访问器
data Customer = Customer {
    customerID      :: CustomerID,
    customerName    :: String,
    customerAddress :: Address
} deriving(Show)
-- 也可以使用 一下方式创建一个值
customer2 = Customer {
    customerID      = 8899,
    customerName    = "some string",
    customerAddress = ["tom", "jery"]
}
-- 这种写法，字段的顺序可以打乱

-- 参数化类型
--      Prelude 中定义了一种叫做 Maybe 的类型， 用来表示一个值可能有值也可能空缺
-- data Maybe a = Just a | Nothing
--      Maybe Just Nothing 都在Prelude 中定义好了


-- 递归类型
--      列表就是递归的， 它用自己来定义自己
--      我们自己来定义一个列表的仿造类型， 用Cons替换 (:) 构造器， 用 Nil 替换 [] 构造器
data List a = Cons a (List a)
    | Nil
    deriving(Show)
-- 定义一个二叉树类型
data Tree a = Node a (Tree a) (Tree a)
    | Empty
    deriving(Show)

safeSecond :: [a] -> Maybe a
safeSecond [] = Nothing
safeSecond xs = if null (tail xs)
    then Nothing
    else Just (head (tail xs))

-- 案例， 确保剩余保证金不少于 100的情况，才能出借现金

lend amount balance = let reserve       = 100
                          newBalance    = balance - 100
                        in if balance < reserve
                           then Nothing
                           else Just newBalance
-- 缩进， newBalance 要和 reserve 对齐， if then else 要对齐， 否则无法编译通过

bar = let x = 1
    in ((let x = "foo" in x), x)

quux a = let a = "foo"
         in a ++ "eek!"

-- Where 从句
--      可以用来引入局部变量
lend2 amount balance = if amount < reserve * 0.5
                        then Just newBalance
                        else Nothing
    where reserve = 100
          newBalance = balance - amount
-- 局部变量 & 局部函数
pluralise :: String -> [Int] -> [String]
pluralise word counts = map plural counts
    where plural 0 = "no " ++ word ++ "s"
          plural 1 = "one " ++ word
          plural n = show n ++ " " ++ word ++ "s"