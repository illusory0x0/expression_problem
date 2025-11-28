module Data = struct
  module type S = sig
    type a
  end
end

module Expr (S : Data.S) = struct
  class virtual ['visitor] t =
    object
      method virtual accept : 'visitor -> S.a
    end
end

module Integer (S : Data.S) = struct
  module Expr = Expr (S)

  class ['visitor] t (value : int) =
    object
      constraint 'visitor = < integer : int -> S.a ; .. >
      inherit ['visitor] Expr.t
      method accept : 'visitor -> S.a = fun vis -> vis#integer value
    end
end

module Add (S : Data.S) = struct
  module Expr = Expr (S)

  class ['visitor] t (lhs : 'visitor Expr.t) (rhs : 'visitor Expr.t) =
    object
      constraint
      'visitor = < add : 'visitor Expr.t -> 'visitor Expr.t -> S.a ; .. >

      inherit ['visitor] Expr.t
      method accept : 'visitor -> S.a = fun vis -> vis#add lhs rhs
    end
end

module Main (S : Data.S) = struct
  module Expr = Expr (S)
  module Integer = Integer (S)
  module Add = Add (S)

  let lhs = new Integer.t 1
  let rhs = new Integer.t 2
  let expr = new Add.t lhs rhs

  class virtual visitor =
    object
      method virtual integer : int -> S.a
      method virtual add : visitor Expr.t -> visitor Expr.t -> S.a
    end
end

module IMain = Main (struct
  type a = int
end)

module SMain = Main (struct
  type a = string
end)

let accept vis = IMain.lhs#accept vis

class eval =
  object (self)
    inherit IMain.visitor
    method integer x = x
    method add lhs rhs = lhs#accept (self :> eval) + rhs#accept (self :> eval)
  end

class printer =
  object (self)
    inherit SMain.visitor
    method integer = string_of_int

    method add lhs rhs =
      "("
      ^ lhs#accept (self :> printer)
      ^ "+"
      ^ rhs#accept (self :> printer)
      ^ ")"
  end

let main =
  let vis = new eval in
  let result = IMain.expr#accept vis in
  print_int result;
  print_newline ();
  let vis = new printer in
  let result = SMain.expr#accept vis in
  print_string result;
  print_newline ();
  ()
