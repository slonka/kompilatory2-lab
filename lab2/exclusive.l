
%option noyywrap

%{
/* exclusive.l
   demonstruje dzialanie wylacznych stanow startowych */
%}

%x LITERAL
%%

raz                ECHO;
dwa                ECHO;
#                  BEGIN(LITERAL);
<LITERAL>#         BEGIN(INITIAL);
.                  /* empty */


%%

int main()
{
  yylex();
  return 0;
}
