
-- haskell 中声明的变量都是不变量
-- 所以haskell 中代码的顺序不重要
-- y = x * 2 
-- x = 3
-- x = 3
-- y = x * 2
-- 上边两段代码可以得到完全相同的结果

-- 条件表达式
mySignum x =
  if x < 0 then 
    -1
  else if x > 0 then
    1
  else 
    0
-- mySignum -2 , -2必须使用 (-2), 否则编译器会认为 mySignum - 2

-- case
f x = 
  case x of
    0 -> 1
    1 -> 5
    2 -> 2
    _ -> (-1)

-- 为不同参数定义一个函数
-- 函数可以通过分段定义的, 也就是说你可以为不同的参数定义同一个函数的不同版本
f1 0 = 1
f1 1 = 5
f1 2 = 2
f1 _ = -1

-- 函数合成
--    复杂的函数可以通过简单的函数相互合成进行构建
--    使用 () 控制函数的执行函数的执行顺序
--    在 haskell 中有另一种更加数学化的表达方法： . 点函数
--      . 函数源于数学中的 o 符号
--      在数学里我们用表达式 f o g 表达 "f following g." 在Haskell , 代码f . g 也表达为 "f following g."
--      f o g 等同于 (f o g)(x) = f(g(x))
--    !!!  上边的 o, 应该不是 字母o, 暂用o代替
--      例： (square . f) 1,, ()是有必要的， 因为没有括号，编译器会首先结合 f 1, 它不是一个函数，无法参数 . 函数

-- 解 一元二次方程
--    ax^2 + bx + c = 0
-- roots a b c = 
--   ((-b + sqrt(b*b - 4*a*c))/ (2*a),
--   (-b - sqrt(b*b - 4*a*c)) / (2*a))

-- 封装 sqrt(b*b - 4*a*c)
roots a b c =
  let disc = sqrt (b*b - 4*a*c)
      twice_a = 2*a
  in ((-b + disc) / twice_a,
      (-b - disc) / twice_a)
-- 在let 语句中可以声明多个值， 只需要让他们有相同的缩进就可以
