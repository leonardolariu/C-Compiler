%{
#include <stdio.h>
#include "y.tab.h"
%}
%x comment commentBlock

%%
"begin" {return BEGIN_PROGRAM;}
"end" {return END_PROGRAM;}

"//" {BEGIN comment;}
<comment>[^\n] ;
<comment>\n {yylineno++; BEGIN 0;}

"/*" {BEGIN commentBlock;}
<commentBlock>\n {yylineno++;}
<commentBlock>"*/" {BEGIN 0;}
<commentBlock>. ;

"int" {return INT;}
"const int" {return CONST_INT;}

"float" {return FLOAT;}
"const float" {return CONST_FLOAT;}

"string" {return STRING;}
"bool" {return BOOL;}
"print" {return PRINT;}

[a-zA-Z][a-zA-Z0-9]* {yylval.stringVal = strdup(yytext); return ID;}
[0]|[-]?[1-9][0-9]* {yylval.intVal = atoi(yytext); return INT_VAL;}
"0"[.][0-9]+|[-]?[1-9][0-9]*[.][0-9]+ {yylval.floatVal = atof(yytext); return FLOAT_VAL;}
\"[^"]*\" {yylval.stringVal = strndup(yytext+1, yyleng-2); return STRING_VAL;}

"||" {return OR;}
"&&" {return AND;}

"<" {return LESS;}
"<=" {return LESS_EQL;}
">" {return GRT;}
">=" {return GRT_EQL;}
"==" {return EQL;}

[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
