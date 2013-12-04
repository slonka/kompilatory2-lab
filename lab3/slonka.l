/* slonka.l */

%{
	#include "slonka.tab.h"
	#include <iostream>
	#include <string>	

	using namespace std;

	/* TODO: olane struct i enum */
%}
decl_specifier	void|char|short|int|long|float
id	c
num	[0-9]+
%%

{decl_specifier}	yylval.p_char = yytext; return(DECL_SPECIFIER);	

%%

