/* slonka.l */

%{
	#include <iostream>
	#include <string>
	using namespace std;

	#define YYSTYPE string
	
	#include "slonka.tab.h"		

	/* TODO: olane struct i enum */
%}
decl_specifier	void|char|short|int|long|float
id	[a-z|A-Z]+
num	[0-9]+
body	"{".*"}"
%%

{decl_specifier}	yylval = yytext; return(DECL_SPECIFIER);
{id}			yylval = yytext; return(ID);
{num}			yylval = yytext; return(NUM);
{body}			yylval = yytext; return(BODY);

%%

