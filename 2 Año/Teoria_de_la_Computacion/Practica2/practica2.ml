(*Ruben Fernandez Farelo*)
(*PRACTICA 2*)

(*Ejercicio 1*)
#load "talf.cma";;
open Conj;;
open Auto;;
open Ergo;;
open Graf;;

(*Funciones auxiliares del modulo List a Conj utilizadas en la practica a mayores de la librería*)

(*Verifica si todos los elemento del conjunto cumplen una función booleana y devuelve true o false*)
let for_all f (Conjunto l) =
  List.for_all f l;;

let es_fnc (Gic (_, terminales, reglas, inicio)) =
  let es_terminal = function
    | Terminal _ -> true
    | No_terminal _ -> false
  in
  let es_no_terminal simbolo =
    not (es_terminal simbolo)
  in
  let cumple_requisitos regla =
    match regla with
    | Regla_gic (simbolo, simbolos) ->
      match simbolos with
      | [] -> simbolo = inicio
      | [s] -> es_terminal s
      | [s1; s2] -> es_no_terminal s1 && es_no_terminal s2
      | _ -> false
  in
  let reglas_validas = for_all cumple_requisitos reglas in
  let terminales_validos = for_all es_terminal terminales in
  reglas_validas && terminales_validos;;
  
(* Prueba *)
let g = gic_of_string "S A B C;a b; S;
			S -> A B | B C;
			A -> B A | a b;
			B -> C A | b;
			C -> A B | a; ";;
			
es_fnc g;; (* devuelve true *)
		
(*Ejercicio 2*)

exception InvalidInput of string;;

let cyk input_symbols (Gic (no_terminal, terminales, reglas, inicio)) =
  let n = List.length input_symbols in
  if n = 0 || not (es_fnc (Gic (no_terminal, terminales, reglas, inicio))) then
    raise (InvalidInput "La cadena de entrada debe tener al menos un símbolo y la gramática debe estar en FNC.")
  else
    let m = Array.make_matrix n n [] in
    for i = 0 to n - 1 do
      let simbolos = List.filter_map (fun (Regla_gic (simbolo, simbolos)) ->
        if List.length simbolos = 1 && List.hd simbolos = List.nth input_symbols i then
          Some simbolo
        else
          None
      ) (list_of_conjunto reglas) in
      m.(i).(i) <- simbolos
    done;
    for j = 1 to n - 1 do
      for i = 0 to n - j - 1 do
        let simbolos = ref [] in
        for k = i to i + j - 1 do
          let b = m.(i).(k) in
          let c = m.(k+1).(i+j) in
          List.iter (fun (Regla_gic (simbolo, simbolos')) ->
            if List.length simbolos' = 2 && List.mem (List.hd simbolos') b && List.mem (List.hd (List.tl simbolos')) c then
              simbolos := simbolo :: !simbolos
          ) (list_of_conjunto reglas);
        done;
        m.(i).(i+j) <- !simbolos
      done;
    done;
    List.mem inicio m.(0).(n-1);;

(*Para probarlo*)

let c1 = cadena_of_string "a a";;

let g = gic_of_string "S A B C;a b; S;
			S -> A B | B C;
			A -> B A | a;
			B -> C A | b;
			C -> A B | a; ";;
			
cyk c1 g;;

