(*Ruben Fernandez Farelo -> Login : ruben.fernandez.farelo@udc.es*)
(* rlwrap ocaml *)

(* PRÁCTICA 1 *)

#load "talf.cma";;
open Conj;;
open Auto;;
open Ergo;;
open Graf;;

(*Funciones auxiliares del modulo List a Conj utilizadas en la practica a mayores de la librería*)

(*Verifica si todos los elemento del conjunto cumplen una función booleana y devuelve true o false*)
let for_all f (Conjunto l) =
  List.for_all f l;;
(*Verifica si existe un elemento del conjunto cumple una condición booleana y devuelve true o false*)
let exists f (Conjunto l) =
  List.exists f l;; 
(*Busca los elementos que cumplen una condición booleana de un conjunto y los devuelve*)
let filter f (Conjunto l) = 
    Conjunto (List.filter f l) ;;
(*Itera sobre todos los elementos de un conjunto pero no devuelve nada*)
let iter f (Conjunto l) =
    List.iter f l;;
 (*Aplica una funcion a cada elemento del conjunto , elemina los duplicados y los ordena ascendentemente y devuelve un conj resultado*) 
let map f (Conjunto l) =
	Conjunto (List.sort_uniq compare (List.map f l));;

(* EXERCICIO 1 A*)

let es_afne (af : af) : bool =
  let epsilon = Terminal "" in
  let transiciones = match af with
    | Af(_, _, _, transiciones, _) -> transiciones
  in
  let es_afne_estado estado =
    let transiciones_epsilon = filter (fun (Arco_af(estado_origen, _, simbolo)) -> estado_origen = estado && simbolo = epsilon) transiciones in
    let existe_transicion_epsilon = not (es_vacio transiciones_epsilon) in
    let transiciones_estado = filter (fun (Arco_af(estado_origen, _, simbolo)) -> estado_origen = estado && simbolo <> epsilon) transiciones in
    let destinos = map (fun (Arco_af(_, estado_destino, _)) -> estado_destino) transiciones_estado in
    let existe_epsilon_destino = exists (fun estado_destino -> exists (fun (Arco_af(origen, _, simbolo)) -> origen = estado_destino && simbolo = epsilon) transiciones) destinos in
    existe_transicion_epsilon || existe_epsilon_destino
  in
  let estados = match af with | Af(estados, _, _, _, _) -> estados in
  exists es_afne_estado estados;;

  
(* Ejemplo para comprobar con un AFNE , tiene que dar true, si tiene un epsilon ya daria true si no existe ninguno da false *)
let af_example = Af (Conjunto [Estado "0"; Estado "1"; Estado "2"],
Conjunto [Terminal "a"; Terminal "b"],
Estado "0",
Conjunto [Arco_af (Estado "0", Estado "1", Terminal "a");
Arco_af (Estado "1", Estado "2", Terminal "b");
Arco_af (Estado "2", Estado "0", Terminal "a")],
Conjunto [Estado "2"]);;

es_afne af_example;; (*Si nos fijamos tenemos dos arcos epsilon , se puede usar el mismo pero quitando los epsilon y daria*)

(*EXERCICIO 1 B*)

let es_afn (af : af) : bool =
  let transiciones = match af with
    | Af(_, _, _, transiciones, _) -> transiciones
  in
  let es_afn_estado estado =
    let transiciones_estado = List.filter (fun (Arco_af(estado_origen, _, simbolo)) -> estado_origen = estado && simbolo <> Terminal "") (Conj.list_of_conjunto transiciones) in
    let destinos = List.map (fun (Arco_af(_, estado_destino, _)) -> estado_destino) transiciones_estado in
    let destinos_sin_repeticion = List.sort_uniq compare destinos in
    List.length destinos <> List.length destinos_sin_repeticion
  in
  let estados = Conj.list_of_conjunto (match af with | Af(estados, _, _, _, _) -> estados) in
  List.exists es_afn_estado estados;;


(* Ejemplo para comprobar con un AFN , tiene que dar true , para false se puede usar el ejemplo anterior*)

