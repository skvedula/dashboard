sys = require('sys')
exec = require('child_process').exec;
fs = require('fs');
var child;

function callb(error, stdout, stderr) { console.log(stdout); 
	data = fs.readFileSync('output').toString();
	data = data.split("\n")
	console.log(data);
	main_header_1 = data[0];
	table_heading_1 = data[2];
	timestamp_1 = data[3];
	thead_1 = data[5];
	tdata_1 = data.slice(9,23);//table 1 data tr<->td elements
	tdata_1 = tdata_1.map(function(s) { return s.trim() });
	tndata_1 = tdata_1.join("\n\r");
	value = tdata_1.join("\n\r");
	value = value.replace(/[\n\r]/g, "#");
	value = value.trim();
	tresult_1 = data[27];
	table_heading_2 = data[35];
	timestamp_2 = data[36];
	thead_2 = data[38];
	tdata_2 = data.slice(42,56);
	tresult_2 = data[60];	
	console.log(main_header_1);
	console.log(table_heading_1);
	console.log(timestamp_1);
	console.log(table_heading_2);
	console.log(timestamp_2);
	console.log(tdata_1);
	console.log(value);


// [5:23] table 1
// [5:23] table 1




}
exec("cat sample.txt > output", callb);// **change this commad to ssh perl command