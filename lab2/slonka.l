%{
/* slonka.l
   
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

%%

^{HOUR}:{MINUTE}:{SECOND}\.{MICROSEC}" IP "{IP}(\.{PORT})?" > "{IP}(\.{PORT})?.*("("{SIZE}")")?.*$			{ printf("dobrze"); }
^{DIGIT}{2}:{MINUTE}:{SECOND}\.{MICROSEC}" IP "{IP}(\.{PORT})?" > "{IP}(\.{PORT})?.*("("{SIZE}")")?.*$			{ printf("godzina nie z zakresu"); }
^{HOUR}:{DIGIT}{2}:{SECOND}\.{MICROSEC}" IP "{IP}(\.{PORT})?" > "{IP}(\.{PORT})?.*("("{SIZE}")")?.*$			{ printf("minuta nie z zakresu"); }
^{HOUR}:{MINUTE}:{DIGIT}:{2}\.{MICROSEC}" IP "{IP}(\.{PORT})?" > "{IP}(\.{PORT})?.*("("{SIZE}")")?.*$			{ printf("sekunda nie z zakresu"); }
^{HOUR}:{MINUTE}:{SECOND}\.{MICROSEC}" IP "{WRONGIP}(\.{PORT})?" > "{IP}(\.{PORT})?.*("("{SIZE}")")?.*$			{ printf("adres zrodlowy ip nie z zakresu"); }
^{HOUR}:{MINUTE}:{SECOND}\.{MICROSEC}" IP "{IP}(\.{PORT})?" > "{WRONGIP}(\.{PORT})?.*("("{SIZE}")")?.*$			{ printf("adres docelowy ip nie z zakresu"); }

.*	{ printf("not a valid line\n");}


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
