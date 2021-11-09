parser: y.tab.c lex.yy.c
	gcc -o parser y.tab.c
y.tab.c: parser.y lex.yy.c
	yacc parser.y
lex.yy.c: lexer.l
	lex lexer.l
clean:
	rm -f lex.yy.c y.tab.c parser