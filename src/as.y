%{
    #include <stdio.h>
    #include <ctype.h>
    int yylex();
    void yyerror(char *s);
    extern int pos_line;
    extern int pos_char;
    int parse = 0;
    int result;
%}

%union{
    char line[200];   
}



%token STRUCT
%token CHARACTER
%token NUM
%token IDENT
%token TYPE
%token EQ
%token ORDER
%token ADDSUB
%token DIVSTAR
%token OR
%token AND
%token READC
%token READE
%token PRINT
%token WHILE
%token IF
%nonassoc "then"
%nonassoc ELSE
%token RETURN
%token VOID


%%
Prog: Decls DeclFoncts ; 


Decls: Decls TYPE Declarateurs ';' 
            |  Decls DeclStruct 
            |  ;
CorpsStruct: '{' DeclVars '}' ';' ;
            
DeclStruct: STRUCT IDENT CorpsStruct
            | STRUCT IDENT Declarateurs ';' ;
            
DeclVars: DeclVars TYPE Declarateurs ';'
            | ;
Declarateurs: Declarateurs ',' IDENT
            | IDENT ;
DeclFoncts: DeclFoncts DeclFonct
            | DeclFonct  
            |  error                       { yyclearin;} ;
DeclFonct: EnTeteFonct Corps ;
EnTeteFonct: TYPE IDENT '(' Parametres ')'
            | VOID IDENT '(' Parametres ')' 
            |  error                       { yyclearin;} ;
Parametres: VOID
            | ListTypVar  ;
ListTypVar: ListTypVar ',' TYPE IDENT
            |TYPE IDENT 
            |  error                       { yyclearin;} ;
Corps: '{' DeclVars SuiteInstr '}' ;
SuiteInstr: SuiteInstr Instr
            | ;
Instr: LValue '=' Exp ';'
            | READE '(' IDENT ')' ';'
            | READC '(' IDENT ')' ';'
            | PRINT '(' Exp ')' ';'
            | IF '(' Exp ')' Instr                  %prec "then"
            | IF '(' Exp ')' Instr ELSE Instr
            | WHILE '(' Exp ')' Instr
            | IDENT '(' Arguments ')' ';'
            | RETURN Exp';'
            | RETURN ';'
            | '{' SuiteInstr '}'
            | ';' 
            |  error                       { yyclearin;} ;
Exp: Exp OR TB
            | TB  
            |  error                       { yyclearin;} ;
TB: TB AND FB
            | FB  ;
FB: FB EQ M
            | M  ;
M: M ORDER E 
            | E  ;
E: E ADDSUB T
            | T   ;
T: T DIVSTAR F
            | F   ;
F: ADDSUB F
            | '!' F
            | '(' Exp ')' 
            | NUM
            | CHARACTER
            | LValue
            | IDENT '(' Arguments ')' ;
LValue: IDENT ;
Arguments: ListExp
            | ;
ListExp: ListExp ',' Exp 
            | Exp ;
%%


int main(int argc, char** argv) {
	result = yyparse();
    if(parse  > 0)
        printf("\033[1;31m%d error(s)\033[m\n", parse);
    return result || parse != 0;
}

void yyerror(char *s){
    fprintf(stderr, "%s", yylval.line);

    for(int i=0; i< (pos_char - 1); i++)
        fprintf(stderr, " ");
    fprintf(stderr, "^\n");
    fprintf(stderr, "\033[1;31m%s \033[m:  near line \033[1;31m%d\033[m in caracter \033[1;31m%d \033[m\n\n", s , pos_line, pos_char);
    parse += 1;
}