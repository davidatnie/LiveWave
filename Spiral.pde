// used by the Spiral viz

// The following classes are required:
                    // - Spoke 
                    
class Spiral extends Section {

  // Fields

  ArrayList spokes;
  float crvTotal;
  Stats stats;
  float x, y, diam, rad;
  PFont f;
  String title;
  int titleSize, spokeFontSize;
  color spokeFreqBar;
  float pWidth, gWidth, px1, py1, px2, py2;  
  boolean hasData;
  float userRotate;     // to hold target degree rotated, as input fromeuser
  float deltaRotate;    // to hold incremental degree rotated for this frame. Value changes every frame
  PFont spiralFont = loadFont( "SansSerif.plain-12.vlw" );




  // Constructor

  Spiral( ArrayList tempFuncs, int tempMaxPostTime, int tempMinPostTime, String tempExerciseStart, String tempExerciseTitle, Table _artefacts, boolean tempHasData ) { // Spiral object is constructed by passing an ArrayList of Function objects and a Table object
    x = 150 + ( ( width - 350 ) / 2 );   // hard-coded to width of the left panel (350)
    y= height / 2;
    diam = 200;
    rad = diam / 2;
    spokes = new ArrayList();
    maxPostTime = tempMaxPostTime;
    cExerciseStart = new Post_Time( 0, tempExerciseStart );
    cMaxPostTime = new Post_Time( tempMaxPostTime, tempExerciseStart );
    cMinPostTime = new Post_Time( tempMinPostTime, tempExerciseStart );
    cDuration = new Post_Time( tempMaxPostTime, "00:00:00" );
    
    title = tempExerciseTitle; 
    userRotate = 0;
    deltaRotate = userRotate;
    //f = createFont("SansSerif.plain-12.vlw", 12 );                       // spiralFont is a global variable for easy modification
    titleSize = 20;
    spokeFontSize = 11;
    spokeFreqBar = color( 40, 40, 40 );
    
    buildSpokes( tempFuncs, tempMaxPostTime, _artefacts );
    hasData = tempHasData; 
  } // end constructor Spiral



  
  // Overloaded constructor for use with live database "streaming"
  Spiral() {
    super();
    x = 350 + ( ( width - 350 ) / 2 );   // hard-coded to width of the left panel (350)
    y= height / 2;
    diam = 200;
    rad = diam / 2;
    spokes = new ArrayList();  // just creates an empty spokes ArrayList, to be populated later
    maxPostTime = 0;
    cExerciseStart = null;
    cMaxPostTime = null;
    cMinPostTime = null;
    cDuration = new Post_Time( maxPostTime, "00:00:00" );
    
    title = ""; 
    userRotate = 0;
    deltaRotate = userRotate;
    //f = createFont("SansSerif.plain-12.vlw", 12 );                       // spiralFont is a global variable for easy modification
    titleSize = 20;
    spokeFontSize = 11;
    spokeFreqBar = color( 40, 40, 40 );
    
    hasData = false; 
  } // end overloaded constructor
  
  
  
  void sproutSpiral( String tempExerciseStart, String tempExerciseTitle ) {
    setStartTime( tempExerciseStart );
    setTitle( tempExerciseTitle );  
    pdfName = tempExerciseTitle + ".pdf";
    cExerciseStart = new Post_Time( 0, tempExerciseStart );  // the timings should be updated upon addSpokes()
    cMaxPostTime = new Post_Time( 0, tempExerciseStart );
    cMinPostTime = new Post_Time( 0, tempExerciseStart );
    title = tempExerciseTitle; 
  } // end sproutSpiral()



  // Methods

  void growSpokes( Table t ) {
    super.populateFuncs( t );
    print( "Applying Datastream To Spiral ... " );
    addSpokes( funcs, lastCountForFuncs, minPostTime, maxPostTime, t );
    updateHasData();
    String tempExerciseStart = t.getString( 0, 0 );
    updateTimings( tempExerciseStart, minPostTime, maxPostTime );
    println( "Spiral spoke count is now " + spokes.size() + " [ DONE ]" );
  }  // end applyToSpiral()

