-- 类型类定义了一些列的函数，这些函数对于不同类型的值使用不同的函数实现。

class BasicEq a where
  isEqual :: a -> a -> Bool
  isEqual x y = not (isNotEqual x y)
  isNotEqual :: a -> a -> Bool
  isNotEqual x y = not (isEqual x y)


-- 一下代码将 Bool 类型作为 BasicEq的实例类型
instance BasicEq Bool where
  isEqual True True = True
  isEqual False False = True
  isEqual _ _ = False

-- data Color =  Red | Blue | Green
-- instance Show Color where
--   show Red   = "Red"
--   show Green = "Green"
--   show Blue  = "Blue"

-- instance BasicEq Color where
--   isEqual Red Red = True
--   isEqual Blue Blue = True
--   isEqual Green Green = True
--   isEqual _ _ = True

-- 内置类介绍
-- Show
--    Show 用于将值转换为字符串
--    show 函数 返回一个表示该输入数据的字符串
--    如果你定义了一个新类型，并希望通过ghci显示，那么你应该将这个类型实现为Show类型的实例
-- Read
--    Read 将字符串 转换为值
-- 使用 Read 和 Show 进行序列化和反序列化

-- 自动派生
data Color = Red | Green | Blue
  deriving (Read, Show, Eq, Ord)
--    自动派生并不总是可用