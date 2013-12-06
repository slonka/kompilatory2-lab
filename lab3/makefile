PROG = slonka
CC = g++
BFLAGS = 

.PHONY: test clean help

#change to release to get default release
default: debug

all: ${PROG}
release: ${PROG}

debug: CC += -DDEBUG=1 -g
debug: BFLAGS += --debug
debug: ${PROG}

${PROG}.tab.c: ${PROG}.y
	bison $(BFLAGS) -d ${PROG}.y

lex.yy.c: ${PROG}.l
	flex ${PROG}.l
        
${PROG}: ${PROG}.tab.c lex.yy.c
	$(CC) -o ${PROG}.out ${PROG}.tab.c lex.yy.c ${PROG}.tab.h -lfl

test:
	./${PROG}.out < ${PROG}.test

clean:
	rm -rf *.tab.c *.tab.h lex.yy.c *.out

help:
	echo "Usage: make all PROG=nazwa_programu"

