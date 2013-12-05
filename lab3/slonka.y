/* slonka.y */

%{

#include <iostream>
#include <string>

using namespace std;

int yylex(void);
void yyerror(const char *);

#define YYSTYPE string
%}

%token DECL_SPECIFIER
%token ID
%token NUM
%token BODY

%%

/* TODO: functions */

function: decl_specifier declarator declaration_list body
	| declarator declaration_list body
	| decl_specifier declarator body
	| declarator body
	;

declaration_list: declaration 
	| declaration declaration_list
	;

declaration: decl_specifier ';'
	| decl_specifier declarator_list ';'
	;

declarator_list: declarator
	| declarator ',' declarator_list
	;

declarator: pointer direct_declarator
	| direct_declarator
	;

direct_declarator: id
	| '(' declarator ')'
        | direct_declarator '[' num ']'
	| direct_declarator "[]"
        | direct_declarator '(' param_list ')' { cout << "direct_declarator (param list)\n"; }
	| direct_declarator '(' identifier_list ')'
        | direct_declarator "()"
	;

identifier_list: id
	| id ',' identifier_list
	;

param_list: param_declaration
	| param_declaration ',' param_list
	;

param_declaration: decl_specifier declarator
	| decl_specifier
	| decl_specifier abstract_declarator
	;

abstract_declarator: pointer
	| pointer direct_abstract_declarator
	| direct_abstract_declarator
	;

direct_abstract_declarator: '(' abstract_declarator ')'
	| direct_abstract_declarator '[' num ']'
	| '[' num ']'
	| direct_abstract_declarator "[]"
	| "[]"
	| direct_abstract_declarator '(' param_list ')'
	| direct_abstract_declarator "()"
	| '(' param_list ')'
	| "()"
	;

pointer: '*'
	| '*' pointer
	;

/* debug functions */
decl_specifier: DECL_SPECIFIER { std::cout << "decl_specifier: "+ string($1) +"\n"; }
id: ID {std::cout <<"id: "+ string($1) +"\n";}
num: NUM {std::cout << "num: "+ string($1) + "\n";}
body: BODY {std::cout << "num: "+ string($1) + "\n";}

%%
void yyerror(const char *s) {
   cout << "blad: " + string(s) +"\n";
}

int main() {
  yyparse();
}