  void updateTimings( String tempExerciseStart, int tempMinPostTime, int tempMaxPostTime ) {
    maxPostTime = tempMaxPostTime;
    cMaxPostTime = new Post_Time( maxPostTime, tempExerciseStart );
    cMinPostTime = new Post_Time( tempMinPostTime, tempExerciseStart );
    cDuration = new Post_Time( maxPostTime, "00:00:00" );
  }  // end updateTimings()



  
  void display() {
    textFont( spiralFont );
    clearPanel();
    drawYolk();    
    drawSpokes();
    drawTitle();
    drawMouseOverFunc();
    drawMouseOverFreq();
  } // end display()



  
  void buildSpokes( ArrayList tempFuncs, int ctempMaxPostTime, Table _artefacts ) {
    // this will build an ArrayList of Spoke objects, using the input of an ArrayList of Function objects
    // go through the ArrayList, check for duplication and set genesis and frequency appropriately, 
    for( int i = 0; i < tempFuncs.size(); i++ ) {
      Function tf = ( Function ) tempFuncs.get( i );
      int dup = 0; 
      int sumDup = 0;
      if( spokes.size() == 0 ) {                                          // first entry of the spokes list
        spokes.add( new Spoke( _artefacts, tf.serialNum ) );
        Spoke newS = ( Spoke ) spokes.get( spokes.size() - 1 );
        newS.genesis = tf.postTime;
        newS.cGenesis = new Post_Time( newS.genesis, "00:00:00" );
        newS.mappedLength = map( float(newS.genesis), 0.0, float(ctempMaxPostTime), 0.0, 200.0 );
	// newS.freq++;                                              // is this the OFF BY ONE BUG?
      } else {
        for( int j = 0; j < spokes.size(); j++ ) {                   // subsequent entry to the spokes list, need to check for duplication
        Spoke s = ( Spoke ) spokes.get( j );
          if( tf.funcString.equals( s.funcString ) ) {
            s.freq ++;
            dup ++;
            // check if need to update s' genesis and cGenesis
            if( s.genesis > tf.postTime ) {
              s.genesis = tf.postTime;
              s.cGenesis = new Post_Time( s.genesis, "00:00:00" );
            } // end of checking
          }
          sumDup += dup;
        } // end for j
        if( sumDup == 0 ) {      // no duplicates found in the current ArrayList of j Spoke objects
          spokes.add( new Spoke( _artefacts, tf.serialNum ) );
          Spoke newS = ( Spoke ) spokes.get( spokes.size() - 1 );
          newS.genesis = tf.postTime;
          newS.cGenesis = new Post_Time( newS.genesis, "00:00:00" );
          newS.mappedLength = map( float(newS.postTime), 0.0, float(ctempMaxPostTime), 0.0, 200.0 );
        } // end if sumDup == 0
      } // end else
    } // end for i
  } // end buildSpokes()



 
  void addSpokes( ArrayList tempFuncs, int tempLastCountForFuncs, int tempMinPostTime, int tempMaxPostTime, Table tempTable ) {
    // this will add Spoke objects into the Arraylist spokes, using the input of an ArrayList of Function objects
    // go through tempFuncs, check for duplication and set genesis and frequency appropriately, 
    for( int i = tempLastCountForFuncs; i < tempFuncs.size(); i++ ) {
      Function tf = ( Function ) tempFuncs.get( i );
      int dup = 0; 
      int sumDup = 0;
      
      if( spokes.size() == 0 ) {     // first entry of the spokes list
        spokes.add( new Spoke( tempTable, i + 1, tf.serialNum ) );
        Spoke newS = ( Spoke ) spokes.get( spokes.size() - 1 );
        newS.genesis = tf.postTime;
        newS.cGenesis = new Post_Time( newS.genesis, "00:00:00" );
        // newS.freq++;                 // is this the OFF BY ONE BUG?
      
    } else {
      for( int j = 0; j < spokes.size(); j++ ) { // subsequent entry to the spokes list, need to check for duplication
          Spoke s = ( Spoke ) spokes.get( j );
          if( tf.funcString.equals( s.funcString ) ) {
            s.freq ++;
            dup ++;
            // check if need to update s' genesis and cGenesis
            if( tf.postTime < s.genesis ) {
              s.genesis = tf.postTime;
              s.cGenesis = new Post_Time( s.genesis, "00:00:00" );
            } // end of checking
          }
          sumDup += dup;
        } // end for j
        if( sumDup == 0 ) {      // no duplicates found in the current ArrayList of j Spoke objects
          spokes.add( new Spoke( tempTable, 0 - tempLastCountForFuncs + i + 1, tf.serialNum ) );
          Spoke newS = ( Spoke ) spokes.get( spokes.size() - 1 );
          newS.genesis = tf.postTime;
          newS.cGenesis = new Post_Time( newS.genesis, "00:00:00" );
        } // end if sumDup == 0
      } // end else
    } // end for i
    // println( "Done adding spokes. Count of spokes is now " + spokes.size() );
    updateSpokesMappedLength( tempMaxPostTime );
  } // end addSpokes()




