let rec tree_of_sttree = function
Leaf x -> N (x,V,V)
|Node (r,i,d) -> N(r,tree_of_sttree i , tree_of_sttree d );;

(*Reciproca*)

let rec sttree_of_tree = function 
V -> raise (Invalid_argument "sttree_of_tree")
| N (x,V,V) -> Leaf x
| N  (x,i,d) -> Node (x,sttree_of_tree i ,sttree_of_tree d );;


(*Espejo*)

let rec mirror = function
Leaf x -> Leaf x
| Node (r,i,d) -> Node (r,mirror d,mirror i);;


(**)

type 'a gtree = 
Gt of 'a * 'a gtree list;;