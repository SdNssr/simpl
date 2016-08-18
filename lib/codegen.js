const transformTable = {
    'List': transformList,
    'Literal': passThrough,
    'Identifier': transformIdentifierNode,
    'UnaryExpression': transformUnaryExpression,
    'BinaryExpression': transformBinaryExpression,
};

function transformNode(node) {
    return transformTable[node.type](node);
}

function passThrough(node) {
    return node;
}

function transformIdentifierNode(node) {
    return {
        type: 'MemberExpression',
        computed: true,
        object: {
            type: 'Identifier',
            name: '$simpl_scope'
        },
        property: {
            type: 'Literal',
            value: node.name,
        },
    }
}

const unaryOperatorTable = {
    '!': '~',
    '-': '-',
    'not': '!',
}

function transformUnaryExpression(node) {
    return {
        prefix: true,
        type: 'UnaryExpression',
        argument: transformNode(node.argument),
        operator: unaryOperatorTable[node.operator],
    }
}

const mappableBinaryOperators = {
    '&' : '&',
    '|' : '|',
    '==': '===',
    '!=': '!==',
    '>' : '>',
    '<' : '<',
    '>=': '>=',
    '<=': '<=',
    '+' : '+',
    '-' : '-',
    '*' : '*',
    '/' : '/',
    '%' : '%',
};

function transformBinaryExpression(node) {
    const operator = node.operator;
    const left = transformNode(node.left);
    const right = transformNode(node.right);

    if (mappableBinaryOperators[operator]) {
        return {
            type: 'BinaryExpression',
            operator: mappableBinaryOperators[operator],
            left: left,
            right: right,
        }
    }
    else if (operator == 'and') {
        return {
            type: 'RelationalExpression',
            operator: '&&',
            left: left,
            right: right,
        }
    }
    else if (operator == 'or') {
        return {
            type: 'RelationalExpression',
            operator: '||',
            left: left,
            right: right,
        }
    }
    else if (operator == 'in') {
        return {
            type: 'CallExpression',
            callee: {
                type: 'MemberExpression',
                computed: false,
                object: right,
                property: {
                    type: 'Identity',
                    name: 'indexOf',
                }
            },
            arguments: [
                left,
            ],
        }
    }
}

function transformList(node) {
    return {
        type: 'ArrayExpression',
        elements: node.vals.map(transformNode),
    }
}

module.exports = transformNode;