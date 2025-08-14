open Parsing;;
open Lexing;;

open Lambda;;
open Parser;;
open Lexer;;

open String;;
open Str;;



let read_multiline () =
  (* Función auxiliar que acumula las líneas leídas en una lista `acc` *)
  let rec aux acc =
    (* Lee una línea del terminal *)
    let line = read_line () in
    (* Elimina los comentarios del tipo (* ... *) *)
    let line_without_comments = Str.global_replace (Str.regexp "[(][*][^*]*[*][)]") "" line in
    (* Busca si la línea contiene ";;" *)
    try
      let idx = String.index line_without_comments ';' in
      (* Si encuentra ";;", ignora todo lo que esté después *)
      if idx >= 0 && String.length line_without_comments > idx + 1 && line_without_comments.[idx + 1] = ';' then
        (* Recorta lo que esté después de ";;", invierte y une las líneas acumuladas *)
        let trimmed_line = Str.string_before line_without_comments idx in
        String.concat " " (List.rev (trimmed_line :: acc))
      else
        (* Si no termina en ";;", añade la línea al acumulador y sigue leyendo *)
        aux (line_without_comments :: acc)
    with Not_found ->
      (* Si no encuentra ";;", continúa leyendo *)
      aux (line_without_comments :: acc)
  in
  (* Inicia la función auxiliar con una lista vacía *)
  aux []
;;


let top_level_loop () =
  print_endline "Evaluator of lambda expressions...";
  let rec loop ctx =
    print_string ">> ";
    flush stdout;
    try
      let c = s token (from_string (read_multiline ())) in
      loop (execute ctx c)
    with
       Lexical_error ->
         print_endline "lexical error";
         loop ctx
     | Parse_error ->
         print_endline "syntax error";
         loop ctx
     | Type_error e ->
         print_endline ("type error: " ^ e);
         loop ctx
     | End_of_file ->
         print_endline "...bye!!!"
  in
    loop emptyctx
  ;;

top_level_loop ()
;;