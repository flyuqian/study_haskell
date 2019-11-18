-- main = do
--   putStrLn "Greetings! what is your name?"
--   inpStr <- getLine
--   putStrLn $ "Welcome to Haskell, " ++ inpStr ++ "!"

-- name2reply :: String -> String
-- name2reply name = 
--   "Pleased to meet you, " ++ name ++ ".\n" ++
--   "You name contains " ++ charcount ++ " characters."
--   where charcount = show (length name)

-- main :: IO ()
-- main = do
--   putStrLn "Greetings once again. what is your name?"
--   inpStr <- getLine
--   let outStr = name2reply inpStr
--   putStrLn outStr



-- 案例1
-- import System.IO
-- import Data.Char (toUpper)

-- main :: IO ()
-- main = do
--   inh <- openFile "input.txt" ReadMode
--   outh <- openFile "output.txt" WriteMode
--   mainLoop inh outh
--   hClose inh
--   hClose outh
-- mainLoop :: Handle -> Handle -> IO ()
-- mainLoop inh outh =
--   do ineof <- hIsEOF inh
--         if ineof
--         then return ()
--         else do inpStr <- hGetLine inh
--                 hPutStrLn outh (map toUpper inpStr)
--                 mainLoop inh outh
-- 这段没跑起来