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
        type: 'number',
        value: Number(val)
    }),
    createStringNode: (val) => ({
        type: 'string',
        value: String(val)
    }),
    createIdentifierNode: (val) => ({
        type: 'identifier',
        value: String(val)
    }),
    createUnopNode: (right, op) => ({
        type: 'binop',
        right, op,
    }),
    createBinopNode: (left, op, right) => ({
        type: 'binop',
        left, right, op,
    }),
    createEmptyExpListNode: () => ({
        type: 'explist',
        expressions: [],
    }),
    createExpListNode: (arg) => ({
        type: 'explist',
        expressions: [arg],
    }),
    updateExpListNode: (left, right) => {
        left.expressions.push(right);
        return left;
    },
    createFuncCallNode: (func, args) => ({
        type: 'func_call',
        func, args,
    }),
    createIndexNode: (indexable, index) => ({
        type: 'index',
        index, indexable,
    }),
    createListNode: (vals) => ({
        type: 'list', vals,
    }),
    createDictNode: (vals) => ({
        type: 'dict', vals,
    }),
    createStatementListNode: (stmt) => ({
        type: 'stmt_list',
        statements: [stmt],
    }),
    updateStatementListNode: (program, stmt) => {
        program.statements.push(stmt);
        return program;
    },
    createExpressionStatement: (expressions) => ({
        type: 'expression_stmt', expressions,
    }),
    createAssignmentStatement: (lhs, rhs) => ({
        type: 'assignment_stmt', lhs, rhs,
    }),
    createReturnStatement: (expressions) => ({
        type: 'return_stmt', expressions,
    }),
    createSimpleStatement: (name) => ({
        type: 'simple_stmt', name,
    }),
    createSliceNode: (start, end) => ({
        type: 'slice', start, end,
    }),
}