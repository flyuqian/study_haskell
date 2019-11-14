
-- 用一个 代数数据类型来表示 JSON 的各个数据类型

module SimpleJSON (
  JValue(..),
  getString,
  getInt,
  -- getDouble,
  getBool,
  getObject,
  getArray,
  isNull
) where

data JValue = JString String
            | JNumber Double
            | JBool Bool
            | JNull 
            | JObject [(String, JValue)]
            | JArray [JValue]
            deriving(Show, Eq, Ord)
--    这里的 JObject [(String, JValue)] 不能改为 JObject [(JString, JValue)]， 因为值构造器里面声明的是类构造器， 不能是值构造器

getString :: JValue -> Maybe String
getString (JString s)   = Just s
getString _             = Nothing

getInt (JNumber n)      = Just (truncate n)
getInt _                = Nothing

getBool (JBool b)       = Just b
getBool _               = Nothing

getObject (JObject o)   = Just o
getObject _             = Nothing

getArray (JArray a)     = Just a
getArray _              = Nothing

isNull v                = v == JNull

-- truncate 函数 返回浮点数或者有理数的整数部分
-- Haskell 模块， 一个 Haskell 文件可以包含一个模块定义， 模块可以决定模块中的哪些名字可以被外部访问。 模块的定义必须放在其它定义之前
-- module 是保留字，它后面是模块的名字，模块的名字必须以大写字母开头，并且必须和包含这个模块的文件的基础名一致，其后是用 () 包围的导出列表 where 关键字后的内容为模块的体
-- JValue(..) 表示导出 JValue 类型以及它的所有值构造器
-- module ExportEverything where
-- module ExportNothing () where

-- ghc -c xx.hs
-- -c 表示只生成 目标代码。如果省略 -c 选项，那么ghc就会试图生成一个完整的可执行文件，这需要包含一个独立程序会被调用的main函数
