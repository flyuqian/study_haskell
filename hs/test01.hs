doubleMe x = x + x
--doubleUs x y = x * 2 + y * 2
doubleUs x y = doubleMe x + doubleMe y

doubleSmallNunber x = if x > 100
    then x
    else x * 2

sum1 :: (Num a) => [a] -> a
sum1 [] = 0
sum1 (x: xs) = x + sum1 xs

capital :: String -> String
capital "" = "Empty string, whoops"
capital all@(x: xs) = "The first letter of " ++ all ++ " is " ++ [x]

fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib(n) = fib(n-1) + fib(n-2) 

max1 :: (Ord a) => [a] -> a
max1 [] = error "maximum of empty list"
max1 [x] = x
max1 (x:xs)
    | x > maxTail = x
    | otherwise = maxTail
    where maxTail = max1 xs

max2 :: (Ord a) => [a] -> a
max2 [] = error "max2 of empty list"
max2 [x] = x
max2 (x:xs) = max x (max2 xs)

replicate1 :: (Num i, Ord i) => i -> a -> [a]
replicate1 n x 
    | 0 n = []
    | otherwise = x:replicate1(n-1) x

