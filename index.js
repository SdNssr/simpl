const parser = require("./lib/simpl.js").parser;
const prettyjson = require('prettyjson');
const escodegen = require('escodegen');
const compile = require('./lib/codegen.js');

var content = '';

process.stdin.resume();

process.stdin.on('data', (buf) => {
    content += buf.toString(); 
});

process.stdin.on('end', () => {
    const program = parser.parse(content);
    console.log(prettyjson.render(program));
    console.log(escodegen.generate(compile(program)));
});

