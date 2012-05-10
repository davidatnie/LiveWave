// used by the Spiral viz. Holds information to build a scatterplot of "Time vs CRVScore"

class Scatter {
  // Fields
  float xOffset;           // the Origin - X value
  float yOffset;         // the Origin - Y value
  float xLength;        // length of horizontal axis
  float yLength;        // length of vertical axis
  float oneMinGraph, oneMinDefault;      // Horizontal Scaling - determine the length of "one-min" interval
  float metricStepGraph, metricStepDefault;          //  Vertical Scaling - determine the length of "one-step" interval for the Metric
  int displayStringScatter, gotDisplayStringScatter; // for use in mouseover check for Scatterplot points
  int maxPostTime;
  float maxMetric;
  Spiral spiralScatter;
  String metricLabel;
  int hitButtonX1, hitButtonY1, hitButtonX2, hitButtonY2, noHitButtonX1, noHitButtonY1, noHitButtonX2, noHitButtonY2;
  boolean hasData;
  
  // Constructor
  Scatter( Spiral _spiral ) {
    hasData = _spiral.hasData;
    xOffset = 30;           // the Origin - X value
    yOffset = 260;         // the Origin - Y value
    xLength = 150;        // length of horizontal axis
    yLength = 150;        // length of vertical axis
    oneMinDefault = 60;
    metricStepDefault = 5.0;
    metricLabel = "Creativity Score";
    maxMetric = _spiral.getMaxMetric();
    maxPostTime = _spiral.getMaxPostTime();
    if( hasData ) {
      oneMinGraph = map( oneMinDefault, 0, _spiral.getMaxPostTime(), 0,xLength );      // default Time value per step is 60 secs
      metricStepGraph = map( metricStepDefault, 0, maxMetric, 0, yLength );         // default Metric value per step is 5.00
    } else { // means, has no data
      oneMinGraph = 0;
      metricStepGraph = 0;
    }
    displayStringScatter = 0;
    gotDisplayStringScatter = 0;
    spiralScatter = _spiral;
    
   
    
  } // end Constructor
  
  // Methods
  void display() {
    clearPanel();
    //inspectScatter();
    if( hasData ) { // draw these if has data
      drawSummStats();
      drawShowHideUI();
      drawBarChart();
      drawScatterPlot();
    } else { // draw the following if has no data
      textSize( 16 );
      stroke( popUpTxt );
      fill( popUpBkgrd );
      rect( xOffset + 20, yOffset - 170, xOffset + textWidth( "No Data For This Class" ) + 40, yOffset - 140 );
      fill( popUpTxt );
      text( "No Data For This Class", xOffset + 30, yOffset - 150 );
    } // end if no data
    
  } // end display()
  
  void clearPanel() {
    fill( 255 );
    stroke( 255 );
    rect( 0, 0, 348, 298 );
  } // end clearPanel();
  
  void drawSummStats() {
    fill( 0 );
    textSize( 8 );
    text( "Exercise Duration : " + spiralScatter.cDuration.getPost_Time_Mins(), 20, yOffset - 240 );
    text( "Number of Unique Fns: " + spiralScatter.spokes.size(), 200, yOffset - 240 );
   text( "Total Creativity Metric: " + spiralScatter.crvTotal, 20, yOffset - 225 ); 
  }
    
  void drawBarChart() {
     // draws barchart of Metric for the HIT and NO-HIT functions
    fill( 0 );
    textSize( 8 );
    text( "Distribution Shape: ", xOffset + xLength + 20, yOffset - yLength - 20 );
    plotDistribution( xOffset + xLength + 20, yOffset, yLength, metricStepGraph, metricStepDefault, maxMetric, spiralScatter.spokes ); // default Metric value per step is 5.00
  } // end drawBarChart();
  
  void drawScatterPlot() {
    // draws scatterplot
    fill( 0 );
    textSize( 10 );
    text( "CREATIVITY BY TIME", xOffset + 70, yOffset - 185 );
    textSize( 8 );
    text( "Scatterplot - Unique Fns Only : ", 20, yOffset - yLength - 20 );
    drawAxes(xOffset, yOffset, xLength, yLength, oneMinGraph, metricStepGraph); // draws the X and Y axes  and labelling and markings for the scatterplot
    plotPoints( xOffset, yOffset, xLength, yLength ); // plots the points
  } // end drawScatterPlot()
  
