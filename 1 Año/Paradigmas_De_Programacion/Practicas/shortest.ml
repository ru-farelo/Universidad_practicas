(*Shortes*)

let rec filter f l = match l with
[] -> []
|h::t when f h -> h::filter f t 
|h::t -> filter f t;;


let rec movimientos m n (i,j) path = 
let movs = [(i-2,j+1);(i-1,j+2);
(i+1,j+2);(i+1,j-2);(i-1,j-2);(i-2,j-1);(i+2,j-1);(i+2,j+1)]
in filter (function (x,y) -> 
x >= 1 && x <=m && y >= 1 && y <= n && not(List.mem (x,y) path) ) movs ;;

let shortest_tour  m n (i,j)(z,f) = 
    let rec aux visitadas nivel = match nivel with
        [] -> List.rev visitadas
        |(i,j)::t -> aux ((i,j)::nivel) (i,j) (movimientos m n (i,j) nivel)
        in aux [(i,j)] [];;