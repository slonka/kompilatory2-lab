/* slonka.l */

%{
 		using namespace std;
        #include <string>
        #define YYSTYPE string
		#include "slonka.tab.h" 
        #include <iostream>

        int tmp = 0;
%}


decl_specifier        void|char|short|int|long|float
id                    [a-z|A-Z]+
num                   [0-9]+
body                  "{"


%option yylineno
%x IN_BODY

%%

{decl_specifier}        yylval = yytext; return(DECL_SPECIFIER);
{id}                    yylval = yytext; return(ID);
{num}                   yylval = yytext; return(NUM);
"("						yylval = yytext; return(OB);
")"						yylval = yytext; return(CB);
","						yylval = yytext; return(C);
";"						yylval = yytext; return(SC);

<INITIAL>{body}         yylval += yytext; BEGIN(IN_BODY);
<IN_BODY>{
"}"            yylval += yytext; return(BODY); BEGIN(INITIAL);
.              yylval += yytext;
}

[ \n\r\t]				;

%%