  void drawShowHideUI() {  
   // draws Show-Hide UI
   rectMode( CORNER );
   stroke( 0 );
   fill( 0, 255, 0 );
    rect( xOffset + 280, yOffset - 150, 30, 20 );
    hitButtonX1 = int( xOffset + 280 );
    hitButtonY1 = int( yOffset - 150 );
    hitButtonX2 = int( hitButtonX1 + 30 );
    hitButtonY2 = int( hitButtonY1 + 20 );
    fill( 255, 0, 0 );
    rect( xOffset + 280, yOffset - 120, 30, 20 );
    noHitButtonX1 = int( xOffset + 280 );
    noHitButtonY1 = int( yOffset - 120 );
    noHitButtonX2 = int( hitButtonX1 + 30 );
    noHitButtonY2 = int( hitButtonY1 + 20 );
    textSize( 10 );
    fill( 0 );
    if ( alpha( hitColorScatter ) == 255 )
      text( "ON", xOffset + 287, yOffset - 135 );
    else 
      text( "OFF", xOffset + 285, yOffset - 135 );
    fill( 0 );
    if ( alpha( noHitColorScatter ) == 255 )
      text( "ON", xOffset + 287, yOffset - 105 );
    else 
      text( "OFF", xOffset + 285, yOffset - 105 );
  } // end drawShowHideUI()
  
  void plotDistribution( float tempXOffset, float tempYOffset, float tempYLength, float tempMetricStepGraph, float tempMetricStepDefault, float tempMaxMetric, ArrayList tempSpokes ) {
    int numBins = ceil( tempMaxMetric / tempMetricStepDefault );
    int [] hitDistrib = new int[ numBins ];
    int [] no_hitDistrib = new int[ numBins ];
    float scaleFactor = 2; // width (in pixels) of one count for the Metric barchart
    float no_hitXOffset = 0;
  
    for( int i = 0; i < tempSpokes.size(); i++ ) { // go through the spokes and populate the hitDistrib and no-hitDistrib distribution arrays
      
      Spoke s = ( Spoke ) tempSpokes.get( i );
        int targetBin = 0;
      if ( s.hit == true ) {
        targetBin = int( ceil( s.crvScore / tempMetricStepDefault ) ) - 1;
        targetBin = constrain( targetBin, 0, numBins ); // takes care of Metric scores of 0, which will yield targetBin of value -1 and creates an error when its plugged into arrayIndex
        hitDistrib[ targetBin ] += 1;
      } else if( s.hit == false ) {
        no_hitDistrib[ targetBin ] += 1;
      } else {
        text( "ERROR! FUNCSHIT[ ] got values other than 'HIT' and 'NO-HIT'! Check Data ", 0, 150 );
      }
    } // end for( i )  
    
    // draw the bar chart for HIT
    stroke( 0, 0, 0, alpha( hitColorScatter ) );
    fill( hitColorScatter );
    rectMode( CORNERS );
    for( int j = 0; j < numBins; j++ ) {
      rect( tempXOffset, tempYOffset - metricStepGraph - ( j * metricStepGraph ), tempXOffset + hitDistrib[ j ] * scaleFactor, tempYOffset - ( j * metricStepGraph ) );
    
      // update no_hitXOffset
      if( tempXOffset + hitDistrib[ j ] * scaleFactor > no_hitXOffset ) {       // always take the biggest value for setting xOffset for NO-HIT barchart
        no_hitXOffset = tempXOffset + hitDistrib[ j ] * scaleFactor;
      }
    } // end for( j )
  
    // draw the bar chart for NO-HIT
    no_hitXOffset += 5;
    stroke( 0, 0, 0, alpha( noHitColorScatter ) );
    fill( noHitColorScatter );
    for( int j = 0; j < numBins; j++ ) {
      rect( no_hitXOffset, tempYOffset - metricStepGraph - ( j * metricStepGraph ), no_hitXOffset + ( no_hitDistrib[ j ] * scaleFactor ), tempYOffset - ( j * metricStepGraph ) );
    } // end for( j )
  } // end plotDistribution()


  void drawAxes(float xOffset, float yOffset, float xLength, float yLength, float oneMin, float twoTerm) { 
    stroke( 0 );
    textSize( 8 );
    line( xOffset + 5, yOffset + 0, xOffset + 5 + xLength, yOffset + 0 ); // draw horizontal axis
    for( int i = 0; i * oneMinGraph <= xLength; i++ ) {
      line( xOffset + 5 + i * oneMinGraph, yOffset + 0, xOffset + 5 + i * oneMinGraph, yOffset + 5 ); // draw markings for the horizontal axis
      text( i, xOffset + 5 - 3 + i * oneMinGraph, yOffset + 15 );
    }
    text ("Time (mins)", xOffset + xLength - textWidth( "Time (mins)" ), yOffset + 25); // draw label for the horizontal axis
    
    line( xOffset + 5, yOffset + 0, xOffset + 5, yOffset - yLength ); // draw vertical axis
    for( int i = 0; i * metricStepGraph <= yLength; i++ ) {
      if( i % 4 == 0 ) { // only show markings per 4 metricSteps
        line( xOffset + 5, yOffset - i * metricStepGraph, xOffset +5 - 5, yOffset - i * metricStepGraph ); // draw markings for the vertical axis
        text (( i * int( metricStepDefault ) ), xOffset - 15, yOffset + 3 - i * metricStepGraph );
      } // end if
    } // end for i
    pushMatrix();
    translate (xOffset - 20, yOffset - yLength + textWidth (metricLabel) );
    rotate( radians( 270 ) );
    text ( metricLabel, 0, 0  ); // draw label for the horizontal axis
    popMatrix();
  } // end drawAxes()
  



  void inspectScatter() {
    println( "[ INSPECTING SCATTER ]" );
    println( "     xOffset=" + xOffset + " yOffset=" + yOffset );
    println( "     xLength=" + xLength + " yLength=" + yLength );
    println( "     oneMinGraph="  + oneMinGraph + " oneMinDefault=" + oneMinDefault );
    println( "     metricStepGraph=" + metricStepGraph + " metricStepDefault=" + metricStepDefault );
    println( "     displayStringScatter=" + displayStringScatter + " gotDisplayStringScatter=" + gotDisplayStringScatter );
    println( "     maxPostTime=" + maxPostTime );
    println( "     maxMetric=" + maxMetric );
    println( "     printing spiralScatter instance object's spkes' crvScore, for each spoke: " );
    println( "     spiralScatter.size()=" + spiralScatter.spokes.size() );
    for( int i = 0; i < spiralScatter.spokes.size(); i++ ) {
      Spoke s = ( Spoke ) spiralScatter.spokes.get( i );
      println( "          " + i + ". " + s.crvScore );
    } // end for i
    println( "     finished printing crvScore for each Spoke instance object of spiralScatter" );
    
    println( "     metricLabel=" + metricLabel );
    println( "     hitButton: X1-Y1 X2-Y2=" + hitButtonX1 + " " + hitButtonY1 + " " + hitButtonX2 + " " + hitButtonY2 );
    println( "     noHitButton: X1-Y1 X2-Y2=" + " " + noHitButtonX1 + " " + noHitButtonY1 + " " + noHitButtonX2 + " " + noHitButtonY2 );
    println( "     hasData=" + hasData );
    println( "[ DONE INSPECTING SCATTER ]" );
  } // end inspectScatter()
  


  
  void plotPoints( float xOffset, float yOffset, float xLength, float yLength ) {
    float pointX = 0;
    float pointY = 0;
    for( int i = 0; i < spiralScatter.spokes.size(); i++ ) {
      // set the color of the point
      Spoke s = ( Spoke ) spiralScatter.spokes.get( i );
      if( s.hit == true ) {
        stroke( 0, 0, 0, alpha( hitColorScatter ) );
        fill( hitColorScatter ); // set to green if HIT
      } else {
        stroke( 0, 0, 0, alpha( noHitColorScatter ) );
        fill( noHitColorScatter ); // set to red if NO-HIT
      }
      pointX =xOffset + 5 + map( s.genesis, 0, maxPostTime, 0, xLength );
      pointY = yOffset - map( s.crvScore, 0, maxMetric, 0, yLength );
      ellipse( pointX + 5, pointY, 6, 6 );
      if( dist( float( mouseX ), float( mouseY ), pointX + 5, pointY ) <= 3 ) { // mouseover
      displayStringScatter = i+1;    
      if( gotDisplayStringScatter == 0 )
        gotDisplayStringScatter = displayStringScatter;
      } else {
        displayStringScatter = 0;
      }
    } // end for( i < spiralScatter.spokes.size() )
    
    if( gotDisplayStringScatter != 0 ) {         // calling displayString function
      displayFuncString( gotDisplayStringScatter, mouseX, mouseY );
      gotDisplayStringScatter = 0;
    }
    
  } // end plotPoints()
  
  void displayFuncString (int tempDisplayString, float tempDisplayOuterX, float tempDisplayOuterY) { // to display pop-up box containing string of the function, on mouseover
    rectMode( CORNER );
    Spoke s  = ( Spoke ) spiralScatter.spokes.get( tempDisplayString - 1 );
    textSize( 16 );
    float standardLength = textWidth(s.funcString);
    textSize( 11 );
    float minLength = textWidth("Genesis:  xx:xx") + textWidth( "     Freq : xx") + textWidth( "     CRV Score: xx.xx" );
  
    if(tempDisplayString != 0) {
      //Spoke s = ( Spoke ) spiralScatter.spokes.get( tempDisplayString - 1 );
      if (tempDisplayOuterX + standardLength+10 <= width) { // if length  of popup, given mouse location exceeds width of the window
        if (standardLength <= minLength) { // pop up cant be narrower than the minLength
          fill(0,0,0,180);
          rect(tempDisplayOuterX,tempDisplayOuterY-45, minLength+20,40);
        } else {
          fill(0,0,0,180);
          rect(tempDisplayOuterX,tempDisplayOuterY-45, standardLength+20,40);
        }
        stroke(255,255,0);
        fill(255,255,0);
        textSize(16);
        text( s.funcString,tempDisplayOuterX+5,tempDisplayOuterY-25);
        textSize(11);
        text ("Genesis:  "+ s.cGenesis.getPost_Time_Mins() + "     Freq:" + s.freq + "     CRV Score : " + myRound( s.crvScore, 2 ),tempDisplayOuterX+5,tempDisplayOuterY-10);
      
      } else if (width - textWidth(s.funcString)*2+10 >= 350 ) { // if length of popup, given mouse location exceeds width of the window but is still within the viewing area
        float textX = 0; // to hold pop up starting loc
        if (standardLength <= minLength) { // pop up cant be narrower than the minLength
          fill(0,0,0,180);
          rect(tempDisplayOuterX - minLength-10   ,tempDisplayOuterY-45, minLength+20,40);
          textX = ( tempDisplayOuterX - textWidth(s.funcString) -20 ) ;
        } else {
          fill(0,0,0,180);
          rect(tempDisplayOuterX - standardLength-30   ,tempDisplayOuterY-45, standardLength+20,40);
          textX = ( tempDisplayOuterX - textWidth( s.funcString ) -30 ) ;
      }
        stroke(255,255,0);
        fill(255,255,0);
        textSize(16);
        text(s.funcString, textX+5 ,tempDisplayOuterY-25);
        textSize(11);
        text ("Genesis:  "+ s.cGenesis.getPost_Time_Mins() + "     Freq:" + s.freq + "     CRV Score : " + myRound( s.crvScore, 2 ),tempDisplayOuterX+5,tempDisplayOuterY-10);
      } else { // if length of popup cant fit within the viewing area (for extremely long function)
         fill(0,0,0,180);
        rect(350 ,tempDisplayOuterY-45, textWidth( s.funcString )*2+10,40);
        stroke(255,255,0);
        fill(255,255,0);
        textSize(11);
        text( s.funcString,350+5,tempDisplayOuterY-25);
        textSize(11);
        text ("Genesis:  "+ s.cGenesis.getPost_Time_Mins() + "     Freq:" + s.freq + "     CRV Score : " + myRound( s.crvScore, 2 ),tempDisplayOuterX+5,tempDisplayOuterY-10);
      }
    } else {
    }
  } // end displayFuncString()

    // ========================================================================
  // Computation and Algorithm for Scatterplot ends here
  // ========================================================================

} // end class Scatter()
