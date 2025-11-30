{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE Strict #-}
{-# LANGUAGE NoImplicitPrelude #-}

import Data.Kind (Type)
import Prelude hiding (Integer)

class
  IExpr
    (self :: Type -> Type -> Type)
    (a :: Type)
    (visitor :: Type)
  where
  accept :: self a visitor -> visitor -> a

data
  Expr
    (a :: Type)
    (visitor :: Type)
  = forall self. (IExpr self a visitor) => Expr (self a visitor)

instance
  IExpr
    Expr
    (a :: Type)
    (visitor :: Type)
  where
  accept :: Expr a visitor -> visitor -> a
  accept (Expr self) = accept self

newtype
  Integer
    (a :: Type)
    (visitor :: Type)
  = Integer Int
data
  Add
    (a :: Type)
    (visitor :: Type)
  = Add (Expr a visitor) (Expr a visitor)

class IntegerVisitor self a where
  integer :: self -> Int -> a

class AddVisitor self a where
  add :: self -> Expr a self -> Expr a self -> a

instance (IntegerVisitor visitor a) => IExpr Integer a visitor where
  accept :: (IntegerVisitor visitor a) => Integer a visitor -> visitor -> a
  accept (Integer value) visitor = integer visitor value

instance (AddVisitor visitor a) => IExpr Add a visitor where
  accept :: (AddVisitor visitor a) => Add a visitor -> visitor -> a
  accept (Add lhs rhs) visitor = add visitor lhs rhs

data Algebra a = Algebra
  { algebra_integer :: Int -> a
  , algebra_add :: Expr a (Algebra a) -> Expr a (Algebra a) -> a
  }

type Eval = Algebra Int

type Print = Algebra String

instance IntegerVisitor (Algebra a) a where
  integer :: Algebra a -> Int -> a
  integer = algebra_integer

instance AddVisitor (Algebra a) a where
  add :: Algebra a -> Expr a (Algebra a) -> Expr a (Algebra a) -> a
  add = algebra_add

evalVis :: Eval
evalVis =
  Algebra
    { algebra_integer = id
    , algebra_add = \(Expr lhs) (Expr rhs) -> accept lhs evalVis + accept rhs evalVis
    }

printVis :: Print
printVis =
  Algebra
    { algebra_integer = show
    , algebra_add = \(Expr lhs) (Expr rhs) -> concat ["(", accept lhs printVis, "+", accept rhs printVis, ")"]
    }

main :: IO ()
main = do
  let lhs = Expr (Integer 1)
  let rhs = Expr (Integer 2)
  let expr = Expr (Add (Expr lhs) (Expr rhs))
  print (accept expr evalVis :: Int)

  let lhs = Expr (Integer 1)
  let rhs = Expr (Integer 2)
  let expr = Expr (Add (Expr lhs) (Expr rhs))
  print (accept expr printVis :: String)
