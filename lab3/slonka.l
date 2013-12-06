/* slonka.l */

%{
		#include "slonka.tab.h" 
        #include <iostream>
        #include <string>
        #define YYSTYPE string
		using namespace std;
%}
decl_specifier        void|char|short|int|long|float
id                    [a-z|A-Z]+
num                   [0-9]+
body                  "{".*"}"
%%

{decl_specifier}        yylval = yytext; return(DECL_SPECIFIER);
{id}                    yylval = yytext; return(ID);
{num}                   yylval = yytext; return(NUM);
"("						yylval = yytext; return(OP);
")"						yylval = yytext; return(CS);
","						yylval = yytext; return(C);
";"						yylval = yytext; return(SC);
{body}                  yylval = "BODY"; return(BODY);	

[ \n\r\t]				;

%%
