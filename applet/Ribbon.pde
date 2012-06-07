// belongs to Wave Visualizer

class Ribbon {

  // Fields
  
  Wave owner;
  View view;
  float x, y, x1OnShow, x2OnShow, oneMinLength, maxMins, maxLength, depthOffset, viewPrintOffset;
  int minsCount;
  float x1TArea, y1TArea, x2TArea, y2TArea, xTPos; // the coordinates of the Thread positioner 



  // Constructor
  Ribbon( Wave o ) {
    owner = o;
    oneMinLength = 60;
    maxMins = 11;
    maxLength = 720;
    depthOffset = 50;
    viewPrintOffset = 100; // needed so contribs plotted and ribbon points correctly allign. This is basically the value of the "Western Border" of the View
    x = 300 + depthOffset + viewPrintOffset ;
    y = 150;
    minsCount = ceil( owner.maxPostTime / 60 );
    
    x1TArea = x;
    y1TArea = y - 50;
    x2TArea = x1TArea + maxLength;
    y2TArea = y;
    updateTPos(); // xTPos is set within this method
  } // end constructor




  // Methods

  void display( View view ) {
    updateMinsCount();
    drawAxes( view );
    drawRibbon( view );
    drawTArea( view );
  } // end display()




  void updateMinsCount() {
    minsCount = ceil( owner.maxPostTime / 60 );
    if( minsCount > maxMins ) {
      maxMins = minsCount;
      oneMinLength = ( 720 - 60 ) / maxMins; // one min ( 60 secs is for decorative purpose only 
    }
  } // end updateMinsCount()




  void drawAxes( View view ) {
  // draw ribbon axes
    fill( 0, 255, 0 );
    textSize( 10 );
    text( "Timeline (mins) :", x, y - 40 - 3 );
   
    // the three axes
    stroke( 0, 255, 0 );
    line( x, y, x + maxLength, y );
    line( x, y, x, y-50 );
    line( x, y, x - depthOffset, y + depthOffset );
    
    // draw notches
    int notch = 1;
    float xnotch = x;
    while( notch < ceil( maxLength / oneMinLength ) ) {
      xnotch = ( notch * oneMinLength ) + x;
      float notchHeight = 15;
      if( notch != 0 && notch %5 == 0 )
        notchHeight = 30;
      stroke( 0, 255, 0 );
      line( xnotch, y, xnotch, y-notchHeight );
      fill( 0, 255, 0 );
      textSize( 10 );
      text( notch, xnotch - 3, y - 3 - notchHeight   );
      notch++;
    }
  } // end drawAxes()




  void drawRibbon( View view ) {
    for( WavePt rwp : owner.wavePoints ) {
        stroke( rwp.waveRadc );
        float pointOnRibbon = map( rwp.postTime, 0, maxMins*60, x, x+maxMins*oneMinLength );
	line( pointOnRibbon, y, pointOnRibbon-depthOffset, y+depthOffset );
    }
    // draw ending line
      stroke( 255, 90, 50 ); // orangey color
      float endingPointOnRibbon = map( owner.maxPostTime, 0, maxMins*60, x,x + maxMins*oneMinLength  ) + 1;
      line( endingPointOnRibbon, y, endingPointOnRibbon - depthOffset, y + depthOffset );
      line( endingPointOnRibbon, y, endingPointOnRibbon, y - 37 );
      fill( 255, 90, 50 );
      textSize( 10 );
      text( "end", endingPointOnRibbon - 10, y - 40 );
  } // end drawRibbon()


  
  
  void drawTArea( View v ) {
    updateTPos();
    if( xTPos  != -1 ) {
      stroke( 255, 0, 255 ); // purple color
      strokeWeight( 1 );
      line( x + xTPos, y1TArea, x + xTPos, y );
      line( x + xTPos - depthOffset, y+ depthOffset, x + xTPos, y ); 
    }
  } // end drawTArea()
  
  
  
  
  void drawThreadInView( View v ) {
  // draws the portion of the thread that's inside the View
  // This can not be combined into drawTArea because it belongs to
  // drawing that should be done WITHIN the view ( and which is called from
  // Activity.render() instead of Activity.prerender() ). This is due to the 
  // MASKING step done before render()
  //
    stroke( 255, 0, 255 ); // purple
    if( xTPos != -1 ) {
      strokeWeight( 1 );
      v.putLine( viewPrintOffset + xTPos, 0, viewPrintOffset + xTPos, v.contentHeight );
    }
  } // end drawThreadInView()
  
  
  
  
  void updateTPos() {
  // updates the position of the Thread Indicator (along the timeline)
  // sets xTPos to -1 if mouse pointer is outside of the Thread Area
  //
    if( mouseX >= x1TArea && mouseX <= x2TArea && mouseY >= y1TArea && mouseY <= y2TArea )
      xTPos = mouseX - x;
    else if( mouseX >= x1TArea-(mouseY-y2TArea) && 
             mouseX <= x2TArea-(mouseY-y2TArea) && 
             mouseY > y2TArea && mouseY <= y2TArea + depthOffset ) {
      xTPos = mouseX - x + ( mouseY-y2TArea );
    } else 
      xTPos = -1;
  } // end updateTPos()

} // end class Ribbon
