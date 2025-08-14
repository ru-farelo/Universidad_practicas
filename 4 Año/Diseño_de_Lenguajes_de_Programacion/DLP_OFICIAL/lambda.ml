open Format;;


(* TYPE DEFINITIONS *)

type ty =
    TyBool
  | TyNat
  | TyArr of ty * ty
  | TyString (* Apartado 2.3 Se agrego el tipo TyString *)
  | TyVar of string 
  | TyTuple of ty list (* Apartado 2.4 Se agrego el tipo TyTuple *)
  | TyRecord of (string * ty) list (* Apartado 2.5 Se agrego el tipo TyRecord *)
  | TyVariant of (string * ty) list (* Apartado 2.7 Se agrego el tipo TyVariant *)
  | TyList of ty (* Apartado 2.8 Se agrego el tipo TyList *)
;;

type term =
    TmTrue
  | TmFalse
  | TmIf of term * term * term
  | TmZero
  | TmSucc of term
  | TmPred of term
  | TmIsZero of term
  | TmVar of string
  | TmAbs of string * ty * term
  | TmApp of term * term
  | TmLetIn of string * term * term
  | TmFix of term (* Apartado 2.1 Se agrego el constructor TmFix *)
  | TmString of string (* Apartado 2.3 Se agrego el constructor TmString *)
  | TmConcat of term * term (* Apartado 2.3 Se agrego el constructor TmConcat *)
  | TmTuple of term list (* Apartado 2.4 Se agrego el constructor TmTuple *)
  | TmRecord of (string * term) list (* Apartado 2.5 Se agrego el constructor TmRecord *)
  | TmGetElem of term * string (* Apartado 2.5 Se agrego el constructor TmGetElem *)
  | TmTag of string * term * ty (* Apartado 2.7 Se agrego el constructor TmTag *)
  | TmCase of term * (string * string * term) list (* Apartado 2.7 Se agrego el constructor TmCase *)
  | TmNil of ty (* Apartado 2.8 Se agrego el constructor TmNil *)
	| TmCons of ty * term * term (* Apartado 2.8 Se agrego el constructor TmCons *)
	| TmIsNil of ty * term (* Apartado 2.8 Se agrego el constructor TmIsNil *)
	| TmHead of ty * term (* Apartado 2.8 Se agrego el constructor TmHead *)
	| TmTail of ty * term (* Apartado 2.8 Se agrego el constructor TmTail *)
;;
type command =
    Eval of term
  | Bind of string * term
  | TBind of string * ty (* Nuevo caso para alias de tipo *)
  | Quit


type binding =
    TyBind of ty
  | TyTmBind of (ty * term)

type context =
  (string * binding) list



(* CONTEXT MANAGEMENT *)

let emptyctx =
  []
;;

let addtbinding ctx s ty =
  (s, TyBind ty) :: ctx
;;

let addvbinding ctx s ty tm =
  (s, TyTmBind (ty, tm)) :: ctx
;;

let gettbinding ctx s =
  match List.assoc s ctx with
      TyBind ty -> ty
    | TyTmBind (ty, _) -> ty
;;

let getvbinding ctx s =
  match List.assoc s ctx with
    | TyTmBind (_, tm) -> tm
    | _ -> raise Not_found
;;


(*Pretty printer de tipos*)
  let rec string_of_ty = function
| TyArr (ty1, ty2) -> 
    open_box 1;
    print_atomic_ty ty1;
    print_string " -> ";
    print_space ();
    string_of_ty ty2;
    close_box ();

| ty -> print_atomic_ty ty

and print_atomic_ty = function
| TyBool -> print_string "Bool"
| TyNat -> print_string "Nat"
| TyString -> print_string "String" 
| TyVar s -> print_string s
| TyTuple tyseq -> 
  open_box 1;
  print_string "{"; 
  print_cut ();
  let rec print_list printer sep = function
    | [] -> ()
    | [x] -> printer x
    | x :: xs -> printer x; print_string sep; print_list printer sep xs
  in
  print_list string_of_ty "," tyseq;
  print_string "}";
  close_box ();
