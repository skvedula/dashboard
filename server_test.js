var http = require("http");
var express = require("express");
var app     = express();
var path    = require("path");
var mysql      = require('mysql');
var fs = require("fs");


var pool  = mysql.createPool({
  connectionLimit : 100,
  host     : '172.31.49.151',
  user     : 'pinuser',
  password : 'pin@123',
  database : 'pdb60166'
});

//connection.connect();

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
	pool.getConnection(function(err, connection) {
	connection.query('SELECT * from exchangedbreport', function(err, rows, fields) {
	  if (!err) {
		  connection.release();
	  	res.send(rows);
	  }
	  else
	    console.log('Error while performing Query.');
	});
  //__dirname : It will resolve to your project folder.
});
});

app.get('/get_email_data',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM email_domains', function(err, rows, fields) {
      if (!err) {
        connection.release();
        res.send(rows);
      }
      else
        console.log('Error while performing Query.');
    });      
  });
});

app.get('/get_opco_db',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM opco_db', function(err, rows, fields) {
      if (!err) {
        connection.release();
        res.send(rows);
      }
      else
        console.log('Error while performing Query.');
    });      
  });
});
app.get('/gauge_data',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM gauge', function(err, rows, fields) {
      if (!err) {
        connection.release();
        res.send(rows);
      }
      else
        console.log('Error while performing Query.');
    });      
  });
});


app.get('/exchange',function(req,res){
  res.sendFile(path.join(__dirname+'/exchange.html'));
});

app.get('/json', function (req, res) {
   fs.readFile( __dirname + "/test.json", 'utf8', function (err, data) {
       console.log( data );
       res.send( data );
   });
})

app.get('/iplanet',function(req,res){
  res.sendFile(path.join(__dirname+'/iplanet.html'));
});

app.listen(3001);

console.log("Running at Port 3001");