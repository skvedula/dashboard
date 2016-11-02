sys = require('sys')
exec = require('child_process').exec;
fs = require('fs');
var child;
var body = "";
function callb(error, stdout, stderr) {
	data = fs.readFileSync('output').toString();
	data = data.split("\n");
	// main_header_1 = data[0];
	// body = body + "<h2>" + main_header_1 + "</h2>";
	// first table
	// table_heading_1 = data[2];
	// body = body + "<h3>" + table_heading_1 + "</h3>";
	timestamp_1 = data[0];
	// body = body + "<h5>" + timestamp_1 + "</h5>";
	// console.log(body);
	table_head_1 = "<table><thead><tr><th>Channel</th><th>Messages</th><th>Size (Mb)</th></tr></thead>";
	body = body + table_head_1;
	tdata_1 = data.slice(6,20);//table 1 data tr<->td elements
	tdata_1 = tdata_1.map(function(s) { return s.trim() });
	tdata_1.pop();
	tndata_1 = tdata_1.join("\n\r");
	data_arr_1 = tdata_1.join("\n\r");
	data_arr_1 = data_arr_1.replace(/[\n\r]/g, "#");
	data_arr_1 = data_arr_1.trim();
	data_arr_1 = data_arr_1.split("####");
	data_arr_1 = data_arr_1.map(function(s) { return s.replace(/\s\s+/g, ' ') });
	tresult_1 = data[24];
	// second table
	// table_heading_2 = data[32];
	// timestamp_2 = data[33];
	// thead_2 = data[35];
	// tdata_2 = data.slice(39,53);
	// tdata_2 = tdata_2.map(function(s) { return s.trim() });
	// tdata_2.pop();
	// tndata_2 = tdata_2.join("\n\r");
	// data_arr_2 = tdata_2.join("\n\r");
	// data_arr_2 = data_arr_2.replace(/[\n\r]/g, "#");
	// data_arr_2 = data_arr_2.trim();
	// data_arr_2 = data_arr_2.split("####");
	// data_arr_2 = data_arr_2.map(function(s) { return s.replace(/\s\s+/g, ' ') });
	// tresult_2 = data[57];
	for(var i=0; i<data_arr_1.length; i++) {
		td_arr_1 = data_arr_1[i].split(" ");
		body = body + "<tr>" + "<td>" + td_arr_1[0] + "</td>" + "<td>" + td_arr_1[1] + "</td>" + "<td>" + td_arr_1[2] + "</td>" + "</tr>";
		// td_arr_2 = data_arr_2[i].split(" ");
		// console.log(td_arr_1);
	}
	tsummary_1 = tresult_1.trim().replace(/\s\s+/g, ' ').split(" ");
	body = body + "<tfoot>" + "<tr>" + "<td>" + tsummary_1[0] + "</td>" + "<td>" + tsummary_1[1] + "</td>" + "<td>" + tsummary_1[2] + "</td>" + "</tr>" + "</tfoot>";
	// tsummary_2 = tresult_2.trim().replace(/\s\s+/g, ' ').split(" ");
	// console.log(tsummary_1);
	// console.log(tsummary_2);
// [5:23] table 1
// [5:23] table 1

body = body + '</table>';
// console.log(body);
// console.log("\n\n");
}
exec("cat sample1.txt > output", callb);// **change this commad to ssh perl command
exec("cat sample2.txt > output", callb);// **change this commad to ssh perl command
setTimeout(function() {
  body = '<!DOCTYPE html><html><head><link rel="stylesheet" type="text/css" href="main.css"></head><body>' + body + '</table></body></html>';
  console.log(body);
}, 1000);
// '<!DOCTYPE html>' + '<html><header>' + '</header><body>' + body + '</table></body></html>';