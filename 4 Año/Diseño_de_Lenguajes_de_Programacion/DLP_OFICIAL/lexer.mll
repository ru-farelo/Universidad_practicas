
{
  open Parser;;
  exception Lexical_error;;
}

rule token = parse
    [' ' '\t']  { token lexbuf }
  | "lambda"    { LAMBDA }
  | "L"         { LAMBDA }
  | "true"      { TRUE }
  | "false"     { FALSE }
  | "if"        { IF }
  | "then"      { THEN }
  | "else"      { ELSE }
  | "succ"      { SUCC }
  | "pred"      { PRED }
  | "iszero"    { ISZERO }
  | "let"       { LET }
  | "letrec"    { LETREC }
  | "in"        { IN }
  | "fix"       { FIX }
  | "concat"    { CONCAT }
  | "Bool"      { BOOL }
  | "Nat"       { NAT }
  | "String"    { STRING }
  | "quit"      { QUIT }
  | "case"      { CASE }
  | "as"        { AS }
  | "of"        { OF }
  | "nil"       { NIL }
  | "cons"      { CONS }
  | "isnil"     { ISNIL }
  | "head"      { HEAD }
  | "tail"      { TAIL }
  | "List"      { LIST }
  | "["         { LBRACKET }
  | "]"         { RBRACKET }
  | "<"         { LT }
  | ">"         { GT }
  | "=>"        { DARROW }
  | "|"         { VBAR }
  | '('         { LPAREN }
  | ')'         { RPAREN }
  | '{'         { LKEY }
  | '}'         { RKEY }
  | ','         { COMMA }
  | '.'         { DOT }
  | '='         { EQ }
  | ':'         { COLON }
  | "->"        { ARROW }
  | ['0'-'9']+  { INTV (int_of_string (Lexing.lexeme lexbuf)) }
  | ['a'-'z']['a'-'z' '_' '0'-'9']*
                { IDV (Lexing.lexeme lexbuf) }
  | '"' [^ '"' ';' '\n']*'"' { let s = Lexing.lexeme lexbuf in
                              STRINGV (String.sub s 1 (String.length s - 2)) }
  | ['A'-'Z']['A'-'Z' 'a'-'z' '_' '0'-'9']* { IDT (Lexing.lexeme lexbuf) }
  | eof         { EOF }
  | _           { raise Lexical_error }
