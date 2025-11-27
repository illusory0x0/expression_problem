(* module type Data = sig
    type a 
end *)
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
      'visitor = < add : 'visitor. 'visitor Expr.t -> 'visitor Expr.t -> S.a
                 ; .. >

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
end

(* 
let lhs :
    < add : 'visitor 'a. 'visitor expr -> 'visitor expr -> 'a ; .. > integer =
  new integer 1

let rhs :
    < add : 'visitor 'a. 'visitor expr -> 'visitor expr -> 'a ; .. > integer =
  new integer 2


class my_vis = object 
  method integer : int -> int = fun x -> x
  method add : int -> int -> int = (+)
end 
let expr = new add lhs rhs *)

(* let result = expr#accept (new my_vis) *)
