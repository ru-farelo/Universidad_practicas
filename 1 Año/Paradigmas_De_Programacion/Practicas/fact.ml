let rec fact = function
0 -> 1
| n -> n * fact (n - 1);;  

if Array.length(Sys.argv) = 2

then try fact(int_of_string Sys.argv.(1))
|> string_of_int |> print_endline with

| Stack_overflow -> print_endile ("fact: argumento inválido") 
| Failure "int_of_string" -> print_endile ("fact: argumento inválido")
else  

print_endline ("fact: numero de argumentos invalido")
;; 
 