  void updateSpokesMappedLength( int tempMaxPostTime ) {
  // Need to do an update on the spokes' mappedLength after adding new spokes, which has a new maxPostTime
    for( int i = 0; i < spokes.size(); i ++ ) {
      Spoke newS = ( Spoke ) spokes.get( i );
      newS.mappedLength = map( float(newS.genesis), 0.0, float(tempMaxPostTime), 0.0, 200.0 );
    }  
  } // end updateSpokesMappedLength()
  



  void computeCRVTotal() {
    crvTotal = 0;
    for( int i = 0; i < spokes.size(); i++ ) {  
      Spoke s = ( Spoke ) spokes.get( i );  
      crvTotal += s.crvScore;
    } // end for i
    crvTotal = myRound( crvTotal, 2 );
  } // end computeCRVTotal()
  



  boolean checkMouseFunc( Spoke sMouse, int xCheck, int yCheck ) {
    if( dist( xCheck, yCheck, sMouse.outerX, sMouse.outerY ) < 5 ) {
      sMouse.xMOFunc = xCheck;
      sMouse.yMOFunc = yCheck;
      return true;
    } else 
      return false;
  } // end checkMouseFunc()
  



  boolean checkMouseFreq( Spoke sMouse, int xCheck, int yCheck ) {
    if( dist( xCheck, yCheck, sMouse.innerX, sMouse.innerY ) < 5 ) {
      sMouse.xMOFreq = xCheck;
      sMouse.yMOFreq = yCheck;
      return true;
    } else 
      return false;
  } // end checkMouseFreq()




  void clearPanel() {
    fill( 255 );
    stroke( 255 );
    rectMode( CORNERS );
    rect( 152, 0, width, height );
  } // end clearPanel()




  void drawYolk() {
    if( !hasData ) {           // Message display to notify user that no data is available for this class
      stroke( popUpTxt );
      fill( popUpBkgrd );
      rectMode( CORNER );
      textSize( 30 );
      rect( x - ( (  textWidth( "No Data For This Class" ) ) / 2 ) - 10, y - 30, textWidth( "No Data For This Class" ) + 18, 40 );
      rectMode( CORNERS );
      fill( popUpTxt );   
      text( "No Data For This Class", x - ( (  textWidth( "No Data For This Class" ) ) / 2 ), y ); 
    } else { // if hasData is true
      fill( 128 );
      strokeWeight( 1 );
      stroke( 40 );
      ellipse( x, y, diam, diam );                                    // draw the yolk
    } // end if hasData is true
  } // end drawYolk()




