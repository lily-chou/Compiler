%{
#include "y.tab.h"

%}

digit [0-9]
number 0|[1-9]{digit}*|-[1-9]{digit}*
letter [a-z]
ID {letter}({letter}|{digit}|-)*

%%
{number}  {yylval.ival=atoi(yytext); return(INUMBER);}
"#t"      {yylval.ival=1; return (ITRUE);}
"#f"      {yylval.ival=0; return (IFALSE);}
"print-num"  {return (IPRINTN);}
"print-bool" {return (IPRINTB);}

"+"		{return (IPLUS);}
"-"		{return (IMINUS);}
"*"		{return (IMUL);}
"/"		{return (IDIV);}
"mod"	{return (IMOD);}
">"		{return (IBIG);}
"<"		{return (ISMALL);}
"="		{return (IEQUAL);}

"and"	{return (IAND);}
"or"	{return (IOR);}
"not"	{return (INOT);}

"define" {return (IDEFINE);}
"fun"	 {return (IFUN);}
"if"	 {return (IF);}

{ID}     {yylval.cval=strdup(yytext); return (ID);}

"("|")"  {return (yytext[0]);}
"\n"     {;}
[\t]+    {;}
.        {;}

%%