| TyRecord tyseq ->
  open_box 1;
  print_string "{"; 
  print_cut ();
  let print_elem (s, ty) = print_string s; print_string " : "; string_of_ty ty in
  let rec print_seq = function
    | [] -> ()
    | [x] -> print_elem x
    | x :: xs -> print_elem x; print_string " , "; print_seq xs
  in
  print_seq tyseq;
  print_string "}";
  close_box ();

| TyVariant l ->
  open_box 1;
  print_string "<"; 
  let print_elem (s, ty) = print_string s; print_string " : "; string_of_ty ty in
  let rec print_seq = function
    | [] -> ()
    | [x] -> print_elem x
    | x :: xs -> print_elem x; print_string " , "; print_seq xs
  in
  print_seq l;
  print_string ">";
  close_box ();

| TyList ty ->
  open_box 1;
  print_string "List["; 
  string_of_ty ty; 
  print_string "]";
  close_box ();

| ty ->
  open_box 1;
  print_string "("; 
  string_of_ty ty; 
  print_string ")";
  close_box ();
;;



(*******************************************************************)

exception Type_error of string
;;


(* ctx: contexto de tipos; ty: tipo a resolver *)
let rec resolve_base_type ctx ty =
  let resolve_seq seq resolve_elem =
    List.map resolve_elem seq
  in
  match ty with
  | TyNat -> TyNat
  | TyArr (ty1, ty2) -> TyArr (resolve_base_type ctx ty1, resolve_base_type ctx ty2)
  | TyVar s ->
      (try gettbinding ctx s with Not_found -> TyVar s)
  | TyBool -> TyBool
  | TyString -> TyString
  | TyTuple tyseq -> TyTuple (resolve_seq tyseq (resolve_base_type ctx))
  | TyRecord tyseq -> TyRecord (resolve_seq tyseq (fun (s, ty) -> (s, resolve_base_type ctx ty)))
  | TyVariant l -> TyVariant (List.map (fun (s, ty) -> (s, resolve_base_type ctx ty)) l)
  | TyList ty -> TyList (resolve_base_type ctx ty)
;;

(*Funcion de subtipado *)
let rec subtype tyS tyT = 
  (=) tyS tyT ||
  match (tyS, tyT) with
  (TyRecord fS, TyRecord fT) ->
    List.for_all (fun (li, tyTi) -> try let tySi = List.assoc li fS in subtype tySi tyTi with Not_found -> false) fT
  | (TyArr (tyS1, tyS2), TyArr (tyT1, tyT2)) -> subtype tyT1 tyS1 && subtype tyS2 tyT2
  | (_,_)-> false

