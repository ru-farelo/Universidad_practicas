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
  | TmNil of ty
	| TmCons of ty * term * term
	| TmIsNil of ty * term
	| TmHead of ty * term
	| TmTail of ty * term
;;

type command =
    Eval of term
  | Bind of string * term
  | TBind of string * ty (* Nuevo caso para alias de tipo *)
  | Quit
;;

type binding =
    TyBind of ty
  | TyTmBind of (ty * term)
;;

type context =
  (string * binding) list
;;

val emptyctx : context;;
val addtbinding : context -> string -> ty -> context;;
val addvbinding : context -> string -> ty -> term -> context;;
val gettbinding : context -> string -> ty;;
val getvbinding : context -> string -> term;;

val string_of_ty : ty -> unit;;
exception Type_error of string;;
val typeof : context -> term -> ty;;

val string_of_term : term -> unit;;
exception NoRuleApplies;;
val eval : context -> term -> term;;


val execute : context -> command -> context;;

