(*Ruben Fernandez Farelo -> Login : ruben.fernandez.farelo@udc.es*)
(*Ejercicio 1*)

let mapdoble f g l = 
  let rec aux n = function
    | [] -> []
    | h :: t -> (if n mod 2 = 0 then f h else g h) :: aux (n + 1) t
  in
  aux 0 l;;

(*
a)
Implementamos la funcion y la explicacion de la misma y la probamos
Para probar : mapdoble (function x -> x) (function x -> -x) [1;1;1;1;1];;

b)
El tipo de la funcion es el siguiente
# mapdoble;;
- : ('a -> 'b) -> ('a -> 'b) -> 'a list -> 'b list = <fun>
 

c)
El valor seria erroneo:
Dara error de tipo, ya que no se podrá aplicar la segunda función, puesto que en la primera función estamos aplicando
un tipado int y en la segunda un tipado string, como el resultado final es una única lista y no puede haber listas
con elementos de diferente tipo, dará error de tipo.

d)
El tipo seria el siguiente: Funcion constante que siempre devuelve un int
# let y = function x -> 5 in mapdoble y;;
- : ('_weak2 -> int) -> '_weak2 list -> int list = <fun>

*)

(*Ejercicio 2*)

let rec primero_que_cumple f l = match l with
	[] -> raise(Not_found)
	| h::t when f h -> h
	| h::t -> primero_que_cumple f t;;
		
(*
b)
primero_que_cumple;;
- : ('a -> bool) -> 'a list -> 'a = <fun>	
Probar ->  primero_que_cumple ((<) 2) [0;1;2;3];;
comprueba si 2 es menor que un número que pasas como parámetro, en este caso el parametro seria un elemento de la 
lista, es decir comprueba 2 < elemento de la lista , se cumpliria para el 3 solo en esta lista que le pasamos
*)	
	
let existe f l = try ((primero_que_cumple f l); true)
              with Not_found -> false;;	
	
