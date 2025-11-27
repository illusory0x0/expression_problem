(* 
type 'a visitor = < >
type 'a expr = < accept : 'a visitor >  *)

type ('self, 'a) visitor = < .. > as 'self
type ('self, 'a) integer_visitor = < integer : int -> 'a ; .. > as 'self
type ('self, 'a) add_visitor = < add : 'a -> 'a -> 'a ; .. > as 'self

class virtual expr =
  object
    method virtual accept : 'self 'a. ('self, 'a) visitor -> 'a
  end

let main (accept : ('self, 'a) integer_visitor) = accept#integer 0

class integer (value : int) =
  object
    method accept : 'self 'a. (< integer : int -> 'a ; .. > as 'self) -> 'a =
      fun vis -> vis#integer value
  end
