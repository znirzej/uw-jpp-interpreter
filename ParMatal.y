-- This Happy file was machine-generated by the BNF converter
{
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module ParMatal where
import AbsMatal
import LexMatal
import ErrM

}

%name pProgram Program
-- no lexer declaration
%monad { Err } { thenM } { returnM }
%tokentype {Token}
%token
  '!=' { PT _ (TS _ 1) }
  '(' { PT _ (TS _ 2) }
  ')' { PT _ (TS _ 3) }
  '*' { PT _ (TS _ 4) }
  '*=' { PT _ (TS _ 5) }
  '+' { PT _ (TS _ 6) }
  '++' { PT _ (TS _ 7) }
  '+=' { PT _ (TS _ 8) }
  ',' { PT _ (TS _ 9) }
  '-' { PT _ (TS _ 10) }
  '--' { PT _ (TS _ 11) }
  '-=' { PT _ (TS _ 12) }
  '.' { PT _ (TS _ 13) }
  '/' { PT _ (TS _ 14) }
  '/=' { PT _ (TS _ 15) }
  ';' { PT _ (TS _ 16) }
  '<' { PT _ (TS _ 17) }
  '<<' { PT _ (TS _ 18) }
  '<=' { PT _ (TS _ 19) }
  '=' { PT _ (TS _ 20) }
  '==' { PT _ (TS _ 21) }
  '>' { PT _ (TS _ 22) }
  '>=' { PT _ (TS _ 23) }
  '>>' { PT _ (TS _ 24) }
  '[' { PT _ (TS _ 25) }
  '[]' { PT _ (TS _ 26) }
  ']' { PT _ (TS _ 27) }
  'bool' { PT _ (TS _ 28) }
  'else' { PT _ (TS _ 29) }
  'false' { PT _ (TS _ 30) }
  'for' { PT _ (TS _ 31) }
  'function' { PT _ (TS _ 32) }
  'if' { PT _ (TS _ 33) }
  'init' { PT _ (TS _ 34) }
  'int' { PT _ (TS _ 35) }
  'print' { PT _ (TS _ 36) }
  'return' { PT _ (TS _ 37) }
  'struct' { PT _ (TS _ 38) }
  'true' { PT _ (TS _ 39) }
  'void' { PT _ (TS _ 40) }
  'while' { PT _ (TS _ 41) }
  '{' { PT _ (TS _ 42) }
  '}' { PT _ (TS _ 43) }

L_ident  { PT _ (TV $$) }
L_integ  { PT _ (TI $$) }


%%

Ident   :: { Ident }   : L_ident  { Ident $1 }
Integer :: { Integer } : L_integ  { (read ( $1)) :: Integer }

Program :: { Program }
Program : ListExternalDeclaration { AbsMatal.Progr $1 }
ListExternalDeclaration :: { [ExternalDeclaration] }
ListExternalDeclaration : ExternalDeclaration { (:[]) $1 }
                        | ExternalDeclaration ListExternalDeclaration { (:) $1 $2 }
ExternalDeclaration :: { ExternalDeclaration }
ExternalDeclaration : FunctionDef { AbsMatal.Afunc $1 }
                    | Dec { AbsMatal.Global $1 }
                    | StructSpec { AbsMatal.StructDec $1 }
Declarator :: { Declarator }
Declarator : TypeSpecifier Ident { AbsMatal.DVariable $1 $2 }
Dec :: { Dec }
Dec : Declarator ';' { AbsMatal.Declaration $1 }
ListDec :: { [Dec] }
ListDec : {- empty -} { [] } | ListDec Dec { flip (:) $1 $2 }
TypeSpecifier :: { TypeSpecifier }
TypeSpecifier : 'void' { AbsMatal.TVoid }
              | 'int' { AbsMatal.TInt }
              | 'bool' { AbsMatal.TBool }
              | 'struct' Ident { AbsMatal.TStruct $2 }
              | TypeSpecifier '[]' { AbsMatal.TArray $1 }
              | TypeSpecifier '<<' TypeSpecifier '>>' { AbsMatal.TMap $1 $3 }
StructSpec :: { StructSpec }
StructSpec : 'struct' Ident '{' ListDec '}' { AbsMatal.Struct $2 (reverse $4) }
FunctionDef :: { FunctionDef }
FunctionDef : 'function' Declarator '(' ListDeclarator ')' FunctionBody { AbsMatal.FuncParams $2 $4 $6 }
ListDeclarator :: { [Declarator] }
ListDeclarator : {- empty -} { [] }
               | Declarator { (:[]) $1 }
               | Declarator ',' ListDeclarator { (:) $1 $3 }
ListFunctionDef :: { [FunctionDef] }
ListFunctionDef : {- empty -} { [] }
                | ListFunctionDef FunctionDef { flip (:) $1 $2 }
FunctionBody :: { FunctionBody }
FunctionBody : '{' ListDec ListFunctionDef ListStmt 'return' ExpressionStmt '}' { AbsMatal.FuncBodyOne (reverse $2) (reverse $3) (reverse $4) $6 }
Stmt :: { Stmt }
Stmt : CompoundStmt { AbsMatal.SComp $1 }
     | ExpressionStmt { AbsMatal.SExpr $1 }
     | SelectionStmt { AbsMatal.SSel $1 }
     | IterStmt { AbsMatal.SIter $1 }
     | PrintStmt { AbsMatal.SPrint $1 }
     | InitStmt { AbsMatal.SInit $1 }
