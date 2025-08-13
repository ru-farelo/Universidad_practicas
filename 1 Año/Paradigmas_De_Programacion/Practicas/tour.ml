let rec filter f l = match l with
[] -> []
|h::t when f h -> h::filter f t 
|h::t -> filter f t;;


let rec movimientos m n (i,j) path = 
let movs = [(i-2,j+1);(i-1,j+2);
(i+1,j+2);(i+1,j-2);(i-1,j-2);(i-2,j-1);(i+2,j-1);(i+2,j+1)]
in filter (function (x,y) -> 
x >= 1 && x <=m && y >= 1 && y <= n && not(List.mem (x,y) path) ) movs ;;
  
 
let tour m n (i,j)(z,f) =
let rec completar path (x,y) movs = if (z,f) = (x,y) then path else match movs with 
|[] -> raise Not_found 
| (i,j)::t -> try  completar ((i,j)::path) (i,j) (movimientos m n (i,j) path)
with Not_found -> completar path (x,y) t
in List.rev(completar [(i,j)] (i,j) (movimientos m n (i,j) [(i,j)] ) );;




