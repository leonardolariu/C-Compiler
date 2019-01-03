%{
#include "utilities.h"
%}

%code requires {
	typedef struct expressionInfo {
	    char *type;

	    int intVal;
	    float floatVal;
	    char *stringVal;
	} expressionInfo;
}

%union {
int intVal;
float floatVal;
char *stringVal;

struct expressionInfo info;
int boolInfo;
}

%token<intVal> INT_VAL
%token<floatVal> FLOAT_VAL
%token<stringVal> STRING_VAL ID
%token BEGIN_PROGRAM END_PROGRAM BOOL INT CONST_INT FLOAT CONST_FLOAT STRING PRINT END_INSTRUCTION

%type<info> rightSide expression termen operand
%type<boolInfo> boolExpression boolTermen boolOperand

%left OR
%left AND
%right LESS LESS_EQL GRT GRT_EQL EQL
%right '='
%left '+' '-'
%left '*' '/'

%start s

%%
s :	BEGIN_PROGRAM instructions END_PROGRAM
  ;

instructions : 	instructions declaration
		   	 | 	instructions assignment
			 | 	instructions print
			 | 	declaration
			 | 	assignment
			 | 	print
			 ;



declaration : 	INT intDeclarationList ';'
			| 	CONST_INT constIntDeclarationList ';'
			| 	FLOAT floatDeclarationList ';'
			| 	CONST_FLOAT constFloatDeclarationList ';'
			|	STRING stringDeclarationList ';'
			| 	error ';'
			;

intDeclarationList :	intDeclarationList ',' ID '=' rightSide {
							checkId($3); //look for ID in variable list

							if (strcmp($5.type, "int") != 0)
								printf("semantic error, line %d: assignment between 2 different types\n\n", yylineno);
							else {
								if (currVar == NULL) addInt($3, "int", $5.intVal, true);
								else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $3);
							}
						}
				   | 	intDeclarationList ',' ID {
							checkId($3);

							if (currVar == NULL) addInt($3, "int", 0, false);
							else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $3);
						}
				   | 	ID '=' rightSide {
							checkId($1); //look for ID in variable list

							if (strcmp($3.type, "int") != 0)
								printf("semantic error, line %d: assignment between 2 different types\n\n", yylineno);
							else {
								if (currVar == NULL) addInt($1, "int", $3.intVal, true);
								else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $1);
							}
						}
				   | 	ID {
				   			checkId($1);

							if (currVar == NULL) addInt($1, "int", 0, false);
							else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $1);
				   		}
				   ;

constIntDeclarationList : 	constIntDeclarationList ',' ID '=' rightSide {
								checkId($3); //look for ID in variable list

								if (strcmp($5.type, "int") != 0)
									printf("semantic error, line %d: assignment between 2 different types\n\n", yylineno);
								else {
									if (currVar == NULL) addInt($3, "const int", $5.intVal, true);
									else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $3);
								}
							}
						| 	ID '=' rightSide {
								checkId($1); //look for ID in variable list

								if (strcmp($3.type, "int") != 0)
									printf("semantic error, line %d: assignment between 2 different types\n\n", yylineno);
								else {
									if (currVar == NULL) addInt($1, "const int", $3.intVal, true);
									else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $1);
								}
							}
						;

floatDeclarationList : 	floatDeclarationList ',' ID '=' rightSide {
							checkId($3); //look for ID in variable list

							if (strcmp($5.type, "float") != 0)
								printf("semantic error, line %d: assignment between 2 different types\n\n", yylineno);
							else {
								if (currVar == NULL) addFloat($3, "float", $5.floatVal, true);
								else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $3);
							}
						}
				     | 	floatDeclarationList ',' ID {
							checkId($3);

							if (currVar == NULL) addFloat($3, "float", 0, false);
							else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $3);
						}
				   	 | 	ID '=' rightSide {
							checkId($1); //look for ID in variable list

							if (strcmp($3.type, "float") != 0)
								printf("semantic error, line %d: assignment between 2 different types\n\n", yylineno);
							else {
								if (currVar == NULL) addFloat($1, "float", $3.floatVal, true);
								else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $1);
							}
						}
				   	 | 	ID {
				   			checkId($1);

							if (currVar == NULL) addFloat($1, "float", 0, false);
							else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $1);
				   		}
				   	 ;