let af_example = Af (Conjunto [Estado "0"; Estado "1"],
Conjunto [Terminal "a"; Terminal "b"],
Estado "0",
Conjunto [Arco_af (Estado "0", Estado "0", Terminal "a");
(*Si quitamos este da false*)
Arco_af (Estado "0", Estado "1", Terminal "b");
Arco_af (Estado "1", Estado "0", Terminal "a");
Arco_af (Estado "1", Estado "1", Terminal "b")],
Conjunto [Estado "1"]);;

es_afn af_example;;


(*EJERCICIO 1 C *)
  
let es_afd (af : af) : bool =
  let transiciones = match af with
    | Af(_, _, _, transiciones, _) -> transiciones
  in
  let es_determinista_estado estado =
    let simbolos = match af with | Af(_, simbolos, _, _, _) -> simbolos in
    for_all (fun simbolo ->
        let transiciones_estado_simbolo = filter (fun (Arco_af(estado_origen, _, simbolo')) -> estado_origen = estado && simbolo' = simbolo) transiciones in
        cardinal transiciones_estado_simbolo = 1
      ) simbolos
  in
  let estados = match af with | Af(estados, _, _, _, _) -> estados in
  for_all es_determinista_estado estados;;


(*ejemplo para probar es un AFD donde todas las transiciones posibles estan definidas y no existe una entrada con dos salidas posibles*)
let af_example = Af (Conjunto [Estado "0"; Estado "1"],
                     Conjunto [Terminal "a"; Terminal "b"],
                     Estado "0",
                     Conjunto [Arco_af (Estado "0", Estado "1", Terminal "");
                               Arco_af (Estado "0", Estado "0", Terminal "b");
                               Arco_af (Estado "1", Estado "1", Terminal "b");
                               Arco_af (Estado "1", Estado "1", Terminal "a")],
                     Conjunto [Estado "1"]) ;;


es_afd af_example;;


(*EJERCICIO 2*)
(*v1*)

let equivalentes (Af (estados1, alfabeto1, inicial1, transiciones1, finales1))
               (Af (estados2, alfabeto2, inicial2, transiciones2, finales2)) =
  let estado_siguiente (Arco_af(_, s, _)) = s in
  let es_final finales estados = exists (fun e -> pertenece e finales) estados in
  let estados_visitados = ref conjunto_vacio in
  let cola = ref [(epsilon_cierre (agregar inicial1 conjunto_vacio) (Af (estados1, alfabeto1, inicial1, transiciones1, finales1)),
                  epsilon_cierre (agregar inicial2 conjunto_vacio) (Af (estados2, alfabeto2, inicial2, transiciones2, finales2)))] in
  let rec bfs () =
    match !cola with
    | [] -> true
    | (estados_actuales1, estados_actuales2)::resto ->
      if pertenece (estados_actuales1, estados_actuales2) !estados_visitados then
      	(cola := resto;
      	 bfs ())
      else
        let estados_visitados' = agregar (estados_actuales1, estados_actuales2) !estados_visitados in
        if (es_final finales1 estados_actuales1 && not (es_final finales2 estados_actuales2)) ||
           (es_final finales2 estados_actuales2 && not (es_final finales1 estados_actuales1)) then
          false
        else
          let nuevos_estados = ref conjunto_vacio in
          iter (fun simbolo ->
            let transiciones1' = filter (fun (Arco_af  (e1, _ , s1)) -> pertenece e1 estados_actuales1 && s1= simbolo) transiciones1 in
            let transiciones2' = filter (fun (Arco_af  (e2, _ , s2)) -> pertenece e2 estados_actuales2 && s2= simbolo) transiciones2 in
            let sig1 = map estado_siguiente transiciones1' in 
            let sig2 = map estado_siguiente transiciones2' in
            let sig1_eps = epsilon_cierre sig1 (Af (estados1, alfabeto1, inicial1, transiciones1, finales1)) in
            let sig2_eps = epsilon_cierre sig2 (Af (estados2, alfabeto2, inicial2, transiciones2, finales2)) in
            if not (es_vacio sig1_eps) || not (es_vacio sig2_eps) then
            	nuevos_estados := agregar (sig1_eps, sig2_eps) !nuevos_estados
          ) (union alfabeto1 alfabeto2);
          cola := (list_of_conjunto !nuevos_estados) @ resto;
          estados_visitados := estados_visitados';
          bfs ()
  in
  bfs ();;

(*Ejemplo *)

let af_example = Af (Conjunto [Estado "0"; Estado "1"],
                     Conjunto [Terminal "a"; Terminal "b"],
                     Estado "0",
                     Conjunto [Arco_af (Estado "0", Estado "1", Terminal "a");
                               Arco_af (Estado "0", Estado "0", Terminal "b");
                               Arco_af (Estado "1", Estado "1", Terminal "b");
                               Arco_af (Estado "1", Estado "1", Terminal "a")],
                     Conjunto [Estado "1"]) ;;



let af_example2 = Af (Conjunto [Estado "0"; Estado "1"],
                     Conjunto [Terminal "a"; Terminal "b"],
                     Estado "0",
                     Conjunto [Arco_af (Estado "0", Estado "1", Terminal "a");
                               Arco_af (Estado "0", Estado "0", Terminal "b");
                               Arco_af (Estado "1", Estado "1", Terminal "b");
                               Arco_af (Estado "1", Estado "1", Terminal "a")],
                     Conjunto [Estado "1"]) ;;
equivalentes af_example af_example2;;

(*EJERCICIO OPCIONAL*)
(*Funcion original*)

let escaner_af cadena (Af (_, _, inicial, _, finales) as a) =

   let rec aux = function

        (Conjunto [], _) ->
           false

      | (actuales, []) ->
           not (es_vacio (interseccion actuales finales))

      | (actuales, simbolo :: t) ->
           aux ((epsilon_cierre (avanza simbolo actuales a) a), t)

   in
      aux ((epsilon_cierre (Conjunto [inicial]) a), cadena)
   ;;
(* APARTADO A*)

let escaner_afn cadena (Af (_, _, inicial, _, finales) as a) =
  let rec reconoce_cadena = function
    (Conjunto [], _) -> false
  | (actuales, []) -> not (es_vacio (interseccion actuales finales))
  | (actuales, simbolo :: t) -> reconoce_cadena (avanza simbolo actuales a, t) (*lo mismo de antes pero sin las epsilon transiciones*)
  in
  reconoce_cadena (Conjunto [inicial], cadena);;

(*PRUEBA, primero pasamos un string a una lista de simbolos y luego le pasamos un automata*)  

let cadena = [Terminal "a"; Terminal "a"; Terminal "b"];;

let af_example = Af (Conjunto [Estado "0"; Estado "1"],
Conjunto [Terminal "a"; Terminal "b"],
Estado "0",
Conjunto [Arco_af (Estado "0", Estado "0", Terminal "a");
Arco_af (Estado "0", Estado "1", Terminal "a");
Arco_af (Estado "0", Estado "1", Terminal "b");
Arco_af (Estado "1", Estado "0", Terminal "a");
Arco_af (Estado "1", Estado "1", Terminal "b")],
Conjunto [Estado "0"]);;

escaner_afn cadena af_example;;

(*tiene que dar true*)

(*APARTADO B*)

let escaner_afd cadena (Af (_, _, inicial, delta, finales) as a) =
  let rec reconoce_cadena = function
    (Conjunto [], _) -> false
  | (actuales, []) -> not (es_vacio (interseccion actuales finales))
  | (actuales, simbolo :: t) -> 
      let siguientes = avanza simbolo actuales a in (**)
      reconoce_cadena (siguientes, t)
  in
  reconoce_cadena (Conjunto [inicial], cadena);;

(*PRUEBA, primero pasamos un string a una lista de simbolos y luego le pasamos un automata*)  

let cadena = [Terminal "a"; Terminal "a"; Terminal "b"];;
 
let af_example = Af (Conjunto [Estado "0"; Estado "1"],
                     Conjunto [Terminal "a"; Terminal "b"],
                     Estado "0",
                     Conjunto [Arco_af (Estado "0", Estado "1", Terminal "a");
                               Arco_af (Estado "0", Estado "0", Terminal "b");
                               Arco_af (Estado "1", Estado "1", Terminal "b");
                               Arco_af (Estado "1", Estado "1", Terminal "a")],
                     Conjunto [Estado "0"]) ;;

escaner_afd cadena af_example;;
