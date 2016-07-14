var chart = AmCharts.makeChart( "chartdiv", {
  "type": "pie",
  "theme": "light",
  "pullOutDuration": 11,
  "pullOutEffect": "elastic",
  "sequencedAnimation": false,
   "fontSize": 12,
  "dataLoader": {
    "url": "http://localhost:3000/get_email_data",
    "format": "json"
  },
  "valueField": "value",
  "titleField": "server",
  "outlineAlpha": 0.4,
  "depth3D": 15,
  "balloonText": "[[title]]<br><span style='font-size:25px'><b>[[value]]</b> ([[percents]]%)</span>",
  "angle": 30,
  "export": {
    "enabled": true
  }
} );

var chart2 = AmCharts.makeChart( "chartdiv2", {
  "type": "pie",
  "theme": "light",
  "pullOutDuration": 11,
  "pullOutEffect": "elastic",
  "sequencedAnimation": false,
   "fontSize": 12,
  "dataProvider": [ {
    "country": "Services",
    "value": 260
  }, {
    "country": "Expresss",
    "value": 201
  }, {
    "country": "Ground",
    "value": 65
  }, {
    "country": "Freight",
    "value": 39
  }, {
    "country": "Office",
    "value": 19
  }, {
    "country": "SupplyChain",
    "value": 10
  } ],
  "valueField": "value",
  "titleField": "country",
  "outlineAlpha": 0.4,
  "depth3D": 15,
  "balloonText": "[[title]]<br><span style='font-size:25px'><b>[[value]]</b> ([[percents]]%)</span>",
  "angle": 30,
  "export": {
    "enabled": true
  }
} );


var chart3 = AmCharts.makeChart( "chartdiv3", {
  "type": "pie",
  "theme": "light",
  "pullOutDuration": 11,
  "pullOutEffect": "elastic",
  "sequencedAnimation": false,
   "fontSize": 12,
  "dataProvider": [ {
    "country": "Services",
    "value": 260
  }, {
    "country": "Expresss",
    "value": 201
  }, {
    "country": "Ground",
    "value": 65
  }, {
    "country": "Freight",
    "value": 39
  }, {
    "country": "Office",
    "value": 19
  }, {
    "country": "SupplyChain",
    "value": 10
  } ],
  "valueField": "value",
  "titleField": "country",
  "outlineAlpha": 0.4,
  "depth3D": 15,
  "balloonText": "[[title]]<br><span style='font-size:25px'><b>[[value]]</b> ([[percents]]%)</span>",
  "angle": 30,
  "export": {
    "enabled": true
  }
} );