var chart = AmCharts.makeChart("column_chart", {
    "theme": "light",
    "type": "serial",
	"startDuration": 2,
    "dataLoader": {
    "url": "http://172.31.49.151:3000/get_opco_db",
    "format": "json"
  },
    "graphs": [{
        "balloonText": "[[category]]: <b>[[value]]</b>",
        "fillColorsField": "color",
        "fillAlphas": 1,
        "lineAlpha": 0.1,
        "type": "column",
        "valueField": "value"
    }],
    "depth3D": 20,
	"angle": 30,
    "chartCursor": {
        "categoryBalloonEnabled": false,
        "cursorAlpha": 0,
        "zoomable": false
    },    
    "categoryField": "opco",
    "categoryAxis": {
        "gridPosition": "start",
        "labelRotation": 90
    },
    "export": {
    	"enabled": true
     },
	 "dataTableId": "chartdata",
});