let rec typeof ctx tm =
  let get_types seq map_elem =
    List.map map_elem seq
  in
  match tm with
    (* T-True *)
    TmTrue -> TyBool

    (* T-False *)
  | TmFalse -> TyBool

    (* T-If *)
  | TmIf (t1, t2, t3) ->
      if typeof ctx t1 = TyBool then
        let tyT2 = typeof ctx t2 in
        if typeof ctx t3 = tyT2 then tyT2
        else raise (Type_error "arms of conditional have different types")
      else
        raise (Type_error "guard of conditional not a boolean")

    (* T-Zero *)
  | TmZero -> TyNat

    (* T-Succ *)
  | TmSucc t1 ->
      if typeof ctx t1 = TyNat then TyNat
      else raise (Type_error "argument of succ is not a number")

    (* T-Pred *)
  | TmPred t1 ->
      if typeof ctx t1 = TyNat then TyNat
      else raise (Type_error "argument of pred is not a number")

    (* T-Iszero *)
  | TmIsZero t1 ->
      if typeof ctx t1 = TyNat then TyBool
      else raise (Type_error "argument of iszero is not a number")

    (* T-Var *)
  | TmVar x ->
      (try gettbinding ctx x with
       _ -> raise (Type_error ("no binding type for variable " ^ x)))

    (* T-Abs *)
  | TmAbs (x, tyT1, t2) ->
      let btyT1 = resolve_base_type ctx tyT1 in
      let ctx' = addtbinding ctx x btyT1 in
      let tyT2 = typeof ctx' t2 in
      TyArr (btyT1, tyT2)

    (* T-App *) (*Aqui creo que va la de subtipado*)
  | TmApp (t1, t2) ->
      let tyT1 = typeof ctx t1 in
      let tyT2 = typeof ctx t2 in
      (match tyT1 with
         TyArr (tyT11, tyT12) ->
           if subtype tyT2 tyT11 then tyT12
           else raise (Type_error "parameter type mismatch")
       | _ -> raise (Type_error "arrow type expected"))

    (* T-Let *)
  | TmLetIn (x, t1, t2) ->
      let tyT1 = typeof ctx t1 in
      let ctx' = addtbinding ctx x tyT1 in
      typeof ctx' t2

    (* T-Fix *)
  | TmFix t1 -> 
      let tyT1 = typeof ctx t1 in  
      (match tyT1 with 
        | TyArr (tyT11, tyT12) when tyT12 = tyT11 -> tyT12
        | TyArr _ -> raise (Type_error "result of body is not compatible with domain")
        | _ -> raise (Type_error "arrow type expected"))

    (* Strings *)
  | TmString _ -> TyString
    
   (*Concat*)
  | TmConcat (t1, t2) ->
      if typeof ctx t1 = TyString && typeof ctx t2 = TyString then TyString
      else raise (Type_error "arguments of concat are not strings")

    (* Tuples *)
  | TmTuple tup ->
      TyTuple (get_types tup (typeof ctx))
  (* Record *)
  | TmRecord reco ->
      TyRecord (get_types reco (fun (s, tm) -> (s, typeof ctx tm)))
  (* GetElem *)
  | TmGetElem (t, x) ->
      (match (typeof ctx t, x) with
         (TyRecord reco, s) ->
           (try List.assoc s reco with
            _ -> raise (Type_error (s ^ " key doesn't exist in record")))
       | (TyTuple tup, s) ->
           (try List.nth tup (int_of_string s - 1) with
            _ -> raise (Type_error (s ^ " is out of bounds for this tuple")))
       | (y, _) -> raise (Type_error ("expected tuple or record type, got " ^ (string_of_ty y; Format.flush_str_formatter ()))))

  (* TmTag *)
  | TmTag (s, tm, ty) ->
      let tyT1 = typeof ctx tm in
      let tyT2 = resolve_base_type ctx ty in
      (match tyT2 with
        | TyVariant l ->
            (try
                if tyT1 = List.assoc s l then tyT2
                else raise (Type_error "type mismatch in tag")
            with Not_found -> raise (Type_error "tag not found in variant"))
        | _ -> raise (Type_error "expected variant type"))


  (* TmCase *)
  | TmCase (t, cases) ->
    let tyT1 = typeof ctx t in
    (match tyT1 with 
       TyVariant l ->
          let vtags = List.map (function (tag, _) -> tag) l in
          let ctags = List.map (function (tag, _, _) -> tag) cases in
          if List.length vtags  = List.length ctags && List.for_all (fun x -> List.mem x vtags) ctags
            then
              let (tag1, tm1, ty1) = List.hd cases in
              let tyT1 = List.assoc tag1 l in
              let ctx' = addtbinding ctx tm1 tyT1 in
              let tyT2 = typeof ctx' ty1 in
              let rec aux = function
                | [] -> tyT2
                | (tag, tm, ty)::tl ->
                    let tyT = List.assoc tag l in
                    let ctx' = addtbinding ctx tm tyT in
                    let tyT' = typeof ctx' ty in
                    if tyT' = tyT2 then aux tl
                    else raise (Type_error "branches have different types")
              in aux (List.tl cases)
            else raise (Type_error "no branches in case")
      | _ -> raise (Type_error "expected variant type"))


  (* T-Nil *)
	| TmNil ty -> TyList ty

	(* T-Cons *)
	| TmCons (ty, t1, t2) -> 
		let rec types type' head tail =
			(match (typeof ctx head, tail) with
				(ty', TmNil t1') when (ty'=type') && (t1'=type') ->
					TyList type'
				|(ty', TmCons (type1, head1, tail1)) when (ty'=type') && (type1=type') ->
					types type1 head1 tail1
				|(ty', a) when (ty' = type') && (typeof ctx a = TyList(type'))->
					TyList type'
				|(_,_) -> raise(Type_error("List is not homogeneous")))
		in types ty t1 t2
	
	(* T-IsNil *)
	| TmIsNil (ty,t) ->
		if typeof ctx t = TyList(ty) then TyBool
		else 
      raise (Type_error ("argument of isnil is not a List [" ^ (string_of_ty (typeof ctx t); Format.flush_str_formatter ()) ^ "]"))
	
	(* T-Head *)
	| TmHead (ty,t) ->
		if typeof ctx t = TyList(ty) then ty
		else 
      raise (Type_error ("argument of head is not a List [" ^ (string_of_ty (typeof ctx t); Format.flush_str_formatter ()) ^ "]"))
  
  (* T-Tail *)
  | TmTail (ty,t) ->
    if typeof ctx t = TyList(ty) then TyList (ty)
    else raise (Type_error ("argument of tail is not a List [" ^ (string_of_ty (typeof ctx t); Format.flush_str_formatter ()) ^ "]"))
    

