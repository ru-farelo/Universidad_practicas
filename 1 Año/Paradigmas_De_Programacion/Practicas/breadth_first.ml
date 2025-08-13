let breadth_first_t arbol = 
	let rec aux arbol acc = match arbol with
		| Gt (x, []) -> x::acc
		| Gt (x, (Gt (y, t2))::t1) -> aux (Gt (y, List.rev_append (List.rev t1) t2)) (x::acc)
	in List.rev(aux arbol []);;

let rec init_gtree n =
	if (n <= 0) then
		Gt(0,[])
	else 
		let p = init_gtree(n-1)
	in Gt(n,[p;p]);;

let t = init_gtree 100000;;
breadth_first arbol;;
(*Stack Overflow*)
breadth_first_t arbol;;