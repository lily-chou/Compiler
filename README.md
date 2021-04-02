# Compiler
Implement a subset of LISP.

1. Syntax Validation
    >Print “syntax error” when parsing invalid syntax
  
2. Print	
    >  Print number
3. Numerical Operations
    > numerical operations such as +, -, *, /
4. Logical Operations	
    > logical operationssuch as and, or, not
5. if Expression
    > if else 
6. Variable Definition
    >define a variable
7. Function	
    > declare and call an anonymous function
8. Named Function
    >declare and call a named function


## **Exeuction Order**
* bison -d -o y.tab.c final.y<br>
* gcc -c -g -I.. y.tab.c<br>
* flex -o lex.yy.c final.l<br>
* gcc -c -g -I.. lex.yy.c<br>
* gcc -o final y.tab.o lex.yy.o -ll<br>
* ./final < example.lsp
