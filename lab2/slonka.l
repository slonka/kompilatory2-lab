%{
/* slonka.l
#define KRED "\x1B[31m"
#define KNRM "\x1B[0m"
*/
%}

HOUR	[0-1][0-9]|2[0-4]
MINUTE	[0-5][0-9]
SECOND	[0-5][0-9]
MICROSEC	[0-9]{6}
BYTE	[0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]
IP	{BYTE}\.{BYTE}\.{BYTE}\.{BYTE}
PORT	[0-9]|[1-9][0-9]|[1-9][0-9][0-9]|[1-9][0-9][0-9][0-9]|[0-5][0-9][0-9][0-9][0-9]|6[0-5][0-9][0-9][0-9]|66[0-4][0-9][0-9]|665[0-2][0-9]|6653[0-5]
SIZE	[0-9]+

DIGIT	[0-9]
WRONGIP {DIGIT}{1,3}\.{DIGIT}{1,3}\.{DIGIT}{1,3}\.{DIGIT}{1,3}
WRONGPORT {DIGIT}+

OPTIONS "mss "{DIGIT+}|"nop"|"sackOK"


%option yylineno

%x MSEC
%x IP_FROM
%x PORT_FROM
%x IP2_DELIM
%x IP_TO
%x PORT_TO
%x BYTES_DELIM
%x BYTES_END
%x BYTES_SENT
%x IP_DELIM
%x END
%x NEWLINE
%x GO_TO_NEXT_LINE

%%

^{HOUR}:{MINUTE}:{SECOND}	{ printf("%s", yytext); BEGIN(MSEC); }
^{DIGIT}{2}:{DIGIT}{2}:{DIGIT}{2}	{ printf("\x1B[31m%s\x1B[0m", yytext); BEGIN(MSEC); }

<MSEC>\.{MICROSEC}	{ BEGIN(IP_DELIM); }

<IP_DELIM>" IP "	{ BEGIN(IP_FROM); }

<IP_FROM>{IP}	{ printf(" from %s", yytext); BEGIN(PORT_FROM); }
<IP_FROM>{WRONGIP}	{ printf(" from \x1B[31m%s\x1B[0m", yytext); BEGIN(PORT_FROM); }

<PORT_FROM>(\.{PORT})?" > "	{ printf(" to "); BEGIN(IP_TO); }
<PORT_FROM>(\.{WRONGPORT})?" > " { printf(" \x1B[31mwrong port\x1B[0m to "); BEGIN(IP_TO); }

<IP_TO>{IP}	{ printf("%s", yytext); BEGIN(PORT_TO); }
<IP_TO>{WRONGIP}	{ printf("%s", yytext); BEGIN(PORT_TO); }

<PORT_TO>(\.{PORT})?:	{ BEGIN(BYTES_DELIM); }
<PORT_TO>(\.{WRONGPORT})?: { BEGIN(BYTES_DELIM); }

<BYTES_DELIM>" "[SPRF\.]" "{DIGIT}+":"{DIGIT}+"("	{BEGIN(BYTES_SENT);}
<BYTES_DELIM>" icmp "{DIGIT}+": echo request seq "{DIGIT}+	{BEGIN(NEWLINE);} 
<BYTES_DELIM>" icmp "{DIGIT}+": echo reply seq "{DIGIT}+	{BEGIN(NEWLINE);} 
<BYTES_DELIM>" icmp "{DIGIT}+": time exceeded in-transit"	{BEGIN(NEWLINE);} 
<BYTES_DELIM>" ." { BEGIN(END); }

<BYTES_SENT>{DIGIT}+	{ printf(" %s bytes", yytext); BEGIN(BYTES_END); }

<BYTES_END>")"	{ BEGIN(END); }

<END>(" ack "{DIGIT}+)?(" win "{DIGIT}+)?(" <"(OPTIONS",")*OPTIONS">")?	{ BEGIN(NEWLINE); }
<END>(" ack "{DIGIT}+)?(" win "{DIGIT}+)?(" <".*">")?	{ BEGIN(NEWLINE); }

<NEWLINE>\n	{ printf("\n"); BEGIN(0); }

<*>.	{ printf(" - syntax error line %d\n", yylineno); BEGIN(GO_TO_NEXT_LINE); }

<GO_TO_NEXT_LINE>.*$	{ BEGIN(0); }


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


