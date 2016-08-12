var http = require("http");
var express = require("express");
var app     = express();
var path    = require("path");
var mysql      = require('mysql');
var fs = require("fs");


var pool  = mysql.createPool({
  connectionLimit : 1000,
  host     : '172.31.49.151',
  user     : 'pinuser',
  password : 'pin@123',
  database : 'pdb60166'
});

//connection.connect();

app.use(express.static('public'));

app.get('/',function(req,res){
  res.sendFile(path.join(__dirname+'/dashboard.html'));
});

app.get('/dashboard',function(req,res){
  res.sendFile(path.join(__dirname+'/dashboard.html'));
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

app.get('/healthcheck_data',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM healthcheck_table', function(err, rows, fields) {
      if (!err) {
        connection.release();
        res.send(rows);
      }
      else
        console.log('Error while performing Query.',err);
    });      
  });
});

app.get('/gauge_data',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM gauge_table', function(err, rows, fields) {
      if (!err) {
        connection.release();
        res.send(rows);
      }
      else
        console.log('Error while performing Query.',err);
    });      
  });
});

app.get('/transport_q',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM transport_q', function(err, rows, fields) {
      if (!err) {
        connection.release();
        res.send(rows);
      }
      else
        console.log('Error while performing Query.',err);
    });      
  });
});

app.get('/DatabaseImbalanceData',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM imbalanced_db', function(err, rows, fields) {
      if (!err) {
        connection.release();
        res.send(rows);
      }
      else
        console.log('Error while performing Query.',err);
    });      
  });
});

app.get('/DatabaseReplication',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM db_replication', function(err, rows, fields) {
      if (!err) {
        connection.release();
        res.send(rows);
      }
      else
        console.log('Error while performing Query.',err);
    });      
  });
});

app.get('/cas_server',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM cas_server', function(err, rows, fields) {
      if (!err) {
        connection.release();
        res.send(rows);
      }
      else
        console.log('Error while performing Query.',err);
    });      
  });
});
app.get('/get_gauge_data',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM load_db', function(err, rows, fields) {
      if (!err) {
        connection.release();
     res.send(rows).val;
	 }
      else
        console.log('Error while performing Query.');
    });      
  });
});

app.get('/exchange',function(req,res){
  res.sendFile(path.join(__dirname+'/exchange.html'));
});

app.get('/exchange_hcheck',function(req,res){
  res.sendFile(path.join(__dirname+'/exchange_hcheck.html'));
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

app.listen(3000);

console.log("Running at Port 3000");