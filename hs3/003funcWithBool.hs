-- 基于Bool值的函数

{-
-- 关键字 module 和 import
--  编写Haskell代码时， 
      第一行， 编译器参数， 可省略
      module XXX where 定义该模块的名字 （控制其他文件中代码对该模块下函数及类型的访问）
      函数、类型 ...

      module Test (f1, f2) where
      f1 = ...
      f2 = ...
      Test 后 () 里的内容， 表示对其他 Haskell代码可见的函数、类型
        此时如果在其他文件中 import Test 那么函数 f3不会被导入， 如果不在Test后写()，那么说明所有函数都是对外可见，如果不想把该文件当做模块在别的文件中调用，那么可以在 Test后加空括号，或者省略 module 定义
      import 关键字可以用来导入需要的库， 也可以从库中导入特定的函数
        如果不想导入或隐藏某些函数，可以使用hiding 关键字
        可以使用 quaified 关键字 对不同的模块命名

-- 建议 Bool值的函数

-}