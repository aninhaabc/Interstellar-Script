%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();
%}

/* Tokens */
%token MANIFEST WITH ADJUST BY DISTORT BEYOND FALLBACK LOOP_HORIZON BELOW END_DISTORT END_LOOP EMIT DISINTEGRATE
%token PAST NOW FUTURE
%token LBRACE RBRACE
%token PLUS MINUS TIMES DIVIDE
%token SEMICOLON
%token IDENTIFIER NUMBER STRING

/* Tipos de valor */
%union {
    int num;
    char* id;
    char* str;
}

/* Associa tipos aos tokens */
%type <num> NUMBER
%type <id> IDENTIFIER
%type <str> STRING

/* Precedência */
%left PLUS MINUS
%left TIMES DIVIDE

%%

program:
      /* vazio */
    | program statement
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
    ;

adjust_statement:
    ADJUST IDENTIFIER BY expression SEMICOLON
    ;

distort_statement:
    DISTORT expression BEYOND expression block END_DISTORT SEMICOLON
    ;

fallback_statement:
    FALLBACK block SEMICOLON
    ;

loop_horizon_statement:
    LOOP_HORIZON IDENTIFIER BELOW expression block END_LOOP SEMICOLON
    ;

emit_statement:
    EMIT STRING SEMICOLON
    ;

disintegrate_statement:
    DISINTEGRATE IDENTIFIER SEMICOLON
    ;

temporal_block:
    PAST block
    | NOW block
    | FUTURE block
    ;

block:
    LBRACE RBRACE
  | LBRACE statement_list RBRACE
  ;

statement_list:
    statement
    | statement_list statement
    ;

expression:
    term
    | expression PLUS term
    | expression MINUS term
    | expression TIMES term
    | expression DIVIDE term
    ;

term:
    IDENTIFIER
    | NUMBER
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro de sintaxe: %s\n", s);
}

int main() {
    return yyparse();
}