;;

(*Pretty printer de terminos*)
let rec string_of_term  = function
     TmIf (t1, t2, t3) -> 
        open_box 1;
        print_string "if ";
        string_of_term t1;
        print_space ();
        print_string "then ";
        string_of_term t2;
        print_space ();
        print_string "else ";
        string_of_term t3;
        close_box ()
    | TmAbs (s, tyS, t) ->
        open_box 1;
        print_string "lambda ";
        print_string s;
        print_string ": ";
        string_of_ty tyS;
        print_string ". ";
        print_space ();
        string_of_term t;
        close_box ()
    | TmLetIn (s, t1, t2) ->
        open_box 1;
        print_string "let ";
        print_string s;
        print_string " = ";
        print_space ();
        string_of_term t1;
        print_space ();
        print_string "in ";
        print_space ();
        string_of_term t2;
        close_box ()
    |TmTag (s, t, ty) ->
        open_box 1;
        print_string "<";
        print_string s;
        print_string " = ";
        string_of_term t;
        print_string " as ";
        string_of_ty ty;
        print_string ">";
        close_box ()
    | TmCase (t, cases) ->
        open_box 1;
        print_string "case ";
        string_of_term t;
        print_space ();
        print_string "of ";
        let rec f = function
            | [] -> ()
            | (s1, s2, t)::tl ->
                print_space ();
                print_string "| <";
                print_string s1;
                print_string " = ";
                print_string s2;
                print_string "> => ";
                string_of_term t;
                f tl
        in f cases;
        close_box ()

    | tm -> appTerm_to_string tm

  and appTerm_to_string = function
     TmPred t ->
        open_box 1;
        print_string "pred ";
        atomicTerm_to_string t; 
        close_box ()
    | TmIsZero t ->
        open_box 1;
        print_string "iszero ";
        atomicTerm_to_string t;
        close_box ()
    | TmFix t -> 
        open_box 1;
        print_string "fix ";
        atomicTerm_to_string t;
        close_box ()
    | TmConcat (t1, t2) ->
        open_box 1;
        print_string "concat ";
        atomicTerm_to_string t1;
        print_space ();
        atomicTerm_to_string t2;
        close_box ()
    |TmCons (ty, t1, t2) ->
        open_box 1;
        print_string "cons[";
        string_of_ty ty;
        print_string "] ";
        atomicTerm_to_string t1;
        print_space ();
        atomicTerm_to_string t2;
        close_box ()
    |TmIsNil (ty, t) ->
        open_box 1;
        print_string "isnil[";
        string_of_ty ty;
        print_string "] ";
        atomicTerm_to_string t;
        close_box ()

    |TmHead (ty, t) ->
        open_box 1;
        print_string "head[";
        string_of_ty ty;
        print_string "] ";
        atomicTerm_to_string t;
        close_box ()

    |TmTail (ty, t) ->
        open_box 1;
        print_string "tail[";
        string_of_ty ty;
        print_string "] ";
        atomicTerm_to_string t;
        close_box ()
    | TmApp (t1, t2) -> 
        open_box 1;
        appTerm_to_string t1;
        print_space ();
        atomicTerm_to_string t2;
        close_box ()
    | tm -> atomicTerm_to_string tm

  and atomicTerm_to_string = function
     TmTrue -> print_string "true"
    | TmFalse -> print_string "false"
    | TmZero -> print_string "0"
    | TmVar s -> print_string s
    | TmString s -> print_string ("\"" ^ s ^ "\"")
    | TmSucc t -> 
        let rec f n t' = match t' with
            | TmZero -> print_int n
            | TmSucc s -> f (n+1) s
            | _ -> 
                print_string "(succ ";
                atomicTerm_to_string t;
                print_string ")";
        in f 1 t
    | TmTuple terms ->
        open_box 1;
        print_string "{";
        let rec f = function
            | [] -> ()
            | [tm] -> atomicTerm_to_string tm
            | tm::tl -> atomicTerm_to_string tm; print_string ", "; f tl
        in f terms;
        print_string "}";
        close_box ()
    | TmRecord fields ->
        open_box 1;
        print_string "{";
        let rec f = function
            | [] -> ()
            | [(s, tm)] -> print_string s; print_string " = "; atomicTerm_to_string tm
            | (s, tm)::tl -> print_string s; print_string " = "; atomicTerm_to_string tm; print_string ", "; f tl
        in f fields;
        print_string "}";
        close_box ()
    | TmGetElem (t, s) ->
        open_box 1;
        atomicTerm_to_string t;
        print_string ".";
        print_string s;
        close_box ()
    | TmNil ty ->
        open_box 1;
        print_string "nil[";
        string_of_ty ty;
        print_string "]";
        close_box ()
    | tm -> 
        open_box 1;
        print_string "(";
        string_of_term tm;
        print_string ")";
        close_box ();
