%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *saida;
void yyerror(const char *s);
int yylex();
%}

%union {
    int num;
    char* id;
    char* str;
}

%token MANIFEST WITH ADJUST BY DISTORT BEYOND FALLBACK LOOP_HORIZON BELOW END_DISTORT END_LOOP EMIT DISINTEGRATE
%token PAST NOW FUTURE
%token LBRACE RBRACE
%token PLUS MINUS TIMES DIVIDE
%token SEMICOLON
%token <id> IDENTIFIER
%token <num> NUMBER
%token <str> STRING

%type <num> expression term

%left PLUS MINUS
%left TIMES DIVIDE

%%

program:
    {
        saida = fopen("MurphyVM.java", "w");
        fprintf(saida, "public class MurphyVM {\n  public static void main(String[] args) {\n");
    }
    statement_list
    {
        fprintf(saida, "  }\n}\n");
        fclose(saida);
    }
;

statement_list:
    statement
    | statement_list statement
;

statement:
      manifest_statement
    | adjust_statement
    | distort_statement
    | fallback_statement
    | loop_horizon_statement
    | emit_statement
    | disintegrate_statement
    | temporal_block
;

manifest_statement:
    MANIFEST IDENTIFIER WITH expression SEMICOLON
    {
        fprintf(saida, "int %s = %d;\n", $2, $4); 
    }
;

adjust_statement:
    ADJUST IDENTIFIER BY expression SEMICOLON
    {
        fprintf(saida, "%s += %d;\n", $2, $4);
    }
;

distort_statement:
    DISTORT expression BEYOND expression
    {
        fprintf(saida, "if (%d > %d) {\n", $2, $4);
    }
    block END_DISTORT SEMICOLON
;

fallback_statement:
    FALLBACK block SEMICOLON
    {
        fprintf(saida, "else {\n");
    }
;

loop_horizon_statement:
    LOOP_HORIZON IDENTIFIER BELOW expression
    {
        fprintf(saida, "for (int %s = 0; %s < %d; %s++)", $2, $2, $4, $2);
    }
    block END_LOOP SEMICOLON
;


emit_statement:
    EMIT STRING SEMICOLON
    {
        fprintf(saida, "System.out.println(\"%s\");\n", $2);
    }
;

disintegrate_statement:
    DISINTEGRATE IDENTIFIER SEMICOLON
    {
        fprintf(saida, "// %s removido (não aplicável em Java)\n", $2);
    }
;

temporal_block:
    PAST block
    {
        fprintf(saida, "// bloco passado\n");
    }
  | NOW block
    {
        fprintf(saida, "// bloco presente\n");
    }
  | FUTURE block
    {
        fprintf(saida, "// bloco futuro\n");
    }
;

block:
    LBRACE
    {
        fprintf(saida, "{\n");
    }
    statement_list
    RBRACE
    {
        fprintf(saida, "}\n");
    }
  | LBRACE RBRACE
    {
        fprintf(saida, "{ }\n");
    }
;

expression:
    term
    | expression PLUS term     { $$ = $1 + $3; }
    | expression MINUS term    { $$ = $1 - $3; }
    | expression TIMES term    { $$ = $1 * $3; }
    | expression DIVIDE term   { $$ = $1 / $3; }
;

term:
    IDENTIFIER { $$ = 0; }
    | NUMBER    { $$ = $1; }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro de sintaxe: %s\n", s);
}

int main() {
    return yyparse();
}