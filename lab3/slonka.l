/* slonka.l */

%{
 		using namespace std;
        #include <string>
        #define YYSTYPE string
		#include "slonka.tab.h" 
        #include <iostream>

        int opening_braces = 0;
%}


decl_specifier        void|char|short|int|long|float
id                    [a-z|A-Z][a-z|A-Z|0-9_-]*
num                   [0-9]+
body                  "{"
whitespace            [ \n\r\t]+
any                   .|\n
esb                   "[]"

%option yylineno

%x IN_BODY
%x IN_COMMENT

%%

{decl_specifier}        yylval = yytext; return(DECL_SPECIFIER);
{id}                    yylval = yytext; return(ID);
{num}                   yylval = yytext; return(NUM);
{esb}                   yylval = yytext; return(ESB);
"("						yylval = yytext; return(OB);
")"						yylval = yytext; return(CB);
"["                     yylval = yytext; return(OSB);
"]"                     yylval = yytext; return(CSB);
","						yylval = yytext; return(C);
";"						yylval = yytext; return(SC);

{body}                  yylval = yytext; BEGIN(IN_BODY);
<IN_BODY>{
    "}" { if (opening_braces--) {
            yylval += yytext;
        } else {
            opening_braces = 0;
            yylval += yytext; BEGIN(INITIAL); return(BODY);
        }
    }
    "{"                     yylval += yytext; opening_braces++;

    "//".*\n                yylval += yytext; /* default comment // */
    \".*\"\n                yylval += yytext; /* inside strings */
    "/*"                    yylval += yytext; BEGIN(IN_COMMENT);
    {any}                   yylval += yytext; /* anything other */
}

<IN_COMMENT>{
     "*/"      yylval += yytext; BEGIN(IN_BODY);
     {any}     yylval += yytext;
}

{whitespace}			;

%%
