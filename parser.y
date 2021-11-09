%{
#include <stdio.h>
int yylex();
int yyerror();
%}

%token FUNCTION
%token ARRAY
%nonassoc ASSIGN_OPERATOR
%token EQUALITY_OPERATOR
%token HASHTAG
%left AND
%left OR
%token ELSE
%token LP
%token RP
%token LCB
%token RCB
%token COMMA
%token DOT
%token INT
%token FLOAT
%token NEWLINE
%token IF
%token ELIF
%token WHILE
%token PRINT
%token INPUT
%token FOR
%token TRUE
%token FALSE
%token BOOLEAN
%token STRING
%token FUNCTION_NAME
%token IDENTIFIER
%token COMMENT
%left MOD
%left CONCAT_OPERATOR
%left ADD_OPERATOR
%left SUB_OPERATOR
%left DIV_OPERATOR
%left MULP_OPERATOR
%left POW_OPERATOR
%token CONNECT_WIFI
%token TURN_ON_NOZZLE
%token TURN_OFF_NOZZLE
%token READ_HEADING
%token READ_INCLATION
%token READ_ALTITUDE
%token READ_TEMPERATURE
%token FORWARD
%token BACKWARD
%token UP
%token DOWN
%token MOVE
%token STOP
%token LEFT
%token RIGHT
%token TURN
%token NOT_EQUAL_OPERATOR
%token LESS_THAN_OPERATOR
%token GREATER_THAN_OPERATOR
%token LESS_AND_EQUAL_OPERATOR
%token GREATER_AND_EQUAL_OPERATOR
%token LB
%token RB
%token SEMI_COLON NOT LETTER
%start program
%%
program: statementsWithSemiColon;
statementsWithSemiColon: statementWithSemiColon 
	| statementsWithSemiColon statementWithSemiColon ;

statementWithSemiColon: statement SEMI_COLON
	| loop_statement
	| if_statement
	| COMMENT
	| function_declaration;

statement: assignment_statement  
	| output_statement 
	| drone_statement 
	| function_call;

assignment_statement: array_get_index ASSIGN_OPERATOR expression 
	| parameter_list ASSIGN_OPERATOR expression 
	| array_declaration;

array_declaration: ARRAY IDENTIFIER ASSIGN_OPERATOR LCB array_expression_list RCB
	| ARRAY IDENTIFIER ASSIGN_OPERATOR LCB RCB;

array_expression_list: array_expression_list COMMA array_expression 
	| array_expression;

array_expression: LCB array_expression_list RCB 
	| expression;

loop_statement: while_statement 
	| for_statement;

for_statement: FOR LP assignment_statement SEMI_COLON expression SEMI_COLON assignment_statement RP block;

while_statement: WHILE LP expression RP block;

parameter_list: parameter_list COMMA IDENTIFIER 
	| IDENTIFIER;

expression_list: expression_list COMMA expression 
	| expression;

expression: boolean_expression;

boolean_expression: or_expression equality_operator or_expression 
	| or_expression;

or_expression: or_expression OR and_expression 
	| and_expression;

and_expression: and_expression AND not_expression 
	| not_expression;

not_expression: NOT boolean_identity 
	| boolean_identity;

boolean_identity: relational_expression 
	| boolean_words;

boolean_words: TRUE 
	| FALSE;

relational_expression: arithmetic_expression relational_operator arithmetic_expression 
	| arithmetic_expression;

arithmetic_expression: arithmetic_expression precedence_third_operator arithmetic_term 
	| arithmetic_term;

arithmetic_term: arithmetic_term precedence_second_operator arithmetic_factor 
	| arithmetic_factor;

arithmetic_factor: arithmetic_factor precedence_first_operator arithmetic_minor_expression 
	| arithmetic_minor_expression;

arithmetic_minor_expression: LP expression RP 
	| arithmetic_identity;

arithmetic_identity: turn_direction
        | move_direction
	| IDENTIFIER  
	| INT 
	| FLOAT 
	| STRING 
	| function_call 
	| array_get_index 
	| drone_expression 
	| input_expression;

input_expression: INPUT LP RP 
	| INPUT LP STRING RP;

array_get_index: IDENTIFIER get_index_list;

get_index_list: get_index_list get_index 
	| get_index;

get_index: LB expression RB;

precedence_first_operator: POW_OPERATOR;

precedence_second_operator: MULP_OPERATOR 
		| DIV_OPERATOR 
	| MOD;

precedence_third_operator: ADD_OPERATOR 
	| SUB_OPERATOR;

block: LCB statementsWithSemiColon RCB;

relational_operator: GREATER_THAN_OPERATOR 
	| LESS_THAN_OPERATOR 
	| LESS_AND_EQUAL_OPERATOR 
	| GREATER_AND_EQUAL_OPERATOR;

equality_operator: EQUALITY_OPERATOR 
	| NOT_EQUAL_OPERATOR;

if_statement: if_then_else_statement 
	| if_without_else_statement
	| if_elif_statement
	| if_elif_else_statement;
if_then_else_statement: IF LP expression RP block ELSE block;

if_without_else_statement: IF LP expression RP block;

if_elif_else_statement: IF LP expression RP block ELIF LP expression RP block ELSE block;

if_elif_statement: IF LP expression RP block ELIF LP expression RP block;

function_declaration: FUNCTION LB parameter_list RB ASSIGN_OPERATOR FUNCTION_NAME LP parameter_list RP block 
	| FUNCTION ASSIGN_OPERATOR FUNCTION_NAME LP parameter_list RP block;

output_statement: PRINT LP expression RP;

drone_statement: connect_wifi 
	| turn_on_nozzle 
	| turn_off_nozzle  
	| move  
	| turn 
	| stop;

connect_wifi: CONNECT_WIFI LP RP;

turn_on_nozzle: TURN_ON_NOZZLE LP RP;

turn_off_nozzle: TURN_OFF_NOZZLE LP RP;

move: MOVE LP expression RP;

turn: TURN LP expression RP;

stop: STOP LP RP;

drone_expression: read_heading 
	| read_altitude 
	| read_temp;

read_heading: READ_HEADING LP RP;

read_altitude: READ_ALTITUDE LP RP;

read_temp: READ_TEMPERATURE LP RP;

function_call: FUNCTION_NAME LP expression_list RP 
	| FUNCTION_NAME LP RP;

move_direction: FORWARD
	| BACKWARD
	| UP
	| DOWN;
turn_direction: LEFT 
	| RIGHT;



%%
#include "lex.yy.c"
extern int lineCount;
int yyerror(char *s) {
 printf("Syntax error on line %d!\n", lineCount);
}
int main() {
 if (yyparse() == 0)
  printf("Input program is valid.\n");
 return 0;
}