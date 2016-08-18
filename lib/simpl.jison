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
[\n]+                  return 'NEWLINE';

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

/* Comparison */
"=="                   return '==';
"!="                   return '!=';
"<="                   return '<=';
">="                   return '>=';
"<"                    return '<';
">"                    return '>';

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

/* Keywords */
"=>"                   return '=>';
"if"                   return 'if';
"elif"                 return 'elif';
"else"                 return 'else';
"def"                  return 'def';
"return"               return 'return';
"and"                  return 'and';
"not"                  return 'not';
"or"                   return 'or';
"in"                   return 'in';

<<EOF>>               return 'EOF';

/* Generic tokens */
[0-9]+("."[0-9]+)?\b   return 'NUMBER';
"\"".+"\""             return 'STRING';
[a-zA-Z_][a-zA-Z0-9_]* return 'IDENTIFIER';

/lex

%left LAMDBA
%left CONDEXP
%left ','
%left 'or'
%left 'and'
%left UBINNEGATE
%left '>' '<' '>=' '<=' '==' '!=' '==' '!=' 'in' NOTIN
%left '&' '|'
%left '+' '-'
%left '*' '/' '%'
%left '^'
%left UMINUS UNEGATE


%start expressions

%% /* language grammar */

expressions
/*
    : suite_inner EOF
        {return ast.createProgramNode($1);}
*/
    : e NEWLINE EOF
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
    | e 'and' e
        {$$ = ast.createBinopNode($1, 'and', $3);}
    | e 'or' e
        {$$ = ast.createBinopNode($1, 'or', $3);}
    | e 'in' e
        {$$ = ast.createBinopNode($1, 'in', $3);}
    | 'not' e %prec UBINNEGATE
        {$$ = ast.createUnopNode('not', $2);}
    | '!' e %prec UNEGATE
        {$$ = ast.createUnopNode('!', $2);}
    | '-' e %prec UMINUS
        {$$ = ast.createUnopNode('-', $2);}
    | 'def' '(' paramlist ')' suite %prec LAMDBA
        {$$ = ast.createLambdaNode($3, $5);}
    ;

explist
    : e
        {$$ = [$1];}
    | explist ',' e
        {$$ = $1; $$.push($3);}
    | %empty
        {$$ = [];}
    ;

paramlist
    : IDENTIFIER
        {$$ = [$1];}
    | paramlist ',' IDENTIFIER
        {$$ = $1; $$.push($3);}
    | %empty
        {$$ = [];}
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

suite_inner
    : simple_statement
        {$$ = [$1];}
    | suite_inner ';' simple_statement
        {$$ = $1; $$.push($3);}
    | suite_inner NEWLINE simple_statement
        {$$ = $1; $$.push($3);}
    | compound_statement
        {$$ = [$1];}
    | suite_inner NEWLINE compound_statement
        {$$ = $1; $$.push($3);}
    ;

suite
    : '{' suite_inner '}'
        {$$ = $2;}
    ;

if_statement
    : 'if' e suite
        {$$ = ast.createIfNode($3, $2);}
    | if_statement 'elif' e suite
        {$$ = ast.updateIfNode($4, $3, $1);}
    ;

compound_statement
    : if_statement
    | 'while' e suite
        {$$ = ast.createWhileNode($2, $3);}
    | 'for' explist ':' explist suite
        {$$ = ast.createForNode($2, $4, $5);}
    | 'def' IDENTIFIER '(' paramlist ')' suite
        {$$ = ast.createFunctionNode($2, $4, $6);}
    ;
