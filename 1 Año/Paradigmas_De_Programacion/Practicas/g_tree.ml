type 'a g_tree = Gt of 'a * 'a g_tree list;;

let rec size = function
    Gt (_,[]) -> 1
  | Gt (r,h::t) ->  size h + size (Gt (r,t));;


let rec height  = function 
 Gt (_,[]) -> 1
 | Gt (r,h::t) ->  let rec alturaLista = function
  [] -> 0
 | h::t -> max (height h) (alturaLista t)
  in 1 + alturaLista (h::t) ;;


let rec leaves = function
|Gt (r,[]) -> [r]
|Gt (r,h::t) -> let rec leavesList = function
[] -> []
|h::t -> leaves	h @ (leavesList t)
in  leavesList (h::t);;

let rec mirror = function
Gt (r,[]) -> Gt (r,[]) 
|Gt (r,l) -> Gt (r,List.rev_map mirror l);;


let rec preorder = function
 Gt(r,[]) ->   [r]
 |Gt (r,h::t) -> let rec preorderList = function
 [] -> []
 |h::t -> preorder h @ preorderList t
 in r::preorderList (h::t) ;;
	

let rec postorder = function
 Gt(r,[]) ->   [r]
 |Gt (r,h::t) -> let rec postorderList= function
 [] -> []
 |h::t -> postorder h @ postorderList t
 in postorderList(h::t) @ [r] ;;



