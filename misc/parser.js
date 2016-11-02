sys = require('sys')
exec = require('child_process').exec;
fs = require('fs');
var child;
var body = "";
function callb(error, stdout, stderr) {
	data = fs.readFileSync('output').toString();
	data = data.split("\n");
	main_header_1 = data[0];
	body = body + "<h2>" + main_header_1 + "</h2>";
	// first table
	table_heading_1 = data[2];
	body = body + "<h3>" + table_heading_1 + "</h3>";
	timestamp_1 = data[3];
	body = body + "<h5>" + timestamp_1 + "</h5><table><tr>";
	thead_1 = data[5];
	table_head_1 = '<th>Channel</th><th>Messages</th><th>Size (Mb)</th></tr>';
	body = body + table_head_1;
	console.log(table_head_1);
	body = body;
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
		console.log(td_arr_1);
	}
	tsummary_1 = tresult_1.trim().replace(/\s\s+/g, ' ').split(" ");
	tsummary_2 = tresult_2.trim().replace(/\s\s+/g, ' ').split(" ");
	console.log(tsummary_1);
	console.log(tsummary_2);
// [5:23] table 1
// [5:23] table 1

page = '<!DOCTYPE html>' + '<html><header>' + '</header><body>' + body + '</body></html>';
console.log(page);
}
exec("cat sample.txt > output", callb);// **change this commad to ssh perl command