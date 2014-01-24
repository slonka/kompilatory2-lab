/* slonka.y */

%{

#include <iostream>
#include <string>
#include <map>
#include <sstream>
#include <algorithm>
#include <iterator>
#include <vector>
#include <list>

using namespace std;

int yylex(void);
void yyerror(const char *);

#define YYSTYPE string

#ifndef DEBUG
    #define DEBUG 0
#endif

typedef map<string,string> argmap;

const int OLD_DECLARATION = 1; // function has old style declaration e.g. int f(a, b, c)
const int NEW_DECLARATION = 2; // function has new style declaration e.g. int f(int a, int b, int c)

argmap arguments;
argmap declarations;

string function_name;

list<string> decl_list;
list<string> arg_list;

int declaration_type;

void print_body(string body) {
    cout << body << endl;
}

void print_map(argmap m) {
    for(argmap::iterator it=m.begin(); it!=m.end(); ++it) {
        cout << it->first << " => " << it->second << '\n';
    }
}

void print_list(list<string> lst) {
    for(list<string>::iterator it=lst.begin(); it!=lst.end(); ++it) {
        cout << *it << ", ";
    }
    cout << "\n";
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
    if(DEBUG) {
        cout << "arguments: \n";
        print_map(arguments);

        cout << "declarations\n";    
        print_map(declarations);

        cout << "arg_list: \n";
        print_list(arg_list);

        cout << "decl_list: \n";
        print_list(decl_list);
    }

    cout << $1 << " " << function_name << "(";

    if(declarations.empty()) {
        cout << "void";
    } else {
            argmap::iterator finalIter = arguments.end();
            --finalIter;

            for(argmap::iterator it=arguments.begin(); it!=arguments.end(); ++it) {
                if(it->second != string("")) {
                    if(it == finalIter) {
                       cout << it->second << " " << it->first << ""; 
                    } else {
                        cout << it->second << " " << it->first << ", ";
                    }
                } else {
                    cout << "arg not declared (no type) " << it->first;
                }
                
            }

            arg_list.clear();
            decl_list.clear();
            declarations.clear();
            arguments.clear();

            cout << ")" << endl;
    }

    print_body($4);
    if(DEBUG) { cout << "function decl_specifier declarator declaration_list body: "+ string($$) + "\n&&\n";}
}

        | declarator declaration_list body {
    $$ = $1 + ' ' + $2 + '\n' + $3;	

    cout << $$;    

    if(DEBUG) { cout << "function: "+ string($$) + "\n&&\n";}
}

        | decl_specifier declarator body {
    $$ = $1 + ' ' + $2 + '\n' + $3; 

    if(arguments.empty()) {
        cout << $1 + ' ' + function_name + "(void)\n";
        print_body($3);
    } else {
        cout << $$;
    }


    if(DEBUG) { cout << "function: "+ string($$) + "\n&&\n";}
}

        | declarator body { 
    $$ = $1 + '\n' + $2;

    cout << $$;

    if(DEBUG) { cout << "function: "+ string($$) + "\n&&\n";}
}
        ;
	
declaration_list: declaration							{
    $$ = $1; 

    if(DEBUG) { cout << "declaration_list1: "+ string($$) + "\n&&\n";}
}
        | declaration declaration_list	{
    $$ = $1 + $2;


    if(DEBUG) { cout << "declaration_list2: "+ string($$) + "\n&&\n";}
}
        ;

declaration: decl_specifier SC {
    $$ = $1 + ";";

    if(DEBUG) { cout << "declaration: "+ string($$) + "\n&&\n";}
}
        | decl_specifier declarator_list SC	{
    $$ = $1 + " " + $2 + ";";

    for(std::list<string>::const_iterator i = decl_list.begin(); i !=decl_list.end(); ++i) {
        //cout << "d[" << *i << "]= " << $1 << endl;
        declarations[*i] = $1;
    }
    
    for(std::list<string>::const_iterator i = arg_list.begin(); i !=arg_list.end(); ++i) {
        //cout << "d[" << *i << "]= " << $1 << endl;
        arguments[*i] = declarations[*i];
    }

    decl_list.clear(); 
    
    if(DEBUG) { cout << "declaration_list: "+ string($$) + "\n&&\n";}
}
        ;

declarator_list: declarator { // single items
    $$ = $1;
    decl_list.push_front($1);
    if(DEBUG) { cout << "declarator_list: "+ string($$) + "\n&&\n";}
}
        | declarator C declarator_list { // declarator list
    $$ = $1 + "," + $3;
    decl_list.push_front($1); 
    if(DEBUG) { cout << "declarator_list: "+ string($$) + "\n&&\n";}
}
        ;

declarator: pointer direct_declarator					{ $$ = $1 + $2;		if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}
        | direct_declarator	{
    $$ = $1;

    if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}
}
        ;	

direct_declarator: id									{ $$ = $1;					if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}	
        | OB declarator CB								{ $$ = "(" + $2 + ")";		if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}
        | direct_declarator OSB num CSB					{ $$ = $1 + "[" + $3 + "]";	if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}}
        | direct_declarator ESB 						{
    $$ = $1 + "[]";

    function_name = $$;    

	if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}
}	
        | direct_declarator OB param_list CB {
    function_name = $1;
    $$ = $1 + "("  +$3 + ")";	if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}
}	
        | direct_declarator OB identifier_list CB		{
    function_name = $1;
    $$ = $1 + "("  +$3 + ")";	if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}
}		
        | direct_declarator OB CB						{
    function_name = $1;
    $$ = $1 + "()";			if(DEBUG) { cout << "declarator: "+ string($$) + "\n&&\n";}
}	
        ;
	
identifier_list: id	{
    $$ = $1;
 
    arg_list.push_front($1); // get identifiers 

    if(DEBUG) { cout << "id_list1: "+ string($$) + "\n&&\n";}
}
        | id C identifier_list {
    $$ = $1 + "," + $3;

    arg_list.push_front($1); // get identifiers

    if(DEBUG) { cout << "id_list2: "+ string($$) + "\n&&\n";}
}
        ;

param_list: param_declaration { 
    
    $$ = $1;	if(DEBUG) { cout << "param_decl: "+ string($$) + "\n&&\n";}

}
        | param_declaration C param_list {
    
    $$ = $1 + ", " + $3;	if(DEBUG) { cout << "param_decl: "+ string($$) + "\n&&\n";}

}
        ;

param_declaration: decl_specifier declarator { /* type and name e.g. f(int a, int b) */
    $$ = $1 + ' ' + $2;
    if(DEBUG) { cout << "param_decl1: "+ string($$) + "\n&&\n";}
    arguments[$2] = $1;
}
        | decl_specifier { /* only type e.g. f(char, char) */ 
    $$ = $1;
    arguments[$1] = "not_specified";

    if(DEBUG) { cout << "param_decl2: "+ string($$) + "\n&&\n";}
}
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
        | '*' pointer		{ $$ = '*' + $2; if(DEBUG) { cout << "pointer: "+ string($$) + "\n&&\n";}}
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

