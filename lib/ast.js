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

module.exports = {
    createNumberNode: (val) => ({
        type: 'Literal',
        value: Number(val)
    }),
    createStringNode: (val) => ({
        type: 'Literal',
        value: String(val).slice(1, -1)
    }),
    createIdentifierNode: (val) => ({
        type: 'Identifier',
        name: String(val)
    }),
    createUnopNode: (argument, operator) => ({
        type: 'UnaryExpression',
        argument, operator,
    }),
    createBinopNode: (left, operator, right) => ({
        type: 'BinaryExpression',
        left, right, operator,
    }),
    createFuncCallNode: (function_, arguments) => ({
        type: 'FunctionCall',
        function_, arguments,
    }),
    createIndexNode: (into, index) => ({
        type: 'Index',
        index, into,
    }),
    createListNode: (vals) => ({
        type: 'List', vals,
    }),
    createDictNode: (vals) => ({
        type: 'Dictionary', vals,
    }),
    createExpressionStatement: (expressions) => ({
        type: 'ExpressionStatement', expressions,
    }),
    createAssignmentStatement: (lhs, rhs) => ({
        type: 'AssignmentStatement', lhs, rhs,
    }),
    createReturnStatement: (expressions) => ({
        type: 'ReturnStatement', expressions,
    }),
    createSimpleStatement: (name) => ({
        type: 'SimpleStatement', name,
    }),
    createSliceNode: (start, end) => ({
        type: 'Slice', start, end,
    }),
    createIfNode: (stmt, cond) => ({
        type: 'IfStatement',
        statements: [stmt],
        conditions: [cond],
    }),
    updateIfNode: (stmt, cond, prev) => {
        prev.statements.push(stmt);
        prev.conditions.push(cond);
        return prev;
    },
    createWhileNode: (condition, statements) => ({
        type: 'WhileStatement',
        condition, statements,
    }),
    createForNode: (lhs, rhs, statements) => ({
        type: 'ForStatement', lhs, rhs, statements,
    }),
    createFunctionNode: (name, parameters, statements) => ({
        type: 'FunctionStatement', name, parameters, statements,
    }),
    createLambdaNode: (parameters, statements) => ({
        type: 'FunctionDefinition', parameters, statements,
    }),
    createProgramNode: (statements) => ({
        type: 'Program', statements,
    }),
}