(* AST pretty printer *)

open Ast

let print_vec (v: vec) : string = 
    "["^(String.concat ", " (List.map string_of_float v))^"]"

let rec print_mat_helper (m: mat) : string = 
    match m with
    | [] -> ""
    | h::t -> (print_vec h)^", "^(print_mat_helper t)

let print_mat (m: mat) : string = 
    "["^(print_mat_helper m)^"]"

let rec print_ltyp (lt: ltyp) : string =
    match lt with
    | VecTyp n -> "vec"^(string_of_int n)
    | MatTyp (n1, n2) -> "mat"^(string_of_int n1)^"*"^(string_of_int n2)
    | TagTyp s -> s
    | TransTyp (lt1, lt2) -> (print_ltyp lt1)^"->"^(print_ltyp lt2)

let rec print_atyp (at: atyp) : string = 
    match at with
    | IntTyp -> "int"
    | FloatTyp -> "float"
    | LTyp lt -> print_ltyp lt

let rec print_btyp (bt: btyp) : string = "bool"

let rec print_typ (t: typ) : string = 
    match t with
    | ATyp at -> print_atyp at 
    | BTyp bt -> print_btyp bt

let rec print_aval (av: avalue) : string = 
    match av with 
    | Num n -> string_of_int n
    | Float f -> string_of_float f
    | VecLit v -> print_vec v
    | MatLit m -> print_mat m
  
let rec print_aexp (a: aexp) : string = 
    match a with
    | Const av -> print_aval av
    | Var v -> v
    | LExp (a',l) -> (print_aexp a')^":"^(print_ltyp l)
    | Dot (a1, a2) -> "dot "^(print_aexp a1)^" "^(print_aexp a2)
    | Norm a -> "norm "^(print_aexp a)
    | Plus (a1, a2) -> (print_aexp a1)^" + "^(print_aexp a2)
    | Times (a1, a2) -> (print_aexp a1)^" * "^(print_aexp a2)
    | Minus (a1, a2) -> (print_aexp a1)^" - "^(print_aexp a2)
    | CTimes (a1, a2) -> (print_aexp a1)^" .* "^(print_aexp a2)

let rec print_bexp (b: bexp) : string = 
    match b with 
    | True -> "true"
    | False -> "false"
    | Eq (a1, a2) -> (print_aexp a1)^" == "^(print_aexp a2)
    | Leq (a1, a2) -> (print_aexp a1)^" <= "^(print_aexp a2)
    | Or (b1, b2) -> (print_bexp b1)^" || "^(print_bexp b2)
    | And (b1, b2) -> (print_bexp b1)^" && "^(print_bexp b2)
    | Not b' -> "!"^(print_bexp b')

let rec print_exp (e: exp) : string = 
    match e with
    | Aexp a -> print_aexp a
    | Bexp b -> print_bexp b

let rec print_comm (c: comm) : string =
    match c with
    | Skip -> "skip"
    | Print e -> "print " ^ (print_exp e)
    | Decl (t, s, e) -> (print_typ t)^" "^s^" = "^(print_exp e)
    | Seq (c1, c2) -> (print_comm c1)^";\n"^(print_comm c2)
    | If (b, c1, c2) -> "if ("^(print_bexp b)^") then \n"^(print_comm c1)^
        "\nelse\n"^(print_comm c2)

let rec print_tags (t : tagdecl list) : string =
    match t with 
    | [] -> ""
    | TagDecl(s, a)::t -> "tag "^s^"is"^(print_atyp a)^";\n"^(print_tags t)

let print_prog (e : prog) : string =
    match e with
    | Prog (t, c) -> (print_tags t) ^ (print_comm c) 
