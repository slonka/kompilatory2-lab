/* bison.y */

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
%token OP
%token CS
%token SC
%token C

%%

/* TODO: functions */

function: decl_specifier declarator declaration_list body		{ $$ = $1 + $2 + $3 +$4;	std::cout << "function: "+ string($$) + "\n&&\n";}
        | declarator declaration_list body						{ $$ = $1 + $2 + $3;		std::cout << "function: "+ string($$) + "\n&&\n";}
        | decl_specifier declarator body						{ $$ = $1 + $2 + $3;		std::cout << "function: "+ string($$) + "\n&&\n";}
        | declarator body										{ $$ = $1 + $2;				std::cout << "function: "+ string($$) + "\n&&\n";}
        ;
	
declaration_list: declaration							{ $$ = $1;			std::cout << "declaration_list: "+ string($$) + "\n&&\n";}
        | declaration declaration_list					{ $$ = $1 + $2;		std::cout << "declaration_list: "+ string($$) + "\n&&\n";}
        ;

declaration: decl_specifier SC							{ $$ = $1 + ";";			std::cout << "declaration: "+ string($$) + "\n&&\n";}
        | decl_specifier declarator_list SC				{ $$ = $1 + " " + $2 + ";";	std::cout << "declaration: "+ string($$) + "\n&&\n";}
        ;

declarator_list: declarator								{ $$ = $1;				std::cout << "declarator_list: "+ string($$) + "\n&&\n";}
        | declarator C declarator_list					{ $$ = $1 + "," + $3;	std::cout << "declarator_list: "+ string($$) + "\n&&\n";}
        ;

declarator: pointer direct_declarator					{ $$ = $1 + $2;		std::cout << "declarator: "+ string($$) + "\n&&\n";}
        | direct_declarator								{ $$ = $1;			std::cout << "declarator: "+ string($$) + "\n&&\n";}
        ;	

direct_declarator: id									{ $$ = $1;					std::cout << "declarator: "+ string($$) + "\n&&\n";}	
        | OP declarator CS								{ $$ = "(" + $2 + ")";		std::cout << "declarator: "+ string($$) + "\n&&\n";}
        | direct_declarator '[' num ']'					{ $$ = $1 + "[" + $3 + "]";	std::cout << "declarator: "+ string($$) + "\n&&\n";}
        | direct_declarator "[]"						{ $$ = $1 + "[]";			std::cout << "declarator: "+ string($$) + "\n&&\n";}	
        | direct_declarator OP param_list CS			{ $$ = $1 + "("  +$3 + ")";	std::cout << "declarator: "+ string($$) + "\n&&\n";}	
        | direct_declarator OP identifier_list CS		{ $$ = $1 + "("  +$3 + ")";	std::cout << "declarator: "+ string($$) + "\n&&\n";}		
        | direct_declarator OP CS						{ $$ = $1 + "()";			std::cout << "declarator: "+ string($$) + "\n&&\n";}	
        ;
	
identifier_list: id										{ $$ = $1;	std::cout << "id_list: "+ string($$) + "\n&&\n";}
        | id C identifier_list							{ $$ = $1 + "," + $3;	std::cout << "id_list: "+ string($$) + "\n&&\n";}
        ;

param_list: param_declaration							{ $$ = $1;	std::cout << "param_decl: "+ string($$) + "\n&&\n";}
        | param_declaration C param_list				{ $$ = $1 + "," + $3;	std::cout << "param_decl: "+ string($$) + "\n&&\n";}
        ;

param_declaration: decl_specifier declarator			{ $$ = $1 + $2;	std::cout << "param_decl: "+ string($$) + "\n&&\n";}
        | decl_specifier								{ $$ = $1;		std::cout << "param_decl: "+ string($$) + "\n&&\n";}
        | decl_specifier abstract_declarator			{ $$ = $1 + $2;	std::cout << "param_decl: "+ string($$) + "\n&&\n";}
        ;

abstract_declarator: pointer							{ $$ = $1;		std::cout << "ab_decl: "+ string($$) + "\n&&\n";}
        | pointer direct_abstract_declarator			{ $$ = $1 + $2;	std::cout << "ab_decl: "+ string($$) + "\n&&\n";}
        | direct_abstract_declarator					{ $$ = $1;		std::cout << "ab_decl: "+ string($$) + "\n&&\n";}
        ;

direct_abstract_declarator: OP abstract_declarator CS		{ $$ = "(" + $2 + ")";		std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}
        | direct_abstract_declarator '[' num ']'			{ $$ = $1 + "[" + $3 + "]";	std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}
        | '[' num ']'										{ $$ = "[" + $2 + "]";		std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}
        | direct_abstract_declarator "[]"					{ $$ = $1 + "[]";			std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}
        | "[]"												{ $$ = "[]";				std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}
        | direct_abstract_declarator OP param_list CS		{ $$ = $1 + "(" + $3 + ")";	std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}
        | direct_abstract_declarator OP CS					{ $$ = $1 + "()";			std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}
        | OP param_list CS									{ $$ = "(" + $1 + ")";		std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}
        | OP CS												{ $$ = "()";				std::cout << "d_a_decl: "+ string($$) + "\n&&\n";}
        ;

pointer: '*'
        | '*' pointer		{ $$ = '*' + $2; }
        ;

/* debug functions */
decl_specifier: 		DECL_SPECIFIER 	{std::cout << "decl_specifier: "+ string($1) +"\n&&\n"; }
id: 					ID 				{std::cout << "id: "+ string($1) +"\n&&\n";}
num: 					NUM 			{std::cout << "num: "+ string($1) + "\n&&\n";}
body: 					BODY 			{std::cout << "body: "+ string($1) + "\n&&\n";}

%%
void yyerror(const char *s) {
   cout << "blad: " + string(s) +"\n&&\n";
}

int main() {
  yyparse();
}