(*
val existe : ('a -> bool) -> 'a list -> bool = <fun>
Para probar: existe ((<) 2) [0;1;2;3];;
En este caso al existir el 3 en la lista da True
*)
	


let asociado l c = let aux = function (_, y) -> y 
       in aux (primero_que_cumple (function (x, _) -> x = c) l);;
	
(* 
val asociado : ('a * 'b) list -> 'a -> 'b = <fun>
Para probar: asociado [("a", 1);("b", 2);("c", 3)] "b";;
Tendria que devolver int = 2  que es el valor asociado a b
 *)	
	

(* Ejercicio 3 *)		
	
(*
Para probar las funciones usamos las siguientes instrucciones

type 'a arbol_binario =
	   Vacio
	   | Nodo of 'a * 'a arbol_binario * 'a arbol_binario;;

let h x = Nodo (x, Vacio, Vacio);;
let t = Nodo (3, h 2, Nodo (5, h 4, h 1));;
let t1 = Nodo (3, Nodo (2, h 6, h 8), Nodo (5, h 4, h 1));;

*)
  
(* In_orden *)

let rec in_orden = function
  | Vacio -> []
  | Nodo (r, i, d) -> in_orden i @ [r] @ in_orden d;;

(*
in_orden t;;
- : int list = [2; 3; 4; 5; 1]
*)

(*Pre_orden*)

let rec pre_orden = function
  | Vacio -> []
  | Nodo (r, i, d) -> [r] @ pre_orden i @ pre_orden d;;

(*
pre_orden t;;
- : int list = [3; 2; 5; 4; 1]
*)

(*Post_orden*)

let rec post_orden = function
  | Vacio -> []
  | Nodo (r, i, d) -> post_orden i @ post_orden d @ [r] ;;

(*post_orden t;;
- : int list = [2; 4; 1; 5; 3]
*)

(*Anchura*)
(*Se recorre por niveles*)
let anchura =
  let rec aux = function
    | [], [] -> []
    | [], h :: t | h :: t, [] -> h :: t
    | h1 :: t1, h2 :: t2 -> h1 :: h2 :: aux (t1, t2)
  in
  let rec anchura_aux = function
    | Vacio -> []
    | Nodo (r, i, d) -> r :: aux (anchura_aux i, anchura_aux d)
  in
  anchura_aux;;
 
 (* anchura t;;
- : int list = [3; 2; 5; 4; 1]
*)

(*Ejercicio 4*)
  
(*
Para probar las funciones siguiente funciones ejecutamos previamente estas instrucciones

type 'a conjunto = Conjunto of 'a list;;
let conj1 = Conjunto [0;1;2;3;4];;
let conj2 = Conjunto [4;5;6;7;8;9];;
let conj3 = Conjunto [3;4];;
let conj4 = Conjunto [3;4];;
let list1 = [1;2;2;3];;
*)

let conjunto_vacio = Conjunto [];;

let rec pertenece a = function
     Conjunto []     -> false
   | Conjunto (h::t) -> if (h = a) then true
   			else (pertenece a (Conjunto t));;	
(* Ejemplo
pertenece 4 conj1;;
- : bool = true
*)
	
let agregar a (Conjunto l) = 
   if pertenece a (Conjunto l) then
      Conjunto l
   else
      Conjunto (a::l);;
      
(*Ejemplo
agregar 10 conj1;;
- : int conjunto = Conjunto [10; 0; 1; 2; 3; 4]
*)

let conjunto_of_list l =
  let l_unique = List.sort_uniq compare l in
  Conjunto l_unique;;

(*
Da igual como esten ordenados los elementos si estan los mismos esque es el mismo conjunto
, con esta implementacion conseguimos crear un conjunto que no tenga elementos repetidos
Ejemplo:
conjunto_of_list list1;;
- : int conjunto = Conjunto [1; 2; 3]

*)

let rec suprimir a = function
     Conjunto []     -> conjunto_vacio
   | Conjunto (h::t) -> if (h = a) then 
                           Conjunto t
			else 
                          agregar h (suprimir a (Conjunto t));;
(*
suprimir 10 conj1;;
- : int conjunto = Conjunto [0; 1; 2; 3; 4]
*)


let cardinal (Conjunto l) =
   List.length l;;
(*
cardinal conj1;;
- : int = 5
*)

let union (Conjunto a) (Conjunto b) =
   conjunto_of_list (a @ b);;

(* Al pasarle dos conjuntos se interpreta que los dos se pasan
ya bien, sin elementos repetidos
union conj1 conj2;;
- : int conjunto = Conjunto [0; 1; 2; 3; 4; 5; 6; 7; 8; 9]

*)


let rec interseccion (Conjunto a) = function
     Conjunto []     -> conjunto_vacio
   | Conjunto (h::t) -> if pertenece h (Conjunto a) then 
			   agregar h (interseccion (Conjunto a) (Conjunto t))
			else 
		           interseccion (Conjunto a) (Conjunto t);;
(*
interseccion conj1 conj2;;
- : int conjunto = Conjunto [4]
*)

let rec diferencia (Conjunto a) = function
     Conjunto []     -> Conjunto a
   | Conjunto (h::t) -> diferencia (suprimir h (Conjunto a)) (Conjunto t);;

(*
diferencia conj1 conj2;;
- : int conjunto = Conjunto [0; 1; 2; 3]
*)


let rec incluido = function
     Conjunto []     -> (function _ -> true)
   | Conjunto (h::t) -> (function b -> (pertenece h b) && (incluido (Conjunto t) b));;

(*
incluido conj3 conj1;;
- : bool = true
*)

let igual a b =
   (incluido a b) && (incluido b a);;

(*
igual conj3 conj4;;
- : bool = true
*)

let producto_cartesiano c1 c2 =
	let rec aux l1 l2 = match l1, l2 with
		[], _ | _, [] -> []
        	| h1::t1, h2::t2 -> (h1,h2)::(aux [h1] t2)@(aux t1 l2)
        and aux1 = function
        	Conjunto ([]) -> []
        	| Conjunto (l) -> l
        in Conjunto [aux (aux1 c1) (aux1 c2)];;

(*
  producto_cartesiano conj3 conj1;;
- : (int * int) list conjunto =
Conjunto
 [[(3, 0); (3, 1); (3, 2); (3, 3); (3, 4); (4, 0); (4, 1); (4, 2); (4, 3);
   (4, 4)]]
*)

let list_of_conjunto (Conjunto l) =
   l;;
   
(*
    list_of_conjunto conj3;;
- : int list = [3; 4]
 
*)

	
	


