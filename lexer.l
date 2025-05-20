%{
#include "parser.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%

"manifest"              { return MANIFEST; }
"with"                  { return WITH; }
"adjust"                { return ADJUST; }
"by"                    { return BY; }
"distort"               { return DISTORT; }
"beyond"                { return BEYOND; }
"fallback"              { return FALLBACK; }
"loop_horizon"          { return LOOP_HORIZON; }
"below"                 { return BELOW; }
"end_distort"           { return END_DISTORT; }
"end_loop"              { return END_LOOP; }
"emit"                  { return EMIT; }
"disintegrate"          { return DISINTEGRATE; }
"past"                  { return PAST; }
"now"                   { return NOW; }
"future"                { return FUTURE; }

"{"                     { return LBRACE; }
"}"                     { return RBRACE; }
"+"                     { return PLUS; }
"-"                     { return MINUS; }
"*"                     { return TIMES; }
"/"                     { return DIVIDE; }
";"                     { return SEMICOLON; }

[0-9]+                  { yylval.num = atoi(yytext); return NUMBER; }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.id = strdup(yytext); return IDENTIFIER; }

\"[^\"]*\" {
    int len = strlen(yytext);
    char *str = malloc(len - 1);
    if (!str) exit(1);
    strncpy(str, yytext + 1, len - 2);
    str[len - 2] = '\0';
    yylval.str = str;
    return STRING;
}

[ \t\r\n]+              ;

.                       { printf("Caractere desconhecido: '%s' (ASCII: %d)\n", yytext, yytext[0]); }

%%

int yywrap() { return 1; }
