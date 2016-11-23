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

app.get('/jquery.min.js',function(req,res){
  res.sendFile(path.join(__dirname+'/public/js/jquery.min.js'));
});

app.get('/bootstrap.min.js',function(req,res){
  res.sendFile(path.join(__dirname+'/public/js/bootstrap.min.js'));
});

app.get('/dataloader.min.js',function(req,res){
  res.sendFile(path.join(__dirname+'/public/js/dataloader.min.js'));
});

app.get('/pie.js',function(req,res){
  res.sendFile(path.join(__dirname+'/public/js/custom/pie.js'));
});

app.get('/serial.js',function(req,res){
  res.sendFile(path.join(__dirname+'/public/js/custom/serial.js'));
});

app.get('/light.js',function(req,res){
  res.sendFile(path.join(__dirname+'/public/js/custom/light.js'));
});

app.get('/serial2.js',function(req,res){
  res.sendFile(path.join(__dirname+'/public/js/custom/amgraphs/serial.js'));
});

app.get('/ru.js',function(req,res){
  res.sendFile(path.join(__dirname+'/public/js/custom/amgraphs/ru.js'));
});

app.get('/unresponsive_hubcas',function(req,res){
	pool.getConnection(function(err, connection) {
	connection.query('SELECT * from unresponsive_hubcas', function(err, rows, fields) {
	  if (!err) {
		  connection.release();
	  	res.send(rows);
	  }
	  else
	    console.log('Error while performing Query.');
	});
});
});

app.get('/iplanet_cpu',function(req,res){
	pool.getConnection(function(err, connection) {
	connection.query('SELECT server,memory,cpu_load from iplanet_details where server="prh00939"', function(err, rows, fields) {
	  if (!err) {
		  connection.release();
	  	res.send(rows);
	  }
	  else
	    console.log('Error while performing Query.');
	});
});
});

app.get('/iplanet_cpu1',function(req,res){
	pool.getConnection(function(err, connection) {
	connection.query('SELECT server,memory,cpu_load from iplanet_details where server="prh00940"', function(err, rows, fields) {
	  if (!err) {
		  connection.release();
	  	res.send(rows);
	  }
	  else
	    console.log('Error while performing Query.');
	});
});
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

app.get('/iplanet/diskspace',function(req,res){
	pool.getConnection(function(err, connection) {
	connection.query('SELECT server,part1,part2,part3,part4,part5,part6,part7,part8,part9,part10,part11,part12 from iplanet_details', function(err, rows, fields) {
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

app.get('/iplanet_alert',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM iplanet_alert WHERE space_used > 63 ORDER BY space_used ASC', function(err, rows, fields) {
      if (!err) {
        connection.release();
        res.send(rows).val;
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

app.get('/services_health',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM services_health', function(err, rows, fields) {
      if (!err) {
        connection.release();
        res.send(rows);
      }
      else
        console.log('Error while performing Query.',err);
    });      
  });
});

app.get('/mailbox_replication',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM mbx_replication', function(err, rows, fields) {
      if (!err) {
        connection.release();
        res.send(rows);
      }
      else
        console.log('Error while performing Query.',err);
    });      
  });
});

app.get('/health_check',function(req,res){
	pool.getConnection(function(err, connection) {
	connection.query('SELECT * from test_health', function(err, rows, fields) {
	  if (!err) {
		  connection.release();
	  	res.send(rows);
	  }
	  else
	    console.log('Error while performing Query.');
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
app.get('/lastfullbackup1',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM lastfullbackup1', function(err, rows, fields) {
      if (!err) {
        connection.release();
     res.send(rows).val;
	 }
      else
        console.log('Error while performing Query.');
    });      
  });
});

app.get('/lowdiskspace1',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM lowdiskspace', function(err, rows, fields) {
      if (!err) {
        connection.release();
     res.send(rows).val;
	 }
      else
        console.log('Error while performing Query.');
    });      
  });
});

app.get('/error_table',function(req,res){
  pool.getConnection(function(err, connection) {
    // Use the connection
    connection.query( 'SELECT * FROM error_table', function(err, rows, fields) {
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
app.get('/lastfullbackup',function(req,res){
  res.sendFile(path.join(__dirname+'/lastbackup.html'));
});
app.get('/lastfullbackup2',function(req,res){
  res.sendFile(path.join(__dirname+'/lastbackup2.html'));
});
app.get('/exchange_hcheck',function(req,res){
  res.sendFile(path.join(__dirname+'/exchange_hcheck.html'));
});

app.get('/email_domain',function(req,res){
  res.sendFile(path.join(__dirname+'/email_domain.html'));
});

app.get('/queuecounts',function(req,res){
  res.sendFile(path.join(__dirname+'/queuecounts.html'));
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
app.get('/peg_939',function(req,res){
  res.sendFile(path.join(__dirname+'/peg_graph939.html'));
});
app.get('/peg_940',function(req,res){
  res.sendFile(path.join(__dirname+'/peg_graph940.html'));
});
app.get('/iplanet_940',function(req,res){
  res.sendFile(path.join(__dirname+'/iplanet_940.html'));
});

app.listen(3000);

console.log("Running at Port 3000");