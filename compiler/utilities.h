#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

extern FILE* yyin;
extern char* yytext;
extern int yylineno;

int yylex();
void yyerror(char *s) {
	fprintf(stderr,"%s, line %d\n\n", s, yylineno);
}

typedef struct var {
    char *type;
    char *name;

    int intVal;
    float floatVal;
    char *stringVal;

    bool set;
    bool used;

	struct var *next;
} var;

var *firstVar = NULL, *lastVar = NULL, *currVar;

void checkId(char *name) {
	currVar = firstVar;
	while (currVar != NULL) {
		if (strcmp(currVar->name, name) == 0) break;
		currVar = currVar->next;
	}
}

void addInt(char *name, char *type, int intVal, bool set) {
	var *temp = (var *) malloc(sizeof(var));

	temp->type = type;
	temp->name = name;

	temp->intVal = intVal;
	temp->floatVal = 0;
	temp->stringVal = NULL;

	temp->set = set;
	temp->used = false;

	temp->next = NULL;

	if (firstVar == NULL) firstVar = lastVar = temp;
	else {
		lastVar->next = temp;
		lastVar = temp;
	}
}

void addFloat(char *name, char *type, float floatVal, bool set) {
	var *temp = (var *) malloc(sizeof(var));

	temp->type = type;
	temp->name = name;

	temp->intVal = 0;
	temp->floatVal = floatVal;
	temp->stringVal = NULL;

	temp->set = set;
	temp->used = false;

	temp->next = NULL;

	if (firstVar == NULL) firstVar = lastVar = temp;
	else {
		lastVar->next = temp;
		lastVar = temp;
	}
}

void addString(char *name, char *type, char *stringVal, bool set) {
	var *temp = (var *) malloc(sizeof(var));

	temp->type = type;
	temp->name = name;

	temp->intVal = 0;
	temp->floatVal = 0;
	temp->stringVal = stringVal;

	temp->set = set;
	temp->used = false;

	temp->next = NULL;

	if (firstVar == NULL) firstVar = lastVar = temp;
	else {
		lastVar->next = temp;
		lastVar = temp;
	}
}