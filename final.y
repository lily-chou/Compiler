%{
#include<stdio.h> 
#include<stdlib.h>

#define SIZE 100
int hashindex=-1;
int anonyindex=-1;
int funindex=-1;
int a_fun=0;
int c_fun=0;

void yyerror(const char *message);

typedef struct tree{
	char type;
	int num;
	int checkbool;
	int isfun;
	char *element;
	struct tree*left;
	struct tree*right;
	struct tree*test;
}tree;

typedef struct map{
	int data;
	char *key;
}map;

struct map* hasharray[SIZE];
struct map* anonyarray[20];
struct tree* funarray[20];

//problem 3
void calculate(tree *node){
  switch(node->type){
    case '+':
		node->num=node->left->num+node->right->num; 
		break;
    case '-':
		node->num=node->left->num-node->right->num; 
		break;
    case '*':
		node->num=node->left->num*node->right->num; 
		break;
    case '/':
		node->num=node->left->num/node->right->num; 
		break;
	case '%':
		node->num=node->left->num%node->right->num; 
		break;
	case '>':
		if(node->left->num>node->right->num)
			node->checkbool=1;
		else
			node->checkbool=0;
		break;
	case '<':
		if(node->left->num<node->right->num)
			node->checkbool=1;
		else
			node->checkbool=0;
		break;
	case '=':
		if(node->left->checkbool==0||node->right->checkbool==0){
			node->checkbool=0;
		}else if(node->left->num==node->right->num){
			//printf("%d\n",node->left->num);
			//printf("%d\n",node->right->num);
			node->num=node->left->num;
			node->checkbool=1;
		}else
			node->checkbool=0;
		break;
  }
}

//problem 4
void cal_logic(tree *node){
	switch(node->type){
		case '&':
			node->checkbool=node->left->checkbool & node->right->checkbool; 
		break;
		case '|':
			node->checkbool=node->left->num | node->right->checkbool; 
		break;
		case '!':
			node->checkbool=!node->left->checkbool; 
		break;
	}	
}

//problem 5
void cal_if(tree *node){
	if(node->test->checkbool==1)
		node->num=node->left->num;
	else 
		node->num=node->right->num;
}

//build tree
tree *maketree(tree *l,char op, tree *r){
	tree *node=(tree*)malloc(sizeof(tree));
	node->type=op;
	node->checkbool=1;
	node->left=l;
	node->right=r;
	node->isfun=0;
	if(node->type=='f')
		node->isfun=1;
	return node;
}

//build node
tree *makevalue(int n,char *in,char op){
	tree *node=(tree*)malloc(sizeof(tree));
	node->type=op;
	node->num=n;
	node->element=in;
	node->checkbool=-1;
	if(node->type=='b')
		node->checkbool=n;
	return node;
}

/************hasharray************/
void map_insert(char *inkey, int indata){
	map *node=(map*)malloc(sizeof(map));
	node->data=indata;
	node->key=inkey;
	hashindex+=1;
	hasharray[hashindex]=node;
}

map *map_search(char *inkey){
	int index=0;
	while(index<=hashindex){
		if(strcmp(hasharray[index]->key,inkey)==0){
			return hasharray[index];
		}
		index+=1;		
	}
	return NULL;
}

/************anonyarray************/
void anony_insert(char *inkey, int indata){
	map *node=(map*)malloc(sizeof(map));
	node->data=indata;
	node->key=inkey;
	anonyindex+=1;
	anonyarray[anonyindex]=node;
}

map *anony_search(char *inkey){
	int index=0;
	while(index<=anonyindex){
		if(strcmp(anonyarray[index]->key,inkey)==0){
			return anonyarray[index];
		}
		index+=1;		
	}
	return NULL;
}


/************funarray************/
tree *fun_search(char *inkey){
	int index=0;
	while(index<=funindex){
		if(strcmp(funarray[index]->element,inkey)==0){
			return funarray[index];
		}
		index+=1;		
	}
	return NULL;
}

//run tree
void runtree(tree *node){
	if(node==NULL)
		return;	
	if(node->type=='+' || node->type=='-' || node->type=='*' || node->type=='/' || node->type=='%' || node->type=='>' || node->type=='<' || node->type=='='){
		runtree(node->left);
		runtree(node->right);
		calculate(node);
	}else if(node->type=='&' || node->type=='|' || node->type=='!'){
		runtree(node->left);
		runtree(node->right);
		cal_logic(node);
	}else if (node->type=='d'){
		if(node->isfun==1)
			return;
		runtree(node->left);
		runtree(node->right);
		if(node->right->type!='f'){
			node->num=node->right->num;
			if(node->left!=NULL){
				node->left->num=node->num;
				map *tmp=(map*)malloc(sizeof(map)); 
				tmp=map_search(node->left->element);
				tmp->data=node->num;
			}
		}
	}else if(node->type=='v'){
		runtree(node->left);
		runtree(node->right);
		if(a_fun==0&&c_fun==0){
			map *tmp=(map*)malloc(sizeof(map)); 
			tmp=map_search(node->element);
			if(tmp==NULL){
				printf("syntax error\n"); 
				exit(0);
			};
			node->num=tmp->data;
		}
	}else if(node->type=='a'){
		a_fun=1;
		runtree(node->left->right);
		node->num=node->left->right->num;
	}else if(node->type=='i'){
		runtree(node->test);
		runtree(node->left);
		runtree(node->right);
		cal_if(node);
	}else{
		runtree(node->left);
		runtree(node->right);
	}
}

/************function combine the paramater and the input ************/
void find_value(tree *node1,tree *node2){
	if( node1==NULL && node2 == NULL ){
		return ;
	}else if((node1==NULL&&node2!=NULL)||(node1!=NULL&&node2==NULL)){
		printf ("syntax error\n");
		exit(0);
	}
	if(node1->type=='v'&&node2->type=='n'){
		anony_insert(node1->element,node2->num);
	}
	find_value(node1->left,node2->left);
}

void connect_value(tree *innode){
	if(innode==NULL)
		return ;
	connect_value(innode->left);
	connect_value(innode->right);
	if(innode->type=='v'){
		map *node=(map*)malloc(sizeof(map)); 
		node=anony_search(innode->element);
		if(node==NULL){
			printf("syntax error\n"); 
			return ;
		}
		innode->num=node->data;
	}
}


%}