constFloatDeclarationList : constFloatDeclarationList ',' ID '=' rightSide {
								checkId($3); //look for ID in variable list

								if (strcmp($5.type, "float") != 0)
									printf("semantic error, line %d: assignment between 2 different types\n\n", yylineno);
								else {
									if (currVar == NULL) addFloat($3, "const float", $5.floatVal, true);
									else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $3);
								}
							}
						  | ID '=' rightSide {
								checkId($1); //look for ID in variable list

								if (strcmp($3.type, "float") != 0)
									printf("semantic error, line %d: assignment between 2 different types\n\n", yylineno);
								else {
									if (currVar == NULL) addFloat($1, "const float", $3.floatVal, true);
									else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $1);
								}
							}
						  ;

stringDeclarationList :	stringDeclarationList ',' ID '=' rightSide {
							checkId($3); //look for ID in variable list

							if (strcmp($5.type, "string") != 0)
								printf("semantic error, line %d: assignment between 2 different types\n\n", yylineno);
							else {
								if (currVar == NULL) addString($3, "string", $5.stringVal, true);
								else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $3);
							}
						}
				      | stringDeclarationList ',' ID {
							checkId($3);

							if (currVar == NULL) addString($3, "string", NULL, false);
							else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $3);
						}
				   	  | ID '=' rightSide {
							checkId($1); //look for ID in variable list

							if (strcmp($3.type, "string") != 0)
								printf("semantic error, line %d: assignment between 2 different types\n\n", yylineno);
							else {
								if (currVar == NULL) addString($1, "string", $3.stringVal, true);
								else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $1);
							}
						}
				      | ID {
				   			checkId($1);

							if (currVar == NULL) addString($1, "string", NULL, false);
							else printf("semantic error, line %d: already declared variable '%s'\n\n", yylineno, $1);
				   		}
				      ;



assignment : 	ID '=' rightSide ';' {
					checkId($1); //look for ID in variable list

					if (currVar == NULL) //ID not found in variable list
						printf("semantic error, line %d: undeclared variable '%s'\n\n", yylineno, $1);
					else { //ID found in variable list
						if (strcmp(currVar->type, $3.type) != 0)
							printf("semantic error, line %d: assignment between 2 different types\n\n", yylineno);


						if (strcmp(currVar->type, "const int") == 0 || strcmp(currVar->type, "const float") == 0)
							printf("semantic error, line %d: attempt of changing a const value\n\n", yylineno);
						else if (strcmp(currVar->type, "int") == 0) { //change the value of ID
							currVar->intVal = $3.intVal;
							currVar->set = true;
						} else if (strcmp(currVar->type, "float") == 0) { //change the value of ID
							currVar->floatVal = $3.floatVal;
							currVar->set = true;
						} else if (strcmp(currVar->type, "string") == 0) { //change the value of ID
							currVar->stringVal = $3.stringVal;
							currVar->set = true;
						}
					}
			 	}
		   | 	error ';'
		   ;

