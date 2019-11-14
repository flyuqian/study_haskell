import Data.List (intercalate)
import SimpleJSON

renderJValue :: JValue -> String

renderJValue (JString s)   = show s
renderJValue (JNumber n)   = show n
renderJValue (JBool True)  = "true"
renderJValue (JBool False) = "false"
renderJValue JNull         = "null"

renderJValue (JObject o) = "{" ++ pairs o ++ "}"
  where pairs [] = ""
        pairs ps = intercalate ", " (map renderPair ps)
          where renderPair (k,v) = show k ++ ": " ++ renderJValue v

renderJValue (JArray a) = "[" ++ values a ++ "]"
  where values [] = ""
        values vs = intercalate ", " (map renderJValue vs)
  
-- 分割纯代码和带有 IO 的代码是一种良好的 Haskell 风格。这里我们用 putJValue 来进行打印操作，这样就不会影响 renderJValue 的纯洁性：
putJValue :: JValue -> IO ()
putJValue v = putStrLn (renderJValue v)
