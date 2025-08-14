
%{
  open Lambda;;
  open Format;;
%}

%token LAMBDA
%token TRUE
%token FALSE
%token IF
%token THEN
%token ELSE
%token SUCC
%token PRED
%token ISZERO
%token LET
%token IN
%token BOOL
%token NAT

%token LETREC
%token STRING
%token QUIT
%token CONCAT

%token COMMA
%token LKEY
%token RKEY


%token CASE
%token AS
%token OF
%token LT
%token GT
%token DARROW
%token VBAR


%token NIL
%token CONS
%token ISNIL
%token HEAD
%token TAIL
%token LIST
%token LBRACKET
%token RBRACKET

%token LPAREN
%token RPAREN
%token DOT
%token EQ
%token COLON
%token ARROW
%token EOF
%token FIX


%token <int> INTV
%token <string> IDV
%token <string> STRINGV
%token <string> IDT

%start s
%type <Lambda.command> s

%%

s :
    IDV EQ term EOF
      { Bind ($1, $3) }
    | IDT EQ ty EOF           
      { TBind ($1, $3) }  
    | term EOF
        { Eval $1 }
    | QUIT EOF
        { Quit }

term :
    appTerm
      { $1 }
  | IF term THEN term ELSE term
      { TmIf ($2, $4, $6) }
  | LAMBDA IDV COLON ty DOT term
      { TmAbs ($2, $4, $6) }
  | LET IDV EQ term IN term
      { TmLetIn ($2, $4, $6) }
  | LETREC IDV COLON ty EQ term IN term 
      { TmLetIn ($2, TmFix (TmAbs ($2, $4, $6)), $8) }
  | LT IDV EQ term GT AS ty
      { TmTag ($2, $4, $7) }
  | CASE term OF cases
      { TmCase ($2, $4) } 


cases:
    case
      { [$1] }
  | case VBAR cases
      { $1 :: $3 }
case:
    LT IDV EQ IDV GT DARROW appTerm
      { ($2, $4, $7) }

appTerm :
    pathTerm
      { $1 }
  | SUCC pathTerm
      { TmSucc $2 }
  | PRED pathTerm
      { TmPred $2 }
  | ISZERO pathTerm
      { TmIsZero $2 }
  | CONCAT pathTerm pathTerm
      { TmConcat ($2, $3) }
  | CONS LBRACKET ty RBRACKET pathTerm pathTerm
		{ TmCons ($3, $5, $6) }
  | ISNIL LBRACKET ty RBRACKET pathTerm 
		{ TmIsNil ($3, $5) }
  | HEAD LBRACKET ty RBRACKET pathTerm 
		{ TmHead ($3, $5) }
  | TAIL LBRACKET ty RBRACKET pathTerm 
		{ TmTail ($3, $5) }
  | FIX pathTerm
        { TmFix $2 }
  | appTerm pathTerm
      { TmApp ($1, $2) }


pathTerm :
	pathTerm DOT INTV
		{ TmGetElem ($1, (string_of_int $3))}
	| pathTerm DOT IDV
		{ TmGetElem ($1, $3)}
	| atomicTerm
		{ $1 }    
  

atomicTerm :
    LPAREN term RPAREN
      { $2 }
  | TRUE
      { TmTrue }
  | FALSE
      { TmFalse }
  | IDV
      { TmVar $1 }
  | INTV
      { let rec f = function
            0 -> TmZero
          | n -> TmSucc (f (n-1))
        in f $1 }
  | IDT                    
     { TmVar $1 } 
  | STRINGV
        { TmString $1 }
  | LKEY TmSequenceTuple RKEY
        { TmTuple $2 }
  | LKEY  tmSequenceRecord RKEY 
        { TmRecord $2 }
  | NIL LBRACKET ty RBRACKET 
		{ TmNil $3 }


ty :
    atomicTy
      { $1 }
  | atomicTy ARROW ty
      { TyArr ($1, $3) }


atomicTy :
    LPAREN ty RPAREN
      { $2 }
  | BOOL
      { TyBool }
  | NAT
      { TyNat }
  | STRING
      { TyString }
  | IDT
      { TyVar $1 }
  | LKEY TySequenceTuple RKEY
      { TyTuple $2 }
  | LKEY  tySequenceRecord RKEY 
        { TyRecord $2 }
  | LT tySequenceVariant GT
        { TyVariant $2 }
  | LIST LBRACKET ty RBRACKET
		{ TyList $3 }



TmSequenceTuple:
    term COMMA TmSequenceTuple
        {$1::$3}
    | term
        {[$1]}

TySequenceTuple:
    ty COMMA TySequenceTuple
        {$1::$3}
    | ty
        {[$1]}

tmSequenceRecord:
	{ [] }
	| tmNotEmptyRecord
		{ $1 }

tmNotEmptyRecord:
	IDV EQ term
		{[$1, $3]}
	| IDV EQ term COMMA tmNotEmptyRecord
		{($1, $3)::$5}

tySequenceRecord:
	{ [] }
	| tyNotEmptyRecord_ty
		{ $1 }

tyNotEmptyRecord_ty:
	IDV COLON ty
		{[$1, $3]}
	| IDV COLON ty COMMA tyNotEmptyRecord_ty
		{($1, $3)::$5}

tySequenceVariant:
    notEmptyRecordFieldType
    { [$1] }
    | notEmptyRecordFieldType COMMA tySequenceVariant
        { $1 :: $3 }

notEmptyRecordFieldType:
    IDV COLON ty
        { ($1, $3) }