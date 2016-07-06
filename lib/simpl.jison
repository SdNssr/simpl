/*
 * Copyright (c) 2016 Saad Nasser (SdNssr)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in 
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
 * IN THE SOFTWARE.
 */

%{
    ast = require('./ast.js');
%}

%lex

%%
[ \t]+                 /* skip whitespace */
[\n]                   return 'NEWLINE';

/* Generic tokens */
[0-9]+("."[0-9]+)?\b   return 'NUMBER';
"\"".+"\""             return 'STRING';
[a-zA-Z_][a-zA-Z0-9_]* return 'IDENTIFIER';

/* Delimiters */
"{"                    return '{';
"}"                    return '}';
"["                    return '[';
"]"                    return ']';
"("                    return '(';
")"                    return ')';
":"                    return ':';
";"                    return ';';
","                    return ',';

/* Operators */
"*"                    return '*';
"/"                    return '/';
"-"                    return '-';
"+"                    return '+';
"^"                    return '^';
"%"                    return '%';
"&"                    return '&';
"|"                    return '|';
"!"                    return '!';
"="                    return '=';
"."                    return '.';

/* Comparison */
"=="                   return '==';
"!="                   return '!=';
"<="                   return '<=';
">="                   return '>=';
"<"                    return '<';
">"                    return '>';

/* Keywords */
"=>"                   return '=>';
"if"                   return 'if';
"else"                 return 'else';
"def"                  return 'def';
"return"               return 'return';
"and"                  return 'and';
"not"                  return 'not';
"or"                   return 'or';

<<EOF>>               return 'EOF';

/lex

%left ','
%left '&' '|'
%left '==' '!='
%left '>' '<' '>=' '<='
%left '+' '-'
%left '*' '/' '%'
%left '^'
%left UMINUS UNEGATE


%start expressions

%% /* language grammar */

expressions
    : program EOF
        {return $1;}
    ;

atom
    : NUMBER
        {$$ = ast.createNumberNode(yytext);}
    | STRING
        {$$ = ast.createStringNode(yytext);}
    | IDENTIFIER
        {$$ = ast.createIdentifierNode(yytext);}
    | '(' e ')'
        {$$ = $2;}
    | '[' explist ']'
        {$$ = ast.createListNode($2);}
    ;

slice
    : e ':' e
        {$$ = ast.createSliceNode($1, $3);}
    | ':' e
        {$$ = ast.createSliceNode(undefined, $2);}
    | e ':'
        {$$ = ast.createSliceNode($1, undefined);}
    ;

postfix_e
    : atom
    | postfix_e '[' explist ']'
        {$$ = ast.createIndexNode($1, $3);}
    | postfix_e '[' slice ']'
        {$$ = ast.createIndexNode($1, $3);}
    | postfix_e '(' explist ')'
        {$$ = ast.createFuncCallNode($1, $3);}
    | postfix_e '.' IDENTIFIER
        {$$ = ast.createBinopNode($1, '.', $3);}
    ;
e
    : postfix_e
    | e '&' e
        {$$ = ast.createBinopNode($1, '&', $3);}
    | e '|' e
        {$$ = ast.createBinopNode($1, '|', $3);}
    | e '==' e
        {$$ = ast.createBinopNode($1, '==', $3);}
    | e '!=' e
        {$$ = ast.createBinopNode($1, '!=', $3);}
    | e '>' e
        {$$ = ast.createBinopNode($1, '>', $3);}
    | e '<' e
        {$$ = ast.createBinopNode($1, '<', $3);}
    | e '>=' e
        {$$ = ast.createBinopNode($1, '>=', $3);}
    | e '<=' e
        {$$ = ast.createBinopNode($1, '<=', $3);}
    | e '+' e
        {$$ = ast.createBinopNode($1, '+', $3);}
    | e '-' e
        {$$ = ast.createBinopNode($1, '-', $3);}
    | e '*' e
        {$$ = ast.createBinopNode($1, '*', $3);}
    | e '/' e
        {$$ = ast.createBinopNode($1, '/', $3);}
    | e '%' e
        {$$ = ast.createBinopNode($1, '%', $3);}
    | e '^' e
        {$$ = ast.createBinopNode($1, '^', $3);}
    | '!' e %prec UNEGATE
        {$$ = ast.createUnopNode('!', $2);}
    | '-' e %prec UMINUS
        {$$ = ast.createUnopNode('-', $2);}
    ;

explist
    : e
        {$$ = ast.createExpListNode($1);}
    | explist ',' e
        {$$ = ast.updateExpListNode($1, $3);}
    | %empty
        {$$ = ast.createEmptyExpListNode();}
    ;

target_list
    : target
    | target ',' target
    ;

target
    : IDENTIFIER
    | '(' target_list ')'
    | '[' target_list ']'
    | e '.' IDENTIFIER
    | e '[' e ']'
    ;

simple_statement
    : "pass"
        {$$ = ast.createSimpleStatement('pass');}
    | "break"
        {$$ = ast.createSimpleStatement('break');}
    | "continue"
        {$$ = ast.createSimpleStatement('continue');}
    | "next"
        {$$ = ast.createSimpleStatement('next');}
    | "return" explist
        {$$ = ast.createReturnStatement($2);}
    | explist
        {$$ = ast.createExpressionStatement($1);}
    | explist '=' explist
        {$$ = ast.createAssignmentStatement($1, $3);}
    ;

suite_single
    : simple_statement
        {$$ = ast.createStatementListNode($1);}
    | suite_single ';' single_statement
        {$$ = ast.updateStatementListNode($1, $3);}
    ;

suite_multiple
    : simple_statement
        {$$ = ast.createStatementListNode($1);}
    | suite_multiple ';' single_statement
        {$$ = ast.updateStatementListNode($1, $3);}
    | suite_multiple NEWLINE single_statement
        {$$ = ast.updateStatementListNode($1, $3);}
    ;

suite
    : suite_single
        {$$ = $1;}
    | '{' suite_multiple '}'
        {$$ = $2;}
    ;

if_statement
    : 'if' e suite
    | if_statement 'elif' e suite
    ;

compound_statement
    : 'for' exprlist 'in' exprlist suite
    | 'def' IDENTIFIER '(' explist ')' suite
    | if_statement
    | if_statement 'else' suite
    ;

program
    : simple_statement
        {$$ = ast.createStatementListNode($1);}
    | program ';' simple_statement
        {$$ = ast.updateStatementListNode($1, $3);}
    | program NEWLINE simple_statement
        {$$ = ast.updateStatementListNode($1, $3);}
    ;
