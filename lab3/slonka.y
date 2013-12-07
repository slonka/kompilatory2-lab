/* slonka.y */

%{

#include <iostream>
#include <string>
#include <map>

using namespace std;

int yylex(void);
void yyerror(const char *);

#define YYSTYPE string

#ifndef DEBUG
    #define DEBUG 0
#endif

typedef map<string,string> argmap;

argmap arguments;

void print_body(string body) {
    cout << body << endl;
}

void print_map(argmap m) {
    for(argmap::iterator it=m.begin(); it!=m.end(); ++it) {
        cout << it->first << " => " << it->second << '\n';
    }
}

%}

%token DECL_SPECIFIER
%token ID
%token NUM
%token BODY
%token OB /* open bracket */
%token CB /* close bracket */
%token SC /* semi-colon */
%token C /* comma */
%token OSB /* open square bracket */
%token CSB /* close square bracket */
%token WHITESPACE
%token ESB /* empty square brackets [] */

%%


functions: function { $$ = $1; if(DEBUG) {cout << "functions1: " + string($$) + "\n";}}
        | function functions { $$ = $1 + $2; if(DEBUG) {cout << "functions2: " + string($$) + "\n";}}
        ;

function: decl_specifier declarator declaration_list body {
    $$ = $1 + ' ' + $2 + ' ' + $3 + '\n' + $4;

    print_body($4);    
    print_map(arguments);

    if(DEBUG) { cout << "function: "+ string($$) + "\n&&\n";}
}

        | declarator declaration_list body {
    $$ = $1 + ' ' + $2 + '\n' + $3;	
    
    print_body($3);
    print_map(arguments);

    if(DEBUG) { cout << "function: "+ string($$) + "\n&&\n";}
}

        | decl_specifier declarator body {
    $$ = $1 + ' ' + $2 + '\n' + $3; 

    print_body($3);
    print_map(arguments);

    if(DEBUG) { cout << "function: "+ string($$) + "\n&&\n";}
}

        | declarator body { 
    $$ = $1 + '\n' + $2;

    print_body($2);
    print_map(arguments);

    if(DEBUG) { cout << "function: "+ string($$) + "\n&&\n";}
}
        ;
	
declaration_list: declaration							{ $$ = $1;			if(DEBUG) { cout << "declaration_list1: "+ string($$) + "\n&&\n";}}
        | declaration declaration_list					{ $$ = $1 + $2;		if(DEBUG) { cout << "declaration_list2: "+ string($$) + "\n&&\n";}}
        ;

declaration: decl_specifier SC							{ $$ = $1 + ";";			if(DEBUG) { cout << "declaration: "+ string($$) + "\n&&\n";}}
        | decl_specifier declarator_list SC				{ $$ = $1 + " " + $2 + ";";	if(DEBUG) { cout << "declaration: "+ string($$) + "\n&&\n";}}
        ;

declarator_list: declarator								{ $$ = $1;				if(DEBUG) { cout << "declarator_list: "+ string($$) + "\n&&\n";}}
        | declarator C declarator_list					{ $$ = $1 + "," + $3;	if(DEBUG) { cout << "declarator_list: "+ string($$) + "\n&&\n";}}
        ;

declarator: pointer direct_declarator					{ $$ = $1 + $2;		if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}
        | direct_declarator								{ $$ = $1;			if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}
        ;	

direct_declarator: id									{ $$ = $1;					if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}	
        | OB declarator CB								{ $$ = "(" + $2 + ")";		if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}
        | direct_declarator OSB num CSB					{ $$ = $1 + "[" + $3 + "]";	if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}
        | direct_declarator ESB 						{ $$ = $1 + "[]";			if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}	
        | direct_declarator OB param_list CB			{ $$ = $1 + "("  +$3 + ")";	if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}	
        | direct_declarator OB identifier_list CB		{ $$ = $1 + "("  +$3 + ")";	if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}		
        | direct_declarator OB CB						{ $$ = $1 + "()";			if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}	
        ;
	
identifier_list: id										{ $$ = $1;	if(DEBUG) { cout << "id_list: "+ string($$) + "\n&&\n";}}
        | id C identifier_list							{ $$ = $1 + "," + $3;	if(DEBUG) { cout << "id_list: "+ string($$) + "\n&&\n";}}
        ;

param_list: param_declaration { 
    $$ = $1;	if(DEBUG) { cout << "param_decl: "+ string($$) + "\n&&\n";}
}
        | param_declaration C param_list {
    $$ = $1 + ", " + $3;	if(DEBUG) { cout << "param_decl: "+ string($$) + "\n&&\n";}
}
        ;

param_declaration: decl_specifier declarator {
    $$ = $1 + ' ' + $2;
    if(DEBUG) { cout << "param_decl: "+ string($$) + "\n&&\n";}
    arguments[$2] = $1;
}
        | decl_specifier								{ $$ = $1;		if(DEBUG) { cout << "param_decl: "+ string($$) + "\n&&\n";}}
        | decl_specifier abstract_declarator			{ $$ = $1 + $2;	if(DEBUG) { cout << "param_decl: "+ string($$) + "\n&&\n";}}
        ;

abstract_declarator: pointer							{ $$ = $1;		if(DEBUG) { cout << "ab_decl: "+ string($$) + "\n&&\n";}}
        | pointer direct_abstract_declarator			{ $$ = $1 + $2;	if(DEBUG) { cout << "ab_decl: "+ string($$) + "\n&&\n";}}
        | direct_abstract_declarator					{ $$ = $1;		if(DEBUG) { cout << "ab_decl: "+ string($$) + "\n&&\n";}}
        ;

direct_abstract_declarator: OB abstract_declarator CB		{ $$ = "(" + $2 + ")";		if(DEBUG) { cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | direct_abstract_declarator OSB num CSB			{ $$ = $1 + "[" + $3 + "]";	if(DEBUG) { cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | OSB num CSB										{ $$ = "[" + $2 + "]";		if(DEBUG) { cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | direct_abstract_declarator ESB 					{ $$ = $1 + "[]";			if(DEBUG) { cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | ESB												{ $$ = "[]";				if(DEBUG) { cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | direct_abstract_declarator OB param_list CB		{ $$ = $1 + "(" + $3 + ")";	if(DEBUG) { cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | direct_abstract_declarator OB CB					{ $$ = $1 + "()";			if(DEBUG) { cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | OB param_list CB									{ $$ = "(" + $1 + ")";		if(DEBUG) { cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        | OB CB												{ $$ = "()";				if(DEBUG) { cout << "d_a_decl: "+ string($$) + "\n&&\n";}}
        ;

pointer: '*'
        | '*' pointer		{ $$ = '*' + $2; }
        ;

/* debug functions */
decl_specifier: 		DECL_SPECIFIER 	{ if(DEBUG) { std::cout << "decl_specifier: "+ string($$) +"\n&&\n";}}
id: 					ID 				{ if(DEBUG) { std::cout << "id: "+ string($$) +"\n&&\n";}}
num: 					NUM 			{ if(DEBUG) { std::cout << "num: "+ string($$) + "\n&&\n";}}
body: 					BODY 			{ if(DEBUG) { std::cout << "body: "+ string($$) + "\n&&\n";}}

%%
void yyerror(const char *s) {
   cout << "blad: " + string(s) +"\n&&\n";
}

int main() {
    /* if (0) {
        yydebug = 1;
    }*/
    yyparse();
}

