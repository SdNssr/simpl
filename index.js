const parser = require("./lib/simpl.js").parser;

console.log(JSON.stringify(parser.parse('( 2 + 3 ) * 7 + xyz(2, 3)\n2'), null, 2))
