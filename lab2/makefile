PROG = slonka

all : ${PROG}

lex.yy.c: ${PROG}.l
	flex ${PROG}.l
        
${PROG}: lex.yy.c
	gcc -o ${PROG} lex.yy.c -lfl

test: all
	#./slonka < test_1.txt
	./slonka < test_small.txt
