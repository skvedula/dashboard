var nodemailer = require('nodemailer');

// create reusable transporter object using the default SMTP transport
var transporter = nodemailer.createTransport("SMTP", {
    service: "Gmail", // hostname
    // secureConnection: false, // TLS requires secureConnection to be false
    // port: 587, // port for secure SMTP
    auth: {
        user: "** ENTER USERNAME **",
        pass: "** ENTER PASSWORD **"
    }
});
// setup e-mail data with unicode symbols
var mailOptions = {
    from: 'from@gmail.com', // sender address
    to: 'to@gmail.com', // list of receivers
    subject: 'Test Mail', // Subject line
    text: 'Test Mail', // plaintext body
    html: '<b>Test Mail</b>' // html body
};

// send mail with defined transport object
var start = new Date();
transporter.sendMail(mailOptions, function(error, info){
    if(error){
        return console.log(error);
    }
    var end = new Date() - start;
    console.log('Response Time: ' + end);
});