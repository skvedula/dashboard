fs = require('fs');
data = fs.readFileSync('sample.txt').toString();
console.log(data.split("\n"));
main_header_1 = data[0];
table_heading_1 = data[2];
timestamp_1 = data[3];
table_heading_2 = data[35];
timestamp_2 = data[36];

