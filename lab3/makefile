PROG = slonka

all : ${PROG} 

${PROG}.tab.c: ${PROG}.y
	bison -d ${PROG}.y

lex.yy.c: ${PROG}.l
	flex ${PROG}.l
        
${PROG}: ${PROG}.tab.c lex.yy.c
	g++ -o ${PROG}.out ${PROG}.tab.c lex.yy.c ${PROG}.tab.h -lfl

test: all
	./${PROG}.out < ${PROG}.test

clean:
	rm -rf *.tab.c *.tab.h lex.yy.c *.out

help:
	echo "Usage: make all PROG=nazwa_programu"
