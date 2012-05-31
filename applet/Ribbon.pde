// belongs to Wave Visualizer

class Ribbon {

  // Fields
  
  Wave owner;
  View view;
  float x, y, x1OnShow, x2OnShow, oneMinLength, maxLength, depthOffset, viewPrintOffset;
  int minsCount;



  // Constructor
  Ribbon( Wave o ) {
    owner = o;
    oneMinLength = 60;
    maxLength = 12 * oneMinLength;
    depthOffset = 50;
    viewPrintOffset = 100; // needed so contribs plotted and ribbon points correctly allign. This is basically the value of the "Western Border" of the View
    x = 300 + depthOffset + viewPrintOffset ;
    y = 150;
    x1OnShow = x;
    x2OnShow = x1OnShow + maxLength;
    minsCount = ceil( owner.maxPostTime / 60 );
  } // end constructor




  // Methods

  void display( View view ) {
    updateOnShows( view );
    drawAxes( view );
    drawRibbon( view );
  } // end display()




  void updateOnShows( View view ) {
    x1OnShow = view.xScrollPos1;
    x2OnShow = x1OnShow + maxLength;
    minsCount = ceil( owner.maxPostTime / 60 );
  } // end updateOnShows()




  void drawAxes( View view ) {
  // draw ribbon axes
    fill( 0, 255, 0 );
    textSize( 10 );
    text( "Timeline :", x, y - 20 - 3 );
   
    // the three axes
    stroke( 0, 255, 0 );
    line( x, y, x + maxLength, y );
    line( x, y, x, y-30 );
    line( x, y, x - depthOffset, y + depthOffset );
    
    // find out the next notch to display
    int notchStart = floor( x1OnShow / 60 )+1;
    int notch = notchStart;
    float xnotch = x;
    //while( xnotch <= x+maxLength ) {
    while( notch < notchStart + ( maxLength / oneMinLength ) ) {
      xnotch = map( notch * 60, x1OnShow, x2OnShow, x, x+maxLength );
      stroke( 0, 255, 0 );
      line( xnotch, y, xnotch, y-10 );
      fill( 0, 255, 0 );
      textSize( 10 );
      text( notch, xnotch - 3, y - 13   );
      if( notch % 5 == 0 ) {
        fill( 0, 255, 0 );
	textSize( 10 );
	text( "mins", xnotch + 10, y - 13 );
      }
      notch++;
    }
  } // end drawAxes()




  void drawRibbon( View view ) {
    for( WavePt rwp : owner.wavePoints ) {
      if( rwp.postTime >= x1OnShow && rwp.postTime <= x2OnShow )
      {
        stroke( rwp.waveRadc );
	line( rwp.postTime-x1OnShow+x, y, rwp.postTime-x1OnShow+x-depthOffset, y+depthOffset );
      }
    }
    // draw ending line
    if( owner.maxPostTime >= x1OnShow && owner.maxPostTime <= x2OnShow ) {
      stroke( 255, 90, 50 ); // orangey color
      line( owner.maxPostTime+1 -x1OnShow + x, y, owner.maxPostTime+1 - x1OnShow+x-depthOffset, y + depthOffset );
      line( owner.maxPostTime+1 -x1OnShow + x, y, owner.maxPostTime+1 - x1OnShow+x, y - 40 );
    }
  } // end drawRibbon()

  

} // end class Ribbon
