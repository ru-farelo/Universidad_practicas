let to0from x = let rec r_from n x aux =
if n > x then aux else r_from (n+1) x (n::aux)
in r_from 0 x [];;

let fromto n m = let rec r_to n m aux =
if n > m  then aux else r_to n (m-1) (m::aux)
in r_to n m [] ;;

let fromto m = let rec r_to m aux =
if 1 > m  then aux else r_to (m-1) (m::aux)
in r_to  m [] ;;

let map f l =
   let rec r_map aux f l = match l with
        |[] -> aux
         |h::t -> r_map (f h::aux) f t
   in List.rev(r_map [] f l);;

let power x' y = let rec power' x y  =
if y = 0 then x else power' (x*x') (y-1)
in if y >= 0 then power' 1 y
else invalid_arg "power";;


let incseg l = let rec aux l1 x l2 = match l2 with    
[] -> List.rev l1   
|h::t -> aux ((x+h)::l1) (x+h) t    
in aux [] 0 l;;

let remove x l = let rec aux l1 l2 = match l2 with    
[] -> []
|h::t -> if h = x 
then List.rev_append l1 t
else aux (h::l1) t
in aux [] l;;

let divide l = let rec aux limpar lpar l1 =
match l1 with 
[] -> (List.rev limpar, List.rev lpar)
|h1::h2::t -> aux (h1::limpar) (h2::lpar) t 
|h1::[] -> aux  (h1::limpar) lpar []
in aux [] [] l ;;


let compress l = let rec aux l1 = function
[] -> List.rev l1 
|h1::h2::t -> if h1 = h2 then aux l1 (h2::t) else aux (h1::l1) (h2::t)
|h1::[] -> aux (h1::l1) []
in aux [] l;;





