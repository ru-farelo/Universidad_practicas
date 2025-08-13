let print_char c = output_char stdout c;;
Stdlib (*Libreria*)
(*
output_char stdout 'X';;
X- : unit = ()

output_char stdout 'A'; output_char stdout 'B' ;
 output_char stdout '\n';;                       
AB
- : unit = ()

 let s = "ABCDE";;
val s : string = "ABCDE"
 String.get s 2 ;;
- : char = 'C'

("ABC"^"DE").[1+1];;
- : char = 'C'

*)

let output_string sal s = 
	let n = String.length s in
		let rec loop i =
			if i >= n then ()
			else (output_char sal s.[i]; loop (i+1))  
in loop 0;;


let print_string s = output_string stdout s;;

let print_endline s = print_string (s ^ "\n");flush stdout;;

let print_newline () = print_endline " ";;

(*
open_out "prueba";;
- : out_channel = <abstr>
 Te crea un archivo llamado prueba 
 
 let s = open_out "prueba";;
val s : out_channel = <abstr>
Le damos un nombre

output_char s 'A';;
- : unit = ()
Pasamos un char al archivo pero no lo manda al momento Importante!!!

close_out s;;
- : unit = ()
cerramos el archivo y se fuerza la salida que se actualize en el momento

let e = open_in "prueba";;
val e : in_channel = <abstr>
 input_char e;;
 -char = A
Tiene que existir previamente el archivo 

input_line e;;
-string = "C"
*)

let read_line () = flush stdout;input_line stdin;; 







