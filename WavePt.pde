class WavePt extends Function {

  // Fields

  int dispOrder;
  float intensityScore, waveRad, x, y;
  color waveRadc;
  Student student;
  Wave owner;
  String annotation;
  float x1InView, y1InView, x2InView, y2InView;  // the "Screen" x and y values when it is being rendered inside a scrollable View
  boolean isSelected;
  boolean mouseOver;




  // Constructor
  WavePt( Wave o, Table t, int row, int tempSN ) {
    // WavePoints are created after Wave is created
    //
    super( t, row, tempSN );
    owner = o;
    println( " studentID " + studentID );
    student = owner.getStudent( studentID );
    println( "student with ID " + studentID + " added : " + ( student != null ) );
    isSelected = false;
    mouseOver = false;
    annotation = "";
    intensityScore = 0;
    x = o.x;
    y = o.y;
  } // end constructor



  // Methods

  void updateWaveRad() {
    // calculates the radius for this wavePoint, by mapping
    // its postTime from range of owner.minPostTime ~ owner.maxPostTime
    // to range of 0 ~ owner.maxRad  
    // 
    waveRad = map( postTime, 0, owner.maxPostTime, 0, owner.maxRad );
  } // end updateWaveRad()




  void updateWaveRadC() {
    waveRadc = color( floor( intensityScore * owner.rgbPropRate ) + 15 ); // color range is from 15 to 255 NEED TO CONFIRM
  } // end updateWaveRadC()




  void display( View v, float printPos ) {
    float x1Scr = owner.viewPrintOffset + postTime - textWidth( funcString ) - 4;
    float x2Scr = owner.viewPrintOffset + postTime;
    float y2Scr = printPos * 15;
    float y1Scr = y2Scr - v.viewTextSize;
    stroke( 1255, 90, 50 ); // orangey color for Live mode, can't assess for Hit/No-Hit
    strokeWeight( 3 );

    v.putLine( x2Scr, y1Scr, x2Scr, y2Scr );

    strokeWeight( 1 );
    fill( 0 );
    v.putTextFont( waveFont, 12 );	  

    v.putText( funcString, x1Scr, y2Scr );
    setCoordsInView( x1Scr, y1Scr, x2Scr, y2Scr );
    updateMouseOver( v );
    if( isSelected )
      drawSelected( v );
    if( mouseOver )
      drawMouseOver( v );
  } // end display()




  void hide( View v ) {
    setCoordsInView( -1, -1, -1, -1 );
    updateMouseOver( v );
  } // end hide()




  void setCoordsInView( float x1Val, float y1Val, float x2Val, float y2Val ) {
    // This will set the InView coordinate values
    // 
    x1InView = x1Val;
    y1InView = y1Val;
    x2InView = x2Val;
    y2InView = y2Val;
  } // end updateCoordsInView()




  void updateMouseOver( View v ) {
    if ( v.mouseWithin && mouseX > x1InView + v.x1a - v.xScrollPos1 && mouseX < x2InView + v.x1a - v.xScrollPos1 && mouseY > y1InView + v.y1a - v.yScrollPos1 && mouseY < y2InView + v.y1a - v.yScrollPos1) {
      mouseOver = true;
      fill( 0, 0,0, 128 );
      rect( x1InView + v.x1a - v.xScrollPos1, y1InView + v.y1a - v.yScrollPos1,x2InView + v.x1a - v.xScrollPos1, y2InView + v.y1a - v.yScrollPos1);
    }
    else
      mouseOver = false;
  }  // end updateMouseOver()




  void drawSelected( View v ) { 
    stroke( 255, 0, 0 );
    noFill();
    v.putRect( x1InView, y1InView, x2InView, y2InView );
  } // end drawSelected()




  void drawMouseOver( View v ) {
    String s1 = funcString;
    String s2 = student.studentID + "    @ " + cPostTime;
    String s3 = annotation;
    v.putTextSize( 20 );
    float[] textWidths = new float[ 3 ];
    textWidths[ 0 ] = textWidth( s1 );
    textWidths[ 1 ] = textWidth( s2 );
    textWidths[ 2 ] = textWidth( s3 );
    float maxText = max( textWidths );
    stroke( popUpTxt );
    fill( popUpBkgrd );
    float whiteSpace = 5;
    float rowCount = 3;
    float lx1 = ( (mouseX - v.x1a) - (maxText/2) - whiteSpace ) +v.xScrollPos1;
    float lx2 = lx1 + maxText + 2*whiteSpace;
    float ly1 = ((mouseY-v.y1a) - rowCount*v.viewTextSize) - 5 - whiteSpace + v.yScrollPos1;
    float ly2 = ly1 + rowCount*v.viewTextSize + 3*whiteSpace;

    rectMode( CORNERS );
    v.putRect( lx1, ly1, lx2, ly2 );
    fill( popUpTxt );
    v.putText( funcString, lx1+whiteSpace, (ly1+v.viewTextSize) );
    v.putTextSize( 10 );
    v.putText( student.studentID + "    @ " + cPostTime, lx1+whiteSpace, ly1+4*v.viewTextSize );
    v.putTextSize( 20 );
    v.putText( annotation, lx1+whiteSpace, ly2-whiteSpace );
  } // end drawMouseOver()
  
  
  
  
} // end class WavePt