CompoundStmt :: { CompoundStmt }
CompoundStmt : '{' ListDec ListStmt '}' { AbsMatal.SCompOne (reverse $2) (reverse $3) }
ExpressionStmt :: { ExpressionStmt }
ExpressionStmt : ';' { AbsMatal.SExprOne }
               | Exp ';' { AbsMatal.SExprTwo $1 }
SelectionStmt :: { SelectionStmt }
SelectionStmt : 'if' '(' Exp ')' CompoundStmt { AbsMatal.SSelOne $3 $5 }
              | 'if' '(' Exp ')' CompoundStmt 'else' CompoundStmt { AbsMatal.SSelTwo $3 $5 $7 }
IterStmt :: { IterStmt }
IterStmt : 'while' '(' Exp ')' Stmt { AbsMatal.SIterOne $3 $5 }
         | 'for' '(' ExpressionStmt ExpressionStmt ')' Stmt { AbsMatal.SIterTwo $3 $4 $6 }
         | 'for' '(' ExpressionStmt ExpressionStmt Exp ')' Stmt { AbsMatal.SIterThree $3 $4 $5 $7 }
PrintStmt :: { PrintStmt }
PrintStmt : 'print' Exp ';' { AbsMatal.SPrintOne $2 }
InitStmt :: { InitStmt }
InitStmt : 'init' Ident '[' Exp ']' ';' { AbsMatal.SInitOne $2 $4 }
ListStmt :: { [Stmt] }
ListStmt : {- empty -} { [] } | ListStmt Stmt { flip (:) $1 $2 }
Exp :: { Exp }
Exp : Exp ',' Exp1 { AbsMatal.EComma $1 $3 } | Exp1 { $1 }
Exp1 :: { Exp }
Exp1 : Exp4 AssignmentOp Exp1 { AbsMatal.EAssign $1 $2 $3 }
     | Exp2 { $1 }
Exp2 :: { Exp }
Exp2 : Exp2 '==' Exp3 { AbsMatal.EEq $1 $3 }
     | Exp2 '!=' Exp3 { AbsMatal.ENeq $1 $3 }
     | Exp3 { $1 }
Exp3 :: { Exp }
Exp3 : Exp3 '<' Exp4 { AbsMatal.ELthen $1 $3 }
     | Exp3 '>' Exp4 { AbsMatal.EGrthen $1 $3 }
     | Exp3 '<=' Exp4 { AbsMatal.ELe $1 $3 }
     | Exp3 '>=' Exp4 { AbsMatal.EGe $1 $3 }
     | Exp4 { $1 }
Exp4 :: { Exp }
Exp4 : Exp4 '+' Exp5 { AbsMatal.EPlus $1 $3 }
     | Exp4 '-' Exp5 { AbsMatal.EMinus $1 $3 }
     | Exp5 { $1 }
Exp5 :: { Exp }
Exp5 : Exp5 '*' Exp6 { AbsMatal.ETimes $1 $3 }
     | Exp5 '/' Exp6 { AbsMatal.EDiv $1 $3 }
     | Exp6 { $1 }
Exp6 :: { Exp }
Exp6 : '-' Exp6 { AbsMatal.ENegative $2 } | Exp7 { $1 }
Exp7 :: { Exp }
Exp7 : Exp7 '.' Ident { AbsMatal.ESelect $1 $3 }
     | Exp7 '[' Exp ']' { AbsMatal.EArray $1 $3 }
     | Exp7 '(' ')' { AbsMatal.EFunk $1 }
     | Exp7 '(' ListExp1 ')' { AbsMatal.EFunkPar $1 $3 }
     | Exp7 '<<' Exp '>>' { AbsMatal.EMap $1 $3 }
     | Exp8 { $1 }
Exp8 :: { Exp }
Exp8 : Exp8 '++' { AbsMatal.EPostInc $1 }
     | Exp8 '--' { AbsMatal.EPostDec $1 }
     | Exp9 { $1 }
Exp9 :: { Exp }
Exp9 : Ident { AbsMatal.EVar $1 }
     | Constant { AbsMatal.EConst $1 }
     | '(' Exp ')' { $2 }
Constant :: { Constant }
Constant : Integer { AbsMatal.EInt $1 }
         | 'true' { AbsMatal.ETrue }
         | 'false' { AbsMatal.EFalse }
ListExp1 :: { [Exp] }
ListExp1 : Exp1 { (:[]) $1 } | Exp1 ',' ListExp1 { (:) $1 $3 }
AssignmentOp :: { AssignmentOp }
AssignmentOp : '=' { AbsMatal.Assign }
             | '*=' { AbsMatal.AssignMul }
             | '/=' { AbsMatal.AssignDiv }
             | '+=' { AbsMatal.AssignAdd }
             | '-=' { AbsMatal.AssignSub }
{

returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    _ -> " before " ++ unwords (map (id . prToken) (take 4 ts))

myLexer = tokens
}

