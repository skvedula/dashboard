/*var gaugeChart = AmCharts.makeChart( "guagechart", {
  "type": "gauge",
  "theme": "dark",
  "axes": [ {
    "axisThickness": 1,
    "axisAlpha": 0.2,
    "tickAlpha": 0.2,
    "valueInterval": 20,
    "bands": [ {
      "color": "#84b761",
      "endValue": 40,
      "startValue": 0
    }, {
      "color": "#fdd400",
      "endValue": 80,
      "innerRadius": "85%",
      "startValue": 40
    }, {
      "color": "#cc4748",
      "endValue": 100,
      "innerRadius": "80%",
      "startValue": 80
    } ],
    "bottomText": "0%",
    "bottomTextYOffset": -20,
    "endValue": 100
  } ],
  "arrows": [ {} ],
  "export": {
    "enabled": true
  }
} );

setInterval( randomValue, 2000 );


// set random value
function randomValue() {
  var value = Math.round( Math.random() * 100 );
  if ( gaugeChart ) {
    if ( gaugeChart.arrows ) {
      if ( gaugeChart.arrows[ 0 ] ) {
        if ( gaugeChart.arrows[ 0 ].setValue ) {
          gaugeChart.arrows[ 0 ].setValue( value );
          gaugeChart.axes[ 0 ].setBottomText( value + "%" );
        }
      }
    }
  }
}

*/



var gaugeChart = AmCharts.makeChart( "guagechart", {
  "type": "gauge",
  "theme": "dark",
  "axes": [ {
    "axisThickness": 1,
    "axisAlpha": 0.2,
    "tickAlpha": 0.2,
    "valueInterval": 20,
    "bands": [ {
      "color": "#84b761",
      "endValue": 40,
      "startValue": 0
    }, {
      "color": "#fdd400",
      "endValue": 80,
      "innerRadius": "85%",
      "startValue": 40
    }, {
      "color": "#cc4748",
      "endValue": 100,
      "innerRadius": "80%",
      "startValue": 80
    } ],
    "bottomText": "0%",
    "bottomTextYOffset": -20,
    "endValue": 100
  } ],
  "arrows": [ {} ],
  "export": {
    "enabled": true
  }
} );

setInterval( randomValue, 2000 );

var value = 30;

// set random value
function randomValue() {
  $.get( "/get_gauge_data", function( data ) { // if this url doesnt work try http://localhost:3000/get_opco_db
    console.log("data - ", data);
    value = data[0]["val"];
  });  
  if ( gaugeChart ) {
    if ( gaugeChart.arrows ) {
      if ( gaugeChart.arrows[ 0 ] ) {
        if ( gaugeChart.arrows[ 0 ].setValue ) {
          gaugeChart.arrows[ 0 ].setValue( value );
          gaugeChart.axes[ 0 ].setBottomText( value + "%" );
        }
      }
    }
  }
} 

