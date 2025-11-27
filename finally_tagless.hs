{-# LANGUAGE Strict #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE NoImplicitPrelude #-}

import Data.IntMap (insert)
import Prelude (IO, Int, print, (+))

class Expr a

class (Expr a) => Integer a where
  integer :: Int -> a

class (Expr a) => Add a where
  add :: a -> a -> a

instance Expr Int

instance Integer Int where
  integer :: Int -> Int
  integer x = x

instance Add Int where
  add :: Int -> Int -> Int
  add = (+)

lhs :: (Integer a) => a
lhs = integer 1

rhs :: (Integer a) => a
rhs = integer 2

expr :: (Integer a, Add a) => a
expr = add lhs rhs

main :: IO ()
main = do
  print (expr @Int)