rightSide : 	ID '=' rightSide {
					checkId($1); //look for ID in variable list

					if (currVar == NULL) //ID not found in variable list
						printf("semantic error, line %d: undeclared variable '%s'\n\n", yylineno, $1);
					else { //ID found in variable list
						if (strcmp(currVar->type, $3.type) != 0)
							printf("semantic error, line %d: assignment between 2 different types\n\n", yylineno);


						if (strcmp(currVar->type, "const int") == 0 || strcmp(currVar->type, "const float") == 0)
							printf("semantic error, line %d: attempt of changing a const value\n\n", yylineno);
						else if (strcmp(currVar->type, "int") == 0) { //change the value of ID
							$$.type = "int";
							$$.intVal = currVar->intVal = $3.intVal;
							currVar->set = true;
							currVar->used = true;
						} else if (strcmp(currVar->type, "float") == 0) { //change the value of ID
							$$.type = "float";
							$$.floatVal = currVar->floatVal = $3.floatVal;
							currVar->set = true;
							currVar->used = true;
						} else if (strcmp(currVar->type, "string") == 0) { //change the value of ID
							$$.type = "string";
							$$.stringVal = currVar->stringVal = $3.stringVal;
							currVar->set = true;
							currVar->used = true;
						}
					}
			 	}
		  | 	expression {
		  			if (strcmp($1.type, "int") == 0) { //int or const int
						$$.type = "int";
						$$.intVal = $1.intVal;
					} else if (strcmp($1.type, "float") == 0) { //float or const float
						$$.type = "float";
						$$.floatVal = $1.floatVal;
					} else if (strcmp($1.type, "string") == 0) { //string
						$$.type = "string";
						$$.stringVal = $1.stringVal;
					}
		  		}
		  ;



boolExpression :	boolExpression OR boolTermen {$$ = $1 || $3;}
			   |	boolTermen {$$ = $1;}
			   ;

boolTermen :	boolTermen AND boolOperand {$$ = $1 && $3;}
		   |	boolOperand {$$ = $1;}
		   ;

boolOperand :	expression LESS expression {
					if (strcmp($1.type, $3.type) != 0)
						printf("semantic error, line %d: comparison between 2 different types\n\n", yylineno);
					else {
						if (strcmp($1.type, "int") == 0) {
							if ($1.intVal < $3.intVal) $$ = 1;
							else $$ = 0;
						} else if (strcmp($1.type, "float") == 0) {
							if ($1.floatVal < $3.floatVal) $$ = 1;
							else $$ = 0;
						} else if (strcmp($1.type, "string") == 0) {
							if (strcmp($1.stringVal, $3.stringVal) < 0) $$ = 1;
							else $$ = 0;
						}
					}
				}
			|	expression LESS_EQL expression {
					if (strcmp($1.type, $3.type) != 0)
						printf("semantic error, line %d: comparison between 2 different types\n\n", yylineno);
					else {
						if (strcmp($1.type, "int") == 0) {
							if ($1.intVal <= $3.intVal) $$ = 1;
							else $$ = 0;
						} else if (strcmp($1.type, "float") == 0) {
							if ($1.floatVal <= $3.floatVal) $$ = 1;
							else $$ = 0;
						} else if (strcmp($1.type, "string") == 0) {
							if (strcmp($1.stringVal, $3.stringVal) <= 0) $$ = 1;
							else $$ = 0;
						}
					}
				}
			|	expression GRT expression {
					if (strcmp($1.type, $3.type) != 0)
						printf("semantic error, line %d: comparison between 2 different types\n\n", yylineno);
					else {
						if (strcmp($1.type, "int") == 0) {
							if ($1.intVal > $3.intVal) $$ = 1;
							else $$ = 0;
						} else if (strcmp($1.type, "float") == 0) {
							if ($1.floatVal > $3.floatVal) $$ = 1;
							else $$ = 0;
						} else if (strcmp($1.type, "string") == 0) {
							if (strcmp($1.stringVal, $3.stringVal) > 0) $$ = 1;
							else $$ = 0;
						}
					}
				}
			|	expression GRT_EQL expression {
					if (strcmp($1.type, $3.type) != 0)
						printf("semantic error, line %d: comparison between 2 different types\n\n", yylineno);
					else {
						if (strcmp($1.type, "int") == 0) {
							if ($1.intVal >= $3.intVal) $$ = 1;
							else $$ = 0;
						} else if (strcmp($1.type, "float") == 0) {
							if ($1.floatVal >= $3.floatVal) $$ = 1;
							else $$ = 0;
						} else if (strcmp($1.type, "string") == 0) {
							if (strcmp($1.stringVal, $3.stringVal) >= 0) $$ = 1;
							else $$ = 0;
						}
					}
				}
			|	expression EQL expression {
					if (strcmp($1.type, $3.type) != 0)
						printf("semantic error, line %d: comparison between 2 different types\n\n", yylineno);
					else {
						if (strcmp($1.type, "int") == 0) {
							if ($1.intVal == $3.intVal) $$ = 1;
							else $$ = 0;
						} else if (strcmp($1.type, "float") == 0) {
							if ($1.floatVal == $3.floatVal) $$ = 1;
							else $$ = 0;
						} else if (strcmp($1.type, "string") == 0) {
							if (strcmp($1.stringVal, $3.stringVal) == 0) $$ = 1;
							else $$ = 0;
						}
					}
				}
			;



