class virtual ['visitor, 'a] expr =
  object
    method virtual accept : 'visitor -> 'a
  end

class ['visitor, 'a] integer value =
  object
    constraint 'visitor = < integer : int -> 'a ; .. >
    inherit ['visitor, 'a] expr
    method accept : 'visitor -> 'a = fun vis -> vis#integer value
  end

class ['visitor, 'a] add (lhs : ('visitor, 'a) expr) (rhs : ('visitor, 'a) expr)
  =
  object
    constraint
    'visitor = < add : ('visitor, 'a) expr -> ('visitor, 'a) expr -> 'a ; .. >

    inherit ['visitor, 'a] expr
    method accept : 'visitor -> 'a = fun vis -> vis#add lhs rhs
  end

class virtual ['a] visitor =
  object
    method virtual integer : int -> 'a
    method virtual add : ('a visitor, 'a) expr -> ('a visitor, 'a) expr -> 'a
  end

class eval =
  object (self)
    (* inherit [int] visitor *)
    method integer (x : int) : int = x

    method add =
      fun (lhs : (eval, int) expr) (rhs : (eval, int) expr) : int ->
        lhs#accept (self :> eval) + rhs#accept (self :> eval)
  end

class printer =
  object (self)
    inherit [string] visitor
    method integer = string_of_int

    method add (lhs : (printer, string) expr) (rhs : (printer, string) expr) :
        string =
      "("
      ^ lhs#accept (self :> printer)
      ^ "+"
      ^ rhs#accept (self :> printer)
      ^ ")"
  end

let expr () =
  let lhs = new integer 1 in
  let rhs = new integer 2 in
  new add lhs rhs

let main =
  let vis = new eval in
  let result = (expr ())#accept vis in
  print_int result;
  print_newline ();

  let vis = new printer in
  let result = (expr ())#accept vis in
  print_string result;
  print_newline ();
  ()
