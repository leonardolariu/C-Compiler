#!/bin/bash
lex calc.l
yacc calc.y -d
gcc lex.yy.c y.tab.c -ll -ly