;;

 
let pretty_printer s ty tm = 
  open_box 1;
  print_string s;
  print_string " : ";
  print_space ();
  string_of_ty ty;
  print_string " = ";
  print_space ();
  string_of_term tm;
  close_box ();
  force_newline ();
  print_flush ();;


  let pretty_printer_ty s ty =
  open_box 1;
  print_string "type ";
  print_string s;
  print_string " = ";
  print_space ();
  string_of_ty ty;
  close_box ();
  force_newline ();
  print_flush ();;


let rec ldif l1 l2 = match l1 with
    [] -> []
  | h::t -> if List.mem h l2 then ldif t l2 else h::(ldif t l2)
;;

let rec lunion l1 l2 = match l1 with
    [] -> l2
  | h::t -> if List.mem h l2 then lunion t l2 else h::(lunion t l2)
;;

let rec free_vars tm = match tm with
  | TmTrue -> []
  | TmFalse -> []
  | TmIf (t1, t2, t3) -> lunion (lunion (free_vars t1) (free_vars t2)) (free_vars t3)
  | TmZero -> []
  | TmSucc t -> free_vars t
  | TmPred t -> free_vars t
  | TmIsZero t -> free_vars t
  | TmVar s -> [s]
  | TmAbs (s, _, t) -> ldif (free_vars t) [s]
  | TmApp (t1, t2) -> lunion (free_vars t1) (free_vars t2)
  | TmLetIn (s, t1, t2) -> lunion (ldif (free_vars t2) [s]) (free_vars t1)
  | TmFix t -> free_vars t (* Apartado 2.1 Se agrego el caso para el constructor TmFix Comprobado *)
  | TmString _ -> [] (* Apartado 2.3 Se agrego el caso para el constructor TmString *)
  | TmConcat (t1, t2) -> lunion (free_vars t1) (free_vars t2) (* Apartado 2.3 Se agrego el caso para el constructor TmConcat *)
  | TmTuple terms -> (* Apartado 2.4 Se agrego el caso para el constructor TmTuple *)
      List.fold_left (fun acc tm -> lunion acc (free_vars tm)) [] terms
  | TmRecord fields -> (* Apartado 2.4 Se agrego el caso para el constructor TmRecord *)
      List.fold_left (fun acc (_, tm) -> lunion acc (free_vars tm)) [] fields
  | TmGetElem (t, _) -> free_vars t (* Apartado 2.5 Se agrego el caso para el constructor TmGetElem *)
  | TmTag (_, t, _) -> free_vars t (* Apartado 2.7 Se agrego el caso para el constructor TmTag *)
  | TmCase (t, cases) ->  (* Apartado 2.7 Se agrego el caso para el constructor TmCase *)
      let case_vars = List.fold_left (fun acc (_, id, t) -> lunion acc (ldif (free_vars t) [id])) [] cases in
      lunion (free_vars t) case_vars
  | TmNil ty -> (* Apartado 2.8 Se agrego el caso para el constructor TmNil *)
    []
  | TmCons (ty,t1,t2) -> (* Apartado 2.8 Se agrego el caso para el constructor TmCons *)
    lunion (free_vars t1) (free_vars t2)
  | TmIsNil (ty,t) -> (* Apartado 2.8 Se agrego el caso para el constructor TmIsNil *)
    free_vars t
  | TmHead (ty,t) -> (* Apartado 2.8 Se agrego el caso para el constructor TmHead *)
    free_vars t
  | TmTail (ty,t) ->  (* Apartado 2.8 Se agrego el caso para el constructor TmTail *)
    free_vars t

    ;;