%union{
	int ival;
	char *cval;
	struct tree *atree;
}

%token <ival> INUMBER ITRUE IFALSE
%token<cval> ID
%token IPRINTN IPRINTB IPLUS IMINUS IMUL IDIV IMOD IBIG ISMALL IEQUAL 
%token IAND IOR INOT IDEFINE IFUN IF
%type <atree>program stmt print_stmt exp num_op logical_op def_stmt variable
%type <atree>fun_exp if_exp fun_ids fun_body fun_call param fun_name stmts
%type <atree>exp_plus exp_mul exp_equ exp_and exp_or test_exp else_exp then_exp 
%left IBIG ISMALL IEQUAL
%left IPLUS IMINUS
%left IMUL IDIV IMODr
%left '(' ')'

%%
program:stmts 		{;}
    ;
stmt:exp			{$$=$1;}
    |def_stmt		{if($$->isfun==0)runtree($1);$$=$1;}
	|print_stmt		{$$=$1;}
	;
stmts:stmt stmts	{;}
     |stmt			{$$=$1;}
	 ;
print_stmt: '('IPRINTN exp')' 	{runtree($3);printf("%d\n",$3->num);} 
           |'('IPRINTB exp ')'	{runtree($3); if($3->checkbool==1)printf("#t\n"); else printf("#f\n");/*printf("%d\n",$3->num);maketree($3,'p',NULL);*/}
	;	   
exp:ITRUE		{$$=makevalue($1,'\0','b');}
	|IFALSE		{$$=makevalue($1,'\0','b');}
	|INUMBER	{$$=makevalue($1,'\0','n');}
	|variable	{$$=$1;}
	|num_op		{$$=$1;}
	|logical_op	{$$=$1;}
	|fun_exp	{$$=$1;}
	|fun_call	{$$=$1;}
	|if_exp		{$$=$1;}
	;
