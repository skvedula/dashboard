sys = require('sys')
exec = require('child_process').exec;
fs = require('fs');
var child;

function callb(error, stdout, stderr) {
	data = fs.readFileSync('output').toString();
	data = data.split("\n")
	main_header_1 = data[0];
	// first table
	table_heading_1 = data[2];
	timestamp_1 = data[3];
	thead_1 = data[5];
	tdata_1 = data.slice(9,23);//table 1 data tr<->td elements
	tdata_1 = tdata_1.map(function(s) { return s.trim() });
	tdata_1.pop();
	tndata_1 = tdata_1.join("\n\r");
	data_arr_1 = tdata_1.join("\n\r");
	data_arr_1 = data_arr_1.replace(/[\n\r]/g, "#");
	data_arr_1 = data_arr_1.trim();
	data_arr_1 = data_arr_1.split("####");
	data_arr_1 = data_arr_1.map(function(s) { return s.replace(/\s\s+/g, ' ') });
	tresult_1 = data[27];
	// second table
	table_heading_2 = data[35];
	timestamp_2 = data[36];
	thead_2 = data[38];
	tdata_2 = data.slice(42,56);
	tdata_2 = tdata_2.map(function(s) { return s.trim() });
	tdata_2.pop();
	tndata_2 = tdata_2.join("\n\r");
	data_arr_2 = tdata_2.join("\n\r");
	data_arr_2 = data_arr_2.replace(/[\n\r]/g, "#");
	data_arr_2 = data_arr_2.trim();
	data_arr_2 = data_arr_2.split("####");
	data_arr_2 = data_arr_2.map(function(s) { return s.replace(/\s\s+/g, ' ') });	
	tresult_2 = data[60];
	for(var i=0; i<data_arr_1.length; i++) {
		td_arr_1 = data_arr_1[i].split(" ");
		td_arr_2 = data_arr_2[i].split(" ");
	}
// [5:23] table 1
// [5:23] table 1


body = "";
page = '<!DOCTYPE html>' + '<html><header>' + '</header><body>' + body + '</body></html>';
console.log(page);
}
exec("cat sample.txt > output", callb);// **change this commad to ssh perl command