let rec fresh_name x l =
  if not (List.mem x l) then x else fresh_name (x ^ "'") l
;;

let rec subst x s tm = match tm with
  | TmTrue -> TmTrue
  | TmFalse -> TmFalse
  | TmIf (t1, t2, t3) -> TmIf (subst x s t1, subst x s t2, subst x s t3)
  | TmZero -> TmZero
  | TmSucc t -> TmSucc (subst x s t)
  | TmPred t -> TmPred (subst x s t)
  | TmIsZero t -> TmIsZero (subst x s t)
  | TmVar y -> if y = x then s else tm
  | TmAbs (y, tyY, t) ->
      if y = x then tm
      else 
        let fvs = free_vars s in
        if not (List.mem y fvs)
        then TmAbs (y, tyY, subst x s t)
        else 
          let z = fresh_name y (free_vars t @ fvs) in
          TmAbs (z, tyY, subst x s (subst y (TmVar z) t))
  | TmApp (t1, t2) -> TmApp (subst x s t1, subst x s t2)
  | TmLetIn (y, t1, t2) ->
      if y = x then TmLetIn (y, subst x s t1, t2)
      else 
        let fvs = free_vars s in
        if not (List.mem y fvs)
        then TmLetIn (y, subst x s t1, subst x s t2)
        else 
          let z = fresh_name y (free_vars t2 @ fvs) in
          TmLetIn (z, subst x s t1, subst x s (subst y (TmVar z) t2))
  | TmFix t -> TmFix (subst x s t) (* Apartado 2.1 Se agrego el caso para el constructor TmFix Comprobado *)
  | TmString st -> TmString st (* Apartado 2.3 Se agrego el caso para el constructor TmString *)
  | TmConcat (t1, t2) -> TmConcat (subst x s t1, subst x s t2) (* Apartado 2.3 Se agrego el caso para el constructor TmConcat *)
  | TmTuple tup -> TmTuple (List.map (subst x s) tup) (* Apartado 2.4 Se agrego el caso para el constructor TmTuple *)
  | TmRecord reco -> TmRecord (List.map (fun (st, tm) -> (st, subst x s tm)) reco) (* Apartado 2.4 Se agrego el caso para el constructor TmRecord *)
  | TmGetElem (t, y) -> TmGetElem (subst x s t, y) (* Apartado 2.5 Se agrego el caso para el constructor TmGetElem *)
  | TmTag (lbl, t, ty) -> TmTag (lbl, subst x s t, ty)
  | TmCase (t, cases) -> (*Comprobar al final si funciona en principio con esta implementacion si LA IMPLEMETACION ES SIMILAR A LA DE LA ABSTRACCION EN CASO DE CAMBIARLO*)
      TmCase (subst x s t, List.map (fun (tag, id, t) -> (tag, id, if id = x then t else subst x s t)) cases)
  | TmNil ty ->(* Apartado 2.8 Se agrego el caso para el constructor TmNil *)
    tm
  | TmCons (ty,t1,t2) -> (* Apartado 2.8 Se agrego el caso para el constructor TmCons *)
    TmCons (ty, (subst x s t1), (subst x s t2))
  | TmIsNil (ty,t) -> (* Apartado 2.8 Se agrego el caso para el constructor TmIsNil *)
    TmIsNil (ty, (subst x s t))
  | TmHead (ty,t) ->  (* Apartado 2.8 Se agrego el caso para el constructor TmHead *)
    TmHead (ty, (subst x s t))
  | TmTail (ty,t) -> 
    TmTail (ty, (subst x s t))

    ;;


