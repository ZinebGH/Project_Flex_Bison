# Makefile 

# $@ : the current target
# $^ : the current prerequisites
# $< : the first current prerequisite

CC=gcc
CFLAGS=-Wall
LDFLAGS=-Wall -lfl -ly
EXEC=as


all: $(EXEC) clean

$(EXEC): y.tab.o lex.yy.o
	$(CC) -o $@ $^ $(LDFLAGS)


$(EXEC).tab.c $(EXEC).tab.h : $(EXEC).y
	bison -d $(EXEC).y


lex.yy.c: $(EXEC).lex $(EXEC).tab.h 
	  flex $(EXEC).lex

y.tab.o: $(EXEC).tab.c
	$(CC) -o $@ -c $< $(CFLAGS)

lex.yy.o: lex.yy.c
	$(CC) -o $@ -c $< $(CFLAGS)

clean:
	rm -f lex.yy.* *.tab.* 
