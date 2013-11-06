%{
/* slonka.l

#define KRED "\x1B[31m"
#define KNRM "\x1B[0m"
#define KGRN "\x1B[32m"
#define KYEL "\x1B[33m"
#define KBLU "\x1B[34m"
#define KMAG "\x1B[35m"
#define KCYN "\x1B[36m"
#define KWHT "\x1B[37m"

*/
%}

HOUR	[0-1][0-9]|2[0-4]
MINUTE	[0-5][0-9]
SECOND	[0-5][0-9]
MICROSEC	[0-9]{6}
BYTE	[0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]
IP	{BYTE}\.{BYTE}\.{BYTE}\.{BYTE}
PORT	[0-9]|[1-9][0-9]|[1-9][0-9][0-9]|[1-9][0-9][0-9][0-9]|[1-6][0-5][0-9][0-9][0-9]|66[0-4][0-9][0-9]|665[0-2][0-9]|6653[0-5]
SIZE	[0-9]+

DIGIT	[0-9]
WRONGIP {DIGIT}{1,3}\.{DIGIT}{1,3}\.{DIGIT}{1,3}\.{DIGIT}{1,3}
WRONGPORT {DIGIT}+

%{
int line_num = 0;
%}

%%

^{HOUR}	{ printf("%s", yytext); }
^{DIGIT}+	{ printf("\x1B[31m%s\x1B[0m", yytext); }
^:.*$	{ printf("\x1B[31m%s %d\x1B[0m", "Brak godziny, linia", line_num); line_num++; }

: { printf(":"); }

{MINUTE}	{ printf("%s", yytext); }
{DIGIT}+	{ printf("\x1B[31m%s\x1B[0m", yytext); }
:.*$	{ printf("\x1B[31m%s %d\x1B[0m", "Brak minut, linia", line_num); line_num++; }

: { printf(":"); }

{SECOND}	{ printf("%s", yytext); }
{DIGIT}+	{ printf("\x1B[31m%s\x1B[0m", yytext); }
\..*$	{ printf("\x1B[31m%s %d\x1B[0m", "Brak sekund, linia", line_num); line_num++;}

\.{MICROSEC}	{}
\.{DIGIT}+.*$:	{ printf("\x1B[31m%s\x1B[0m", "Niepoprawne milisekundy"); }

" IP "{IP}(\.{PORT})?" > "{IP}(\.{PORT})?.*("("{SIZE}")")?.*$			{ printf("%s", yytext); line_num++; }

%%

int main(int argc, char **argv)
{
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
    else
        yyin = stdin;

    yylex();
    return 0;
}