  void drawSpokes() {
    //textFont( f );
    textSize( spokeFontSize );
    
    if( round( deltaRotate ) != round( userRotate ) ) {
    deltaRotate = deltaRotate + ( ( userRotate - deltaRotate ) / 2 );
    /*
    if( deltaRotate > 360 )
      deltaRotate = deltaRotate - 360;
    if( deltaRotate < 0 )
      deltaRotate = 360 - deltaRotate;
    */
    }
    
    float angleinc = 360 / float( spokes.size() );
  
    for( int f = 0; f < spokes.size(); f++ ) {
      Spoke s = (Spoke) spokes.get( f );
    
      s.baseX = ( cos( radians( ( angleinc * f ) + deltaRotate ) ) * rad ) + x;                                               // positioning the spoke
      s.baseY = ( sin( radians( ( angleinc * f ) + deltaRotate ) ) * rad ) + y;
      s.outerX = ( cos( radians( ( angleinc * f ) + deltaRotate ) ) * ( rad + s.mappedLength ) ) + x;
      s.outerY = ( sin( radians( ( angleinc * f ) + deltaRotate ) ) * ( rad  + s.mappedLength ) ) + y;
    
      s.shortX = ( cos( radians( ( angleinc * f ) + deltaRotate ) ) * ( rad - 5 ) ) + x;                                               // positioning the freq count of the spoke
      s.shortY = ( sin( radians( ( angleinc * f ) + deltaRotate ) ) * ( rad - 5 ) ) + y;
      s.innerX = ( cos( radians( ( angleinc * f ) + deltaRotate ) ) * ( ( rad - 5 ) - s.freq ) ) + x;
      s.innerY = ( sin( radians( ( angleinc * f ) + deltaRotate ) ) * ( ( rad - 5 ) - s.freq ) ) + y;
    
      stroke ( s.c );
      strokeWeight( 1 );
      line( s.baseX, s.baseY, s.outerX, s.outerY );        // draw spoke
    
      stroke( spokeFreqBar );
      strokeWeight( 2 );
      line( s.innerX, s.innerY, s.shortX, s.shortY );            // draw freq bar
    
      fill( 0 );
      textSize( spokeFontSize );                                  // draw text function string
      if( ( ( ( angleinc * f ) + deltaRotate ) % 360 > 90 ) && ( ( ( angleinc * f ) + deltaRotate ) % 360 < 270 ) ) { // determining text orientation for the left half of the spiral
        pushMatrix();
        translate( s.outerX, s.outerY );
        rotate( radians( ( angleinc * f ) + deltaRotate - 180 ) );
        textSize( spokeFontSize );      
        markUncleaned( s, ( angleinc * f ) + deltaRotate );    // this will highlight all spokes that are still "uncleaned" after all the processing so far (e.g. #Name?, 0 crvScore )
        fill( 0, 0, 0, 255 );
        text( s.funcString, 0 - textWidth( s.funcString ), 0 );
        popMatrix();
      
      } else {                                                            // determining text orientation for the right half of the spiral
      
        pushMatrix();
        translate( s.outerX, s.outerY );
        rotate( radians( ( angleinc * f ) + deltaRotate ) );
        markUncleaned( s, ( angleinc * f ) + deltaRotate );
        /*
        if( s.funcString.equals("#NAME?") ) {                 // markings for "#Name?" function strings
          fill( 200, 0, 0, 127 );
          rect( 0, 0, textWidth( s.funcString ), -15 );
        } 
	*/
        fill( 0, 0, 0, 255 );
        text( s.funcString, 0, 0 );
        popMatrix();
      } // end for determining text orientation
    
      // determining mouse over
      s.isMouseOverFunc = checkMouseFunc( s, mouseX, mouseY );
      if( !s.isMouseOverFunc ) {
        s.isMouseOverFunc = checkMouseFunc( s, myJays[0].xPos, myJays[0].yPos );
        if( !s.isMouseOverFunc ) 
          s.isMouseOverFunc = checkMouseFunc( s, myJays[1].xPos, myJays[1].yPos );
      }
      
      s.isMouseOverFreq = checkMouseFreq( s, mouseX, mouseY );
      if( !s.isMouseOverFreq ) {
        s.isMouseOverFreq = checkMouseFreq( s, myJays[0].xPos, myJays[0].yPos );
        if( !s.isMouseOverFreq )
          s.isMouseOverFreq = checkMouseFreq( s, myJays[1].xPos, myJays[1].yPos );
      }   
    } // end for f
  } // end drawSpokes()




