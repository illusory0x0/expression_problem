module Expr = struct
  module type S = sig
    type a
  end
end

module Integer (S : Expr.S) = struct
  module type S = sig
    val integer : int -> S.a
  end
end

module Add (S : Expr.S) = struct
  module type S = sig
    val add : S.a -> S.a -> S.a
  end
end

module Visitor (S : Expr.S) = struct
  module type S = sig
    include Add(S).S
    include Integer(S).S
  end
end

module Main (S : Expr.S) (V : Visitor(S).S) = struct
  let lhs = V.integer 1
  let rhs = V.integer 2
  let expr = V.add lhs rhs
end

module IMain =
  Main
    (struct
      type a = int
    end)
    (struct
      let integer x = x
      let add = ( + )
    end)

module SMain =
  Main
    (struct
      type a = string
    end)
    (struct
      let integer = string_of_int
      let add = ( ^ )
    end)

let main =
  let module SMain =
    Main
      (struct
        type a = string
      end)
      (struct
        let integer = string_of_int
        let add lhs rhs = "(" ^ lhs ^ " + " ^ rhs ^ ")"
      end)
  in
  let module IMain =
    Main
      (struct
        type a = int
      end)
      (struct
        let integer x = x
        let add = ( + )
      end)
  in
  print_string SMain.expr;
  print_newline ();
  print_int IMain.expr;
  print_newline ();
  ()
