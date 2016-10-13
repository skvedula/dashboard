/*var chart = AmCharts.makeChart( "chartdiv", {
  "type": "pie",
  "theme": "light",
  "pullOutDuration": 11,
  "pullOutEffect": "elastic",
  "sequencedAnimation": false,
   "fontSize": 12,
   "dataLoader": {
    "url": "http://webtools.intranet.fedex.com:3000/json",
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
  
} ); */


var chart = AmCharts.makeChart( "chartdiv", {
  "type": "pie",
  "theme": "light",
  "pullOutDuration": 11,
  "pullOutEffect": "elastic",
  "sequencedAnimation": false,
   "fontSize": 12,
  "dataLoader": {
    "url": "http://webtools.intranet.fedex.com:3000/get_email_data",
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
  }, 
} );


var chart2 = AmCharts.makeChart( "chartdiv2", {
  "type": "pie",
  "theme": "light",
  "pullOutDuration": 11,
  "pullOutEffect": "elastic",
  "sequencedAnimation": false,
   "fontSize": 12,
   "dataLoader": {
    "url": "http://webtools.intranet.fedex.com:3000/get_opco_db",
    "format": "json"
  },
  "valueField": "value",
  "titleField": "opco",
  "outlineAlpha": 0.4,
  "depth3D": 15,
  "balloonText": "[[title]]<br><span style='font-size:25px'><b>[[value]]</b>() </span>",
  "angle": 30,
  "export": {
    "enabled": true
  },
  "legend": {
    "width": "30%",
    "divId": "legenddiv1",
    "marginRight": 80,
    "marginLeft": 100,
    "equalWidths": false,
    "backgroundAlpha": 0.5,
    "backgroundColor": "#e0e0d1",
    "borderColor": "#ffffff",
    "borderAlpha": 1,
    "top": 300,
    "left": 0,
    "horizontalGap": 10,
    "data": [ {
      "title": "OPCO DATABASE",
      "color": "#FFFFFF",
	  "position":"top"
    }]
  }
} );