num_op:'('IPLUS exp exp_plus')'		{$$=maketree($3,'+',$4);}
	  |'('IMINUS exp exp')'			{$$=maketree($3,'-',$4);}
	  |'('IMUL exp exp_mul')'		{$$=maketree($3,'*',$4);}
	  |'('IDIV exp exp')'			{$$=maketree($3,'/',$4);}
	  |'('IMOD exp exp')'			{$$=maketree($3,'%',$4);}
	  |'('IBIG exp exp')'			{$$=maketree($3,'>',$4);}
	  |'('ISMALL exp exp')'			{$$=maketree($3,'<',$4);}
	  |'('IEQUAL exp exp_equ')'		{$$=maketree($3,'=',$4);}
	  ;
exp_plus:exp exp_plus	{$$=maketree($1,'+',$2);}
		|exp			{$$=$1;}
		;
exp_mul:exp exp_mul		{$$=maketree($1,'*',$2);}	
	   |exp				{$$=$1;}
	   ;
exp_equ:exp exp_equ		{$$=maketree($1,'=',$2);}
	   |exp				{$$=$1;}
	   ;
logical_op:'('IAND exp exp_and')'	{$$=maketree($3,'&',$4);}
		  |'('IOR exp exp_or')'		{$$=maketree($3,'|',$4);}
		  |'('INOT exp ')' 			{$$=maketree($3,'!',NULL);}
		  ;
exp_and:exp exp_and		{$$=maketree($1,'&',$2);}
	   |exp				{$$=$1;}
	   ;
exp_or:exp exp_or		{$$=maketree($1,'|',$2);}
	  |exp				{$$=$1;}
	  ;
def_stmt:'('IDEFINE variable exp')'		{$$=maketree($3,'d',$4);
										 if($4->type!='f'){
											map *tmp=(map*)malloc(sizeof(map)); 
											tmp=map_search($3->element);
											if(tmp==NULL){
												map_insert($3->element,$4->num);
											}else{
												printf("syntax error\n");
												exit(0);
											}
										 }else{
											funindex+=1; 
											$4->element=$3->element;
											funarray[funindex]=$4;
											$$->isfun=1;
										 } 
										}
		;
variable:ID				{$$=makevalue(0,$1,'v');}
		;
fun_exp:'('IFUN '('fun_ids ')'fun_body')'	 {$$=maketree($4,'f',$6);$$->num=$6->num;}
		;
fun_ids:variable fun_ids					 {$1->left=$2;$1->right=NULL;$$=$1;}
	   |variable							 {$$=$1;}
	   |									 {$$=NULL;}
	   ;
fun_body:exp								 {$$=$1;}
		;
fun_call:'('fun_exp param')'		{$$=maketree($2,'a',$3); find_value($2->left,$3);connect_value($2->right);anonyindex=-1;}
        |'('fun_name param')'		{$$=maketree($2,'c',$3);
									 tree *node=(tree*)malloc(sizeof(tree));
									 node=fun_search($2->element);
									 if(node==NULL){
										printf("syntax error\n");
										exit(0);
									 }
									 find_value(node->left,$3);
									 connect_value(node->right);
									 $$=node->right;
									 $$->isfun=2;
									 c_fun=1;
									}
		;
param:exp param		{$1->left=$2;$1->right=NULL;$$=$1;}
	 |exp			{$$=$1;}
	 |				{$$=NULL;}
	 ;
fun_name:variable	{$$=$1;}
		;
if_exp:'('IF test_exp then_exp else_exp')'	{$$=maketree($4,'i',$5); $$->test=$3; }
	  ;
test_exp:exp		{$$=$1;}
		;
then_exp:exp		{$$=$1;}
		;
else_exp:exp		{$$=$1;}
		;
%%

void yyerror (const char *message)
{
  printf ("syntax error\n");
}

int main(){
 yyparse();
 return 0;
}