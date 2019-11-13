data BookInfo = Book Int String [String]
                deriving (Show)

myInfo = Book 9876543 "Algebra of programming" 
         ["Richard Bird", "Oege de Moor"]

-- data BookReview = BookReview BookInfo CustomerID String
-- 使用别名
type CustomerID = Int
type ReviewBody = String
data BookReview = BookReview BookInfo CustomerID ReviewBody
type BookRecord = (BookInfo, BookReview)
type Address = [String]

data Bool = False | True

data Customer = Customer {
    customerID :: CustomerID,
    customerName :: String,
    customerAddress :: Address
} deriving (Show)

customer1 = Customer 271828 "J.R. Hacker" ["255 Syntax Ct", "Milptias, CA 95134", "USA"]

customer2 = Customer {
              customerID = 271828
            , customerAddress = ["1048576 Disk Drive",
                                 "Milpitas, CA 95134",
                                 "USA"]
            , customerName = "Jane Q. Citizen"
            }
-- 上面代码定义的 Bool类型有两个值构造器

-- BookInfo 近视新类型的名字 （类型构造器）类型构造器用于指代类型
-- Book 值构造器 值构造器的名字首字母也需要大写
-- Int String [String] 是类型的组成部分， 它是一个存储值的槽， 通常将组成部分称为域
-- 类型构造器和值构造器相互独立， 类型构造器只能出现在类型的定义或变量签名中， 值构造器只能出现在时机的代码中， 因此可以使用一个相同的名字