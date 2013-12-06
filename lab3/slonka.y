/* bison.y */

%{

#include <iostream>
#include <string>

using namespace std;

int yylex(void);
void yyerror(const char *);

#define YYSTYPE string

#ifndef DEBUG
    #define DEBUG 0
#endif
%}

%token DECL_SPECIFIER
%token ID
%token NUM
%token BODY
%token OB /* open bracket */
%token CB /* close bracket */
%token SC /* semi-colon */
%token C /* comma */

%%

/* TODO: functions */

function: decl_specifier declarator declaration_list body		{ if(DEBUG) { $$ = $1 + $2 + $3 +$4;	std::cout << "function: "+ string($$) + "\n&&\n";}}
        | declarator declaration_list body						{ if(DEBUG) { $$ = $1 + $2 + $3;		std::cout << "function: "+ string($$) + "\n&&\n";}}
        | decl_specifier declarator body						{ if(DEBUG) { $$ = $1 + $2 + $3;		std::cout << "function: "+ string($$) + "\n&&\n";}}
        | declarator body										{ if(DEBUG) { $$ = $1 + $2;				std::cout << "function: "+ string($$) + "\n&&\n";}}
        ;
	
declaration_list: declaration							{ if(DEBUG) { $$ = $1;			std::cout << "declaration_list: "+ string($$) + "\n&&\n";}}
        | declaration declaration_list					{ if(DEBUG) { $$ = $1 + $2;		std::cout << "declaration_list: "+ string($$) + "\n&&\n";}}
        ;

declaration: decl_specifier SC							{ if(DEBUG) { $$ = $1 + ";";			std::cout << "declaration: "+ string($$) + "\n&&\n";}}
        | decl_specifier declarator_list SC				{ if(DEBUG) { $$ = $1 + " " + $2 + ";";	std::cout << "declaration: "+ string($$) + "\n&&\n";}}
        ;

declarator_list: declarator								{ if(DEBUG) { $$ = $1;				std::cout << "declarator_list: "+ string($$) + "\n&&\n";}}
        | declarator C declarator_list					{ if(DEBUG) { $$ = $1 + "," + $3;	std::cout << "declarator_list: "+ string($$) + "\n&&\n";}}
        ;

declarator: pointer direct_declarator					{ if(DEBUG) { $$ = $1 + $2;		std::cout << "declarator: "+ string($$) + "\n&&\n";}}
        | direct_declarator								{ if(DEBUG) { $$ = $1;			std::cout << "declarator: "+ string($$) + "\n&&\n";}}
        ;	

direct_declarator: id									{ if(DEBUG) { $$ = $1;					std::cout << "declarator: "+ string($$) + "\n&&\n";}}	
        | OB declarator CB								{ if(DEBUG) { $$ = "(" + $2 + ")";		std::cout << "declarator: "+ string($$) + "\n&&\n";}}
        | direct_declarator '[' num ']'					{ if(DEBUG) { $$ = $1 + "[" + $3 + "]";	std::cout << "declarator: "+ string($$) + "\n&&\n";}}
        | direct_declarator "[]"						{ if(DEBUG) { $$ = $1 + "[]";			std::cout << "declarator: "+ string($$) + "\n&&\n";}}	
        | direct_declarator OB param_list CB			{ if(DEBUG) { $$ = $1 + "("  +$3 + ")";	std::cout << "declarator: "+ string($$) + "\n&&\n";}}	
        | direct_declarator OB identifier_list CB		{ if(DEBUG) { $$ = $1 + "("  +$3 + ")";	std::cout << "declarator: "+ string($$) + "\n&&\n";}}		
        | direct_declarator OB CB						{ if(DEBUG) { $$ = $1 + "()";			std::cout << "declarator: "+ string($$) + "\n&&\n";}}	
        ;
	
identifier_list: id										{ if(DEBUG) { $$ = $1;	std::cout << "id_list: "+ string($$) + "\n&&\n";}}
        | id C identifier_list							{ if(DEBUG) { $$ = $1 + "," + $3;	std::cout << "id_list: "+ string($$) + "\n&&\n";}}
        ;

param_list: param_declaration							{ if(DEBUG) { $$ = $1;	std::cout << "param_decl: "+ string($$) + "\n&&\n";}}
        | param_declaration C param_list				{ if(DEBUG) { $$ = $1 + "," + $3;	std::cout << "param_decl: "+ string($$) + "\n&&\n";}}
        ;

param_declaration: decl_specifier declarator			{ if(DEBUG) { $$ = $1 + $2;	std::cout << "param_decl: "+ string($$) + "\n&&\n";}}
        | decl_specifier								{ if(DEBUG) { $$ = $1;		std::cout << "param_decl: "+ string($$) + "\n&&\n";}}
        | decl_specifier abstract_declarator			{ if(DEBUG) { $$ = $1 + $2;	std::cout << "param_decl: "+ string($$) + "\n&&\n";}}
        ;

abstract_declarator: pointer							{ if(DEBUG) { $$ = $1;		std::cout << "ab_decl: "+ string($$) + "\n&&\n";}}
        | pointer direct_abstract_declarator			{ if(DEBUG) { $$ = $1 + $2;	std::cout << "ab_decl: "+ string($$) + "\n&&\n";}}
        | direct_abstract_declarator					{ if(DEBUG) { $$ = $1;		std::cout << "ab_decl: "+ string($$) + "\n&&\n";}}
        ;

direct_abstract_declarator: OB abstract_declarator CB		{ if(DEBUG) { $$ = "(" + $2 + ")";		std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | direct_abstract_declarator '[' num ']'			{ if(DEBUG) { $$ = $1 + "[" + $3 + "]";	std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | '[' num ']'										{ if(DEBUG) { $$ = "[" + $2 + "]";		std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | direct_abstract_declarator "[]"					{ if(DEBUG) { $$ = $1 + "[]";			std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | "[]"												{ if(DEBUG) { $$ = "[]";				std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | direct_abstract_declarator OB param_list CB		{ if(DEBUG) { $$ = $1 + "(" + $3 + ")";	std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | direct_abstract_declarator OB CB					{ if(DEBUG) { $$ = $1 + "()";			std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | OB param_list CB									{ if(DEBUG) { $$ = "(" + $1 + ")";		std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | OB CB												{ if(DEBUG) { $$ = "()";				std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        ;

pointer: '*'
        | '*' pointer		{ if(DEBUG) { $$ = '*' + $2; }}
        ;

/* debug functions */
decl_specifier: 		DECL_SPECIFIER 	{ if(DEBUG) { std::cout << "decl_specifier: "+ string($1) +"\n&&\n";}}
id: 					ID 				{ if(DEBUG) { std::cout << "id: "+ string($1) +"\n&&\n";}}
num: 					NUM 			{ if(DEBUG) { std::cout << "num: "+ string($1) + "\n&&\n";}}
body: 					BODY 			{ if(DEBUG) { std::cout << "body: "+ string($1) + "\n&&\n";}}

%%
void yyerror(const char *s) {
   cout << "blad: " + string(s) +"\n&&\n";
}

int main() {
  yyparse();
}