expression : 	expression '+' termen {
					if (strcmp($1.type, $3.type) != 0) 
						printf("semantic error, line %d: different types used in the same expression\n\n", yylineno);
					else if (strcmp($1.type, "int") == 0) { //int or const int
						$$.type = "int";
						$$.intVal = $1.intVal + $3.intVal;
					} else if (strcmp($1.type, "float") == 0) { //float or const float
						$$.type = "float";
						$$.floatVal = $1.floatVal + $3.floatVal;
					} else if (strcmp($1.type, "string") == 0) { //string
						$$.type = "string";

						char dest[256], src[256];
						strcpy(dest, $1.stringVal);
						strcpy(src, $3.stringVal);
						strcat(dest, src);

						$$.stringVal = dest;
					}
				}
		   | 	expression '-' termen {
					if (strcmp($1.type, $3.type) != 0) 
						printf("semantic error, line %d: different types used in the same expression\n\n", yylineno);
					else if (strcmp($1.type, "int") == 0) { //int or const int
						$$.type = "int";
						$$.intVal = $1.intVal - $3.intVal;
					} else if (strcmp($1.type, "float") == 0) { //float or const float
						$$.type = "float";
						$$.floatVal = $1.floatVal - $3.floatVal;
					} else if (strcmp($1.type, "string") == 0) //string
						printf("semantic error, line %d: undefined string operator '-'\n\n", yylineno);
				}
		   | 	termen {
		   			if (strcmp($1.type, "int") == 0) { //int or const int
						$$.type = "int";
						$$.intVal = $1.intVal;
					} else if (strcmp($1.type, "float") == 0) { //float or const float
						$$.type = "float";
						$$.floatVal = $1.floatVal;
					} else if (strcmp($1.type, "string") == 0) { //string
						$$.type = "string";
						$$.stringVal = $1.stringVal;
					}
		   		}
		   ;

termen : 	termen '*' operand {
				if (strcmp($1.type, $3.type) != 0) 
					printf("semantic error, line %d: different types used in the same expression\n\n", yylineno);
				else if (strcmp($1.type, "int") == 0) { //int or const int
					$$.type = "int";
					$$.intVal = $1.intVal * $3.intVal;
				} else if (strcmp($1.type, "float") == 0) { //float or const float
					$$.type = "float";
					$$.floatVal = $1.floatVal * $3.floatVal;
				} else if (strcmp($1.type, "string") == 0) //string
					printf("semantic error, line %d: undefined string operator '*'\n\n", yylineno);
			}
	   | 	termen '/' operand {
	   			if (strcmp($1.type, $3.type) != 0) 
					printf("semantic error, line %d: different types used in the same expression\n\n", yylineno);
				else if (strcmp($1.type, "int") == 0) { //int or const int
					$$.type = "int";
					$$.intVal = $1.intVal / $3.intVal;
				} else if (strcmp($1.type, "float") == 0) { //float or const float
					$$.type = "float";
					$$.floatVal = $1.floatVal / $3.floatVal;
				} else if (strcmp($1.type, "string") == 0) //string
					printf("semantic error, line %d: undefined string operator '\'\n\n", yylineno);
	   		}
	   | 	operand {
				if (strcmp($1.type, "int") == 0) { //int or const int
					$$.type = "int";
					$$.intVal = $1.intVal;
				} else if (strcmp($1.type, "float") == 0) { //float or const float
					$$.type = "float";
					$$.floatVal = $1.floatVal;
				} else if (strcmp($1.type, "string") == 0) { //string
					$$.type = "string";
					$$.stringVal = $1.stringVal;
				}
			}
	   ;

