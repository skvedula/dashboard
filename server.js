var express = require("express");
var app     = express();
var path    = require("path");

app.use(express.static('public'));

app.get('/',function(req,res){
  res.sendFile(path.join(__dirname+'/dashboard.html'));
  //__dirname : It will resolve to your project folder.
});

app.get('/dashboard',function(req,res){
  res.sendFile(path.join(__dirname+'/dashboard.html'));
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