  void drawTitle() {
    stroke( 0 );                                                                    // draw spiral title
    strokeWeight( 1 );
    fill( 255 );
    textSize( titleSize );
    rect( 350 + ( width - 350 ) / 2 - ( ( textWidth( title ) + 10 )/ 2 ), 0, 350 + ( width - 350 ) / 2 + ( ( textWidth( title ) + 10 ) / 2 ), 30 );
    fill( 0 );
    text( title, 350 + ( width - 350 ) / 2 - textWidth( title ) / 2, 22 );
  } // end drawTitle()




  void drawMouseOverFunc() {
    for( int k = 0; k < spokes.size(); k++ ) {
      Spoke mouseS = ( Spoke ) spokes.get( k );
      if( mouseS.isMouseOverFunc ) {
        gWidth = getGnsTextWidth();
        pWidth = getPopUpWidth( mouseS.funcString );
        if( pWidth >= gWidth )
          positionPopUpFunc( mouseS, pWidth );
        else {
         pWidth = gWidth;
        positionPopUpFunc( mouseS, pWidth ); 
        }
        drawPopUpFunc( mouseS.funcString, mouseS.cGenesis.getPost_Time_Mins(), mouseS.freq, mouseS.crvScore );
      } // end if
    } // end for k
  } // end void drawMouseOverFunc()
  



  void drawMouseOverFreq() {
    for( int k = 0; k < spokes.size(); k++ ) {
      Spoke mouseS = ( Spoke ) spokes.get( k );
      if( mouseS.isMouseOverFreq ) {
        pWidth = getPopUpWidth( Integer.toString(mouseS.freq) );
        positionPopUpFreq( mouseS, pWidth );
        drawPopUpFreq( Integer.toString(mouseS.freq) );
      } // end if
    } // end for k
  } // end void drawMouseOverFreq()
  



  float getGnsTextWidth() {
    textSize( 10 );
    float gTextWidth = textWidth( "Genesis: XX:XX          Freq: XXX          CRV Score: XXX.XX" );
    return gTextWidth;
  } // end getGnsTextWidth()



  
  float getPopUpWidth( String popUpString ) {
    textSize( 16 );
    return( textWidth( popUpString ) + 10 );
  } // end getPopUpWidth()
  



  void positionPopUpFunc( Spoke s, float _pWidth ) {
    if( s.xMOFunc + _pWidth < width ) {                 // if PopUp doesnt protrude the right hand side of the spiral panel
      px1 = s.xMOFunc - 5;
      py1 = s.yMOFunc - 30;
      px2 = px1 + _pWidth;
      py2 = py1 + 25; 
    } else {                                                       // if PopUp protrudes out of the right hand side of the spiral panel
      px1 = width - ( _pWidth + 5 );
      py1 = s.yMOFunc - 30;
      px2 = px1 + _pWidth;
      py2 = py1 + 25;
    }
  } // end positionPopUpFunc()
  



  void positionPopUpFreq( Spoke s, float _pWidth ) {
    if( s.xMOFreq + _pWidth < width ) {                 // if PopUp doesnt protrude the right hand side of the spiral panel
      px1 = s.xMOFreq - 5;
      py1 = s.yMOFreq - 30;
      px2 = px1 + _pWidth;
      py2 = py1 + 25; 
    } else {                                                       // if PopUp protrudes out of the right hand side of the spiral panel
      px1 = width - ( _pWidth + 5 );
      py1 = s.yMOFreq - 30;
      px2 = px1 + _pWidth;
      py2 = py1 + 25;
    }
  } // end positionPopUpFreq()
  



  void drawPopUpFunc( String popUpString, String gen, int frq, float crvScore ) {
    fill( popUpBkgrd );
    stroke( popUpTxt );
    rectMode( CORNERS );
    rect( px1, py1 - 20, px2, py2 );
    fill( popUpTxt );
        textSize( 16 );
        text( popUpString, px1 + 5, py2 - 25 );
        textSize( 10 );
        text( "Genesis: " + gen + "          Freq: " + ( frq ) + "          CRV Score: " + crvScore , px1 + 5, py2 - 7 );
  } // end drawPopUpFunc
  



