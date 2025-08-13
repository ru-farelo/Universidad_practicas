let rec qsort1 ord = function
[] -> []
| h::t -> let after, before = List.partition (ord h) t in
qsort1 ord before @ h :: qsort1 ord after;;

(*1 pregunta*)
(*qsort 1 ,en los casos que apliquemos listas lo suficientemente grandes,
sobretodo en listas desordenadas formadas por  numeros 
aleatorios como los que genera 
la  funcion Ramdon.int, al ser no terminal daria Stack Overflow *)

let rec qsort2 ord =
let append' l1 l2 = List.rev_append (List.rev l1) l2 in
function
[] -> []
| h::t -> let after, before = List.partition (ord h) t in
append' (qsort2 ord before) (h :: qsort2 ord after);;

(*2 pregunta*)
(*sqort2 puede ordenar listas aleatorias muy grandes 
sin dar Stack Overflow , ademas el rev_append que implementa es
recursivo terminal*)


(*3 pregunta*)
(*Si, la listas generadas por Random.int, qsort2 seria 
capaz de ordenarla ya que el algoritmo de operaciones e mas eficaz *)

let l1 = List.init 1_000_000
(function _ -> Random.int 1_000_000);;

(* qsort1 (>) l1;;
Stack overflow during evaluation (looping recursion?).
*)

(*4 pregunta*)
(*La principal desventaja es el numero de rutas que tiene que percorrer 
ya que tiene que llamar a la funcion append y ademas a la funcion rev
para darle la vuelta a las listas*)

(*Para comprobar que funcion es mas lenta utilizaremos la funcion crono*)
(*
let crono f x =
    let t = Sys.time () in 
    f x; Sys.time () -. t ;;
*)

(*Ejecutamos la siguiente orden con qsort2 y qsort1 con listas ordanadas y aleatorias*)

(*Ordenadas*)
(*crono (qsort1 (>)) (List.init 1_000 abs);;*)
(*float = 0.68 *)
(*crono (qsort2 (>)) (List.init 1_000 abs);;*)
(*float = 0.86*)

(*Esto se debe al algoritmo que tiene se debe al numero de rutas con el rev_append del qsort 2
es mayor que percorre solo una ruta con el append de qsort1*)

(*Desordenadas*)
(*crono (qsort1 (>)) l1;;*)
(*Stack overflow during evaluation (looping recursion?). *)
(*crono (qsort2 (>)) l1;; *)
(*float = 8.143127*)

(*se agota el stack en qsort 1 ya que el algoritmo que utiliza es cuadratico y hace n^2 pasos
segun el numero de elementos que tenga la lista, sin embargo qsort hace 
n * log en base dos de n pasos que son muchas menos operaciones *)