let rec isnumericval tm = match tm with
    TmZero -> true
  | TmSucc t -> isnumericval t
  | _ -> false
;;

let rec isval tm = match tm with
  | TmTrue -> true
  | TmFalse -> true
  | TmAbs _ -> true
  | TmString _ -> true  (* Apartado 2.3 Se agregó el caso para el constructor TmString *)
  | TmTuple l -> List.for_all isval l  (* Apartado 2.4 Se agregó el caso para el constructor TmTuple *)
  | TmRecord l -> List.for_all (fun (_, t) -> isval t) l  (* Apartado 2.5 Se agregó el caso para el constructor TmRecord *)
  | TmTag (_, t, _) -> isval t
  | TmCase (t, _) -> isval t
  | TmNil _ -> true
  | TmCons(_ty,h,t) -> (isval h) && (isval t)
  | t when isnumericval t -> true
  | _ -> false
;;

exception NoRuleApplies
;;

let rec eval1 ctx tm = match tm with
  (* E-IfTrue *)
  | TmIf (TmTrue, t2, _) -> t2

  (* E-IfFalse *)
  | TmIf (TmFalse, _, t3) -> t3

  (* E-If *)
  | TmIf (t1, t2, t3) ->
      let t1' = eval1 ctx t1 in
      TmIf (t1', t2, t3)

  (* E-Succ *)
  | TmSucc t1 ->
      let t1' = eval1 ctx t1 in
      TmSucc t1'

  (* E-PredZero *)
  | TmPred TmZero -> TmZero

  (* E-PredSucc *)
  | TmPred (TmSucc nv1) when isnumericval nv1 -> nv1

  (* E-Pred *)
  | TmPred t1 ->
      let t1' = eval1 ctx t1 in
      TmPred t1'

  (* E-IszeroZero *)
  | TmIsZero TmZero -> TmTrue

  (* E-IszeroSucc *)
  | TmIsZero (TmSucc nv1) when isnumericval nv1 -> TmFalse

  (* E-Iszero *)
  | TmIsZero t1 ->
      let t1' = eval1 ctx t1 in
      TmIsZero t1'

  (* E-AppAbs *)
  | TmApp (TmAbs(x, _, t12), v2) when isval v2 -> subst x v2 t12

  (* E-App2: evaluate argument before applying function *)
  | TmApp (v1, t2) when isval v1 ->
      let t2' = eval1 ctx t2 in
      TmApp (v1, t2')

  (* E-App1: evaluate function before argument *)
  | TmApp (t1, t2) ->
      let t1' = eval1 ctx t1 in
      TmApp (t1', t2)

  (* E-LetV *)
  | TmLetIn (x, v1, t2) when isval v1 -> subst x v1 t2

  (* E-Let *)
  | TmLetIn (x, t1, t2) ->
      let t1' = eval1 ctx t1 in
      TmLetIn (x, t1', t2)

  (* E-FIXBETA *)
  | TmFix (TmAbs (x, _, t2)) -> subst x tm t2

  (* E-Fix *)
  | TmFix t1 ->
      let t1' = eval1 ctx t1 in
      TmFix t1'

  (* E-Concat1 *)
  | TmConcat (TmString s1, TmString s2) -> TmString (s1 ^ s2)

  (* E-Concat2 *)
  | TmConcat (TmString s1, t2) ->
      let t2' = eval1 ctx t2 in
      TmConcat (TmString s1, t2')

  (* E-Concat3 *)
  | TmConcat (t1, t2) ->
      let t1' = eval1 ctx t1 in
      TmConcat (t1', t2)

  | TmVar s -> getvbinding ctx s

  (* E-TUPLE *)
  | TmTuple t1 ->
      let rec seq_eval = function
        [] -> raise NoRuleApplies
        | (tm::t) when isval tm -> tm :: (seq_eval t)
        | (tm::t) -> (eval1 ctx tm) :: t
      in TmTuple (seq_eval t1)

  (* E-RCD *)
  | TmRecord t1 ->
      let rec field_seq_eval = function
        [] -> raise NoRuleApplies
        | ((st, tm) :: t) when isval tm -> (st, tm) :: (field_seq_eval t)
        | ((st, tm) :: t) -> (st, eval1 ctx tm) :: t
      in TmRecord (field_seq_eval t1)

  (* E-PROJRCD *)
  | TmGetElem (TmRecord l as v, s) when isval v -> List.assoc s l

  (* E-PROJTUPLE*) 
  | TmGetElem (TmTuple l as v, s) when isval v -> List.nth l (int_of_string s - 1)

  (* E-GetElem engloba los E-Projs de tuplas y registros*)
  | TmGetElem (t, x) -> TmGetElem (eval1 ctx t, x)

  (* E-Variant *)
  | TmTag (s, t, ty) ->
    let t' = eval1 ctx t in
    TmTag (s, t', ty)

  (* E-CaseVariant *)
  | TmCase (TmTag (s, v, _), cases) when isval v ->
      (try
        let (_, id, t) = List.find (fun (tag, _, _) -> tag = s) cases in
        subst id v t
      with Not_found -> raise NoRuleApplies)

  (* E-Case *)
  | TmCase (t, cases) ->
      let t' = eval1 ctx t in
      TmCase (t', cases)

  (*  E-Cons2 *)
	| TmCons(ty,h,t) when isval h ->
		TmCons(ty,h,(eval1 ctx t))

	(* E-Cons1 *)
	| TmCons(ty,h,t) ->
		TmCons(ty,(eval1 ctx h),t)


  (* E-IsNilNil *)
	| TmIsNil(ty,TmNil(_)) ->
		TmTrue

	(* E-IsNilCons *)
	| TmIsNil(ty,TmCons (_,_,_) ) ->
		TmFalse

	(* E-IsNil *)
	| TmIsNil(ty,t) ->
		TmIsNil(ty,eval1 ctx t)

	(* E-HeadCons *)
	| TmHead(ty,TmCons(_,h,_))->
		h

	(* E-Head *)
	| TmHead(ty,t) ->
		TmHead(ty,eval1 ctx t)

	(* E-TailCons *)
	| TmTail(ty,TmCons(_,_,t)) ->
		t

	(* E-Tail *)
	| TmTail(ty,t) ->
		TmTail(ty,eval1 ctx t)

  | _ -> raise NoRuleApplies
  

;;

let apply_ctx ctx tm = 
  List.fold_left (fun t x -> subst x (getvbinding ctx x) t) tm (free_vars tm);; (*Se añade el contexto*)

let rec eval ctx tm =
  try
    let tm' = eval1 ctx tm in
    eval ctx tm'
  with
      NoRuleApplies -> apply_ctx ctx tm
;;

let execute ctx = function
    Eval tm ->
      let tyTm = typeof ctx tm in
      let tm' = eval ctx tm in
      pretty_printer "-" tyTm tm';
      ctx
  | Bind (s, tm) ->
      let tyTm = typeof ctx tm in
      let tm' = eval ctx tm in
      pretty_printer s tyTm tm';
      addvbinding ctx s tyTm tm'
  | TBind (s, ty) ->
      let bty = resolve_base_type ctx ty in
      pretty_printer_ty s bty;
      addtbinding ctx s bty
  | Quit ->
      raise End_of_file