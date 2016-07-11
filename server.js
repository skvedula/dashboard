var express = require("express");
var app     = express();
var path    = require("path");
var mysql      = require('mysql');

var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',
  password : 'mysql123',
  database : 'sys'
});

connection.connect();

app.use(express.static('public'));

app.get('/',function(req,res){
  res.sendFile(path.join(__dirname+'/dashboard.html'));
  //__dirname : It will resolve to your project folder.
});

app.get('/dashboard',function(req,res){
  res.sendFile(path.join(__dirname+'/dashboard.html'));
  //__dirname : It will resolve to your project folder.
});

app.get('/dashboard/data',function(req,res){
	connection.query('SELECT * from testdb', function(err, rows, fields) {
	  if (!err) {
	  	res.send(rows);
	  }
	  else
	    console.log('Error while performing Query.');
	});
  //__dirname : It will resolve to your project folder.
});

app.get('/get_email_data',function(req,res){
  connection.query('SELECT * from email_domains', function(err, rows, fields) {
    if (!err) {
      res.send(rows);
    }
    else
      console.log('Error while performing Query.');
  });
  //__dirname : It will resolve to your project folder.
});

app.get('/exchange',function(req,res){
  res.sendFile(path.join(__dirname+'/exchange.html'));
});

app.get('/iplanet',function(req,res){
  res.sendFile(path.join(__dirname+'/iplanet.html'));
});

app.listen(3000);

console.log("Running at Port 3000");