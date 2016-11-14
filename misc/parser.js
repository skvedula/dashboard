sys = require('sys')
exec = require('child_process').exec;
fs = require('fs');
var child;
var body = "";
var idx = 0;
function callb(error, stdout, stderr) {
	data = fs.readFileSync('output').toString();
	data = data.split("\n");
	timestamp_1 = data[0];
	if(idx == 0){
		body = body + "<h3>Queue totals for prh00939</h3>" + "<h5>" + timestamp_1 + "</h5>";
		idx = idx +1;
	}
	else{
		body = body + "<h3>Queue totals for prh00940</h3>" + "<h5>" + timestamp_1 + "</h5>";
	}
	// console.log(body);
	table_head_1 = "<table><thead><tr><th>Channel</th><th>Messages</th><th>Size (Mb)</th></tr></thead>";
	body = body + table_head_1;
	tdata_1 = data.slice(3,11);//table 1 data tr<->td elements
	tdata_1 = tdata_1.map(function(s) { return s.trim() });
	data_arr_1 = tdata_1.map(function(s) { return s.replace(/\s\s+/g, ' ') });
	// console.log(data_arr_1);
	tresult_1 = data[12];
	// console.log(tresult_1);
	for(var i=0; i<data_arr_1.length; i++) {
		td_arr_1 = data_arr_1[i].split(" ");
		body = body + "<tr>" + "<td>" + td_arr_1[0] + "</td>" + "<td>" + td_arr_1[1] + "</td>" + "<td>" + td_arr_1[2] + "</td>" + "</tr>";
	}
	tsummary_1 = tresult_1.trim().replace(/\s\s+/g, ' ').split(" ");
	body = body + "<tfoot>" + "<tr>" + "<td>" + tsummary_1[0] + "</td>" + "<td>" + tsummary_1[1] + "</td>" + "<td>" + tsummary_1[2] + "</td>" + "</tr>" + "</tfoot>";
	body = body + '</table>';
}
exec("cat sample1.txt > output", callb);// **change this commad to ssh perl command
setTimeout(function() {
	exec("cat sample2.txt > output", callb);// **change this commad to ssh perl command
	setTimeout(function() {
	  body = '<!DOCTYPE html><html><head><link rel="stylesheet" type="text/css" href="main.css"></head><body>' + body + '</table></body></html>';
	  console.log(body);
	}, 1000);
}, 1000);
// '<!DOCTYPE html>' + '<html><header>' + '</header><body>' + body + '</table></body></html>';