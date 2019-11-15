
renderJValue :: JValue -> Doc
renderJValue (JBool True)  = text "true"
renderJValue (JBool False) = text "false"
renderJValue JNull         = text "null"
renderJValue (JNumber num) = double num
renderJValue (JString str) = string str

string :: String -> Doc
string = enclose '"' '"' . hcat . map oneChar

enclose :: Char -> Char -> Doc -> Doc
enclose left right x = undefined
enclose left right x = char left <> x <> char right

(<>) :: Doc -> Doc -> Doc
a <> b = undefined

hcat :: [Doc] -> Doc
hcat xs = undefined

oneChar :: Char -> Doc
oneChar c = undefined
oneChar c = case lookup c simpleEscapes of
              Just r -> text r
              Nothing | mustEscape c -> hexEscape c
                      | otherwise -> char c
  where mustEscape c = c < ' ' || c == '\x7f' || c > '\xff'

simpleEscapes :: [(char, String)]
simpleEscapes = zipWith ch "\n\f\r\t\\\"/" "bnfrt\\\"/"
    where ch a b = (a, ['\\',b])

hexEscape :: Char -> Doc
hexEscape c = undefined