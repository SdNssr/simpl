const parser = require("./lib/simpl.js").parser;

var content = '';

process.stdin.resume();

process.stdin.on('data', (buf) => {
    content += buf.toString(); 
});

process.stdin.on('end', () => {
    console.log(JSON.stringify(parser.parse(content), null, 2))
});

