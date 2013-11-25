PROG = slonka

all : ${PROG}

lex.yy.c: ${PROG}.l
	flex ${PROG}.l
        
${PROG}: lex.yy.c
	gcc -o ${PROG} lex.yy.c -lfl

test: all
	./${PROG} < test-log
	#./${PROG} < test_small.txt
