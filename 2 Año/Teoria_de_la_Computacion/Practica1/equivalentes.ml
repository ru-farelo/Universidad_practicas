
open Conj;;
open Auto;;
open Ergo;;
open Graf;;
  
let equivalentes (Af (estados1, alfabeto1, inicial1, transiciones1, finales1))
               (Af (estados2, alfabeto2, inicial2, transiciones2, finales2)) =
  let estado_siguiente (_, s, _) = s in
  let es_final finales estados = Conj.exists (fun e -> pertenece e finales) estados in
  let estados_visitados = ref Conj.conjunto_vacio in
  let cola = ref [(agregar inicial1 Conj.conjunto_vacio, agregar inicial2 Conj.conjunto_vacio)] in
  let rec bfs () =
    match !cola with
    | [] -> true
    | (estados_actuales1, estados_actuales2)::resto ->
      if Conj.pertenece (estados_actuales1, estados_actuales2) !estados_visitados then
        bfs ()
      else
        let estados_visitados' = Conj.agregar (estados_actuales1, estados_actuales2) !estados_visitados in
        if (es_final finales1 estados_actuales1 && not (es_final finales2 estados_actuales2)) ||
           (es_final finales2 estado_actual2 && not (es_final finales1 estado_actual1)) then
          false
        else
          let nuevos_estados = ref Conj.conjunto_vacio in
          iter (fun simbolo ->
            let transiciones1' = filter (fun Arco_af  (e1, _ , s1) -> pertenece e1 estados_actuales1 && s1= simbolo) transiciones in
            let transiciones2' = filter (fun Arco_af  (e2, _ , s2) -> pertenece e2 estados_actuales2 && s2= simbolo) in
            let sig1 = map estado_siguiente transiciones1' in 
            let sig2 = map estado_siguiente transiciones2' in
            if not es_vacio sig1 || not es_vacio sig2 then
            	nuevos_estados := Conj.agregar (sig1, sig2) !nuevos_estados
          ) alfabeto1;
        cola := (list_of_conjunto !nuevos_estados) @ resto;
          estados_visitados := estados_visitados';
          bfs ()
  in
  bfs ();;