operand : 	ID {
				checkId($1); //look for ID in variable list

				if (currVar == NULL) //ID not found in variable list
					printf("semantic error, line %d: undeclared variable '%s'\n\n", yylineno, $1);
				else { //ID found in variable list
					if (!currVar->set) 
						printf("semantic error, line %d: undefined variable '%s' used in expression\n\n", yylineno, $1);
					
					if (strcmp(currVar->type, "int") == 0 || strcmp(currVar->type, "const int") == 0) {
						$$.type = "int";
						$$.intVal = currVar->intVal;
						currVar->used = true;
					} else if (strcmp(currVar->type, "float") == 0 || strcmp(currVar->type, "const float") == 0) {
						$$.type = "float";
						$$.floatVal = currVar->floatVal;
						currVar->used = true;
					} else if (strcmp(currVar->type, "string") == 0) {
						$$.type = "string";
						$$.stringVal = currVar->stringVal;
						currVar->used = true;
					}
				}
			}
		| 	INT_VAL {
				$$.type = "int";
				$$.intVal = $1;
			}
		|	FLOAT_VAL {
				$$.type = "float";
				$$.floatVal = $1;
			}
		|	STRING_VAL {
				$$.type = "string";
				$$.stringVal = $1;
			}
		;



print :	PRINT '(' expression ',' INT ')' ';' {
			if (strcmp($3.type, "int") != 0)
				printf("semantic error, line %d: expression doesn't match print type\n\n", yylineno);
			else printf("result: %d\n\n", $3.intVal);
		}
	  | PRINT '(' expression ',' FLOAT ')' ';' {
			if (strcmp($3.type, "float") != 0)
				printf("semantic error, line %d: expression doesn't match print type\n\n", yylineno);
			else printf("result: %f\n\n", $3.floatVal);
		}
	  | PRINT '(' expression ',' STRING ')' ';' {
			if (strcmp($3.type, "string") != 0)
				printf("semantic error, line %d: expression doesn't match print type\n\n", yylineno);
			else printf("result: %s\n\n", $3.stringVal);
		}
	  |	PRINT '(' boolExpression ',' BOOL ')' ';' {printf($3 ? "result: true\n\n" : "result: false\n\n");}
	  |	error ';'
	  ;

%%
int main(int argc, char** argv){
	yyin = fopen(argv[1], "r");
	yyparse();

	FILE * fout = fopen("symbolTable.txt", "w");
	currVar = firstVar; 
	while (currVar != NULL) {
		if (currVar->type == "int") fprintf(fout, "int %s = %d\n", currVar->name, currVar->intVal);
		else if (currVar->type == "const int") fprintf(fout, "const int %s = %d\n", currVar->name, currVar->intVal);

		if (currVar->type == "float") fprintf(fout, "float %s = %f\n", currVar->name, currVar->floatVal);
		else if (currVar->type == "const float") fprintf(fout, "const float %s = %f\n", currVar->name, currVar->floatVal);

		if (currVar->type == "string") fprintf(fout, "string %s = %s\n", currVar->name, currVar->stringVal);

		if (!currVar->used) printf("warning: unused variable '%s'\n\n", currVar->name);
		currVar = currVar->next;
	}
}