  void drawPopUpFreq( String popUpString) {
    fill( popUpBkgrd );
    stroke( popUpTxt );
    rectMode( CORNERS );
    rect( px1, py1, px2, py2 );
    fill( popUpTxt );
        textSize( 16 );
        text( popUpString, px1 + 5, py2 - 5 );
  } // end drawPopUpFreq



  
  int getMaxPostTime() {
   return maxPostTime; 
  } // end getMaxPostTime()



  
  float getMaxMetric() {
    float mm = 0.0;
    for( int i = 0; i < spokes.size(); i++ ) {
      Spoke s = ( Spoke ) spokes.get( i );
      if( s.crvScore > mm ) {
        mm = s.crvScore; 
      }
    } // end for i  
    return myRound( mm, 2 );
  } // end getMaxMetric()
  



  void markUncleaned( Spoke _s, float sAngle ) {        // markings for "#Name?" function strings
    /* Do Nothing - this maybe temporary
    float xOrientation = 0;
    float yOrientation = 0;
    if( ( sAngle % 360 > 90 ) && ( sAngle % 360 < 270 ) ) {
      xOrientation = 0 - textWidth( _s.funcString );
      yOrientation = -10;
    } else { 
       xOrientation = textWidth( _s.funcString );
       yOrientation = -10;
    }
    if( _s.funcString.equals("#NAME?") ) {                // Mark "#Name?" funcString
      fill( 255, 0, 0, 127 );
      noStroke();
      rect( 0, 0, xOrientation, yOrientation );
    } else if( _s.crvScore == 0 ) {                              // Mark Zero CRV Score
      fill( 250, 150, 0, 127 );
      noStroke();
      rect( 0, 0, xOrientation, yOrientation );
    }            
    */
  } // end markUncleaned()
        
        
        
        
  public void rotateClockWise() {
    userRotate += 360 / spokes.size();
    if( userRotate > 360 ) {
      userRotate = abs( userRotate ) - 360;
      deltaRotate = abs( deltaRotate ) - 360; 
    }
  } // end rorateClockwise()

        
        
        
  public void rotateCounterClockWise() {
    userRotate -= 360 / spokes.size();
    if( userRotate < 0 ) {
      userRotate = 360 - abs( userRotate );
      deltaRotate = 360 - abs( deltaRotate );
    }
  } // end rorateCounterClockwise()
        


        
  public void rotateReset() {
    userRotate = 0;
  } // end rotateReset()
  



  public int getSpokesCount() {
    return spokes.size();
  }




  public void updateHasData() {
    if( getSpokesCount() > 0 )
      hasData = true;
    else
      hasData = false;
  } // end updateHasData()




  public String toString() {
    String ret = "";
    ret += ( "=====================================" + "\n" );
    ret += ( "Spiral Object Instance Details: " + "\n" );
    ret += ( "title: " + title + "\n" );
    ret += ( "cExerciseStart: " + cExerciseStart + "\n" );
    ret += ( "cDuration: " + cDuration + "\n" );
    ret += ( "cMinPostTime: " + cMinPostTime + "\n" );
    ret += ( "cMaxPostTime: " + cMaxPostTime + "\n" );
    ret += ( "hasData: " + hasData + "\n" );
    ret += ( "x, y, diam and rad: " + x + " " + y + " " + diam + " " + rad + "\n" );
    ret += ( "pWidth: " + pWidth + "     " + "gWidth: " + gWidth + "\n" );
    ret += ( "px1: " + px1 + "     py1: " + py1 + "\n" );
    ret += ( "px2: " + px2 + "     py2: " + py2 + "\n" );
    ret += ( "number of spokes: " + spokes.size() + "\n" );
    ret += ( "Now printing the spokes:" + "\n" );
    ret += ( "------------------------" + "\n" );
    for( int i = 0; i < spokes.size(); i++ ) {
      Spoke s = ( Spoke ) spokes.get( i );
      ret += ( s + "\n" );
    }
    ret += ( "------------------------" + "\n" );
    ret += ( "crvTotal: " + crvTotal + "\n" );
    ret += ( "=====================================" + "\n" );
    return ret;
  } // end toString()



      
} // end class Spiral
