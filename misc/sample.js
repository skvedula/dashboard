child_process = require('child_process');

var task = child_process.execFile(`sh`, [`./bash.sh`],function (error, stdout, stderr) {
  result= stdout.trim();
  console.log(result);
  if (error !== null) {
    console.log('exec error: ' + error);
  }
});