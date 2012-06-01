class Student {

  // Fields

  String studentID;
  ArrayList <WavePt> wavePoints;
  int serialNum, dispOrder;
  float x1InView, y1InView, x2InView, y2InView;
  boolean mouseOver;



  // Constructor

  Student( Table t, int row, int sn ) {
    serialNum = sn;
    dispOrder = serialNum;
    studentID = t.getString( row, 1 );
    wavePoints = new ArrayList(); 
    // wavePoints are NOT added here, 
    // but via Wave.addWavePoints() instead.
    x1InView = -1;
    y1InView = -1;
    x2InView = -1;
    y2InView = -1;
    mouseOver = false;
  } // end constructor


  
  // Methods

  void display( View v, int printPos ) {
    float whiteSpace = 10;
    v.putTextFont( waveFont, 15 );
    x1InView = whiteSpace;
    x2InView = x1InView + textWidth( studentID );
    y2InView = printPos * 15; // NOTE: assuming row height is 15 pixels per row
    y1InView = y2InView - v.viewTextSize;
    fill( 0 );
    v.putText( studentID, x1InView, y2InView );

    updateMouseOVer( v );
    if( mouseOver )
      drawMouseOver( v );
  } // end display()




  void updateMouseOVer( View v ) {
    if( mouseX >= x1InView + v.x1a - v.xScrollPos1 && mouseX <= x2InView + v.x1a - v.xScrollPos1 && mouseY >= y1InView + v.y1a - v.yScrollPos1 && mouseY <= y2InView + v.y1a - v.yScrollPos1 )
      mouseOver = true;
    else
      mouseOver = false;
  } // end updateMouseOver()




  void drawMouseOver( View v ) {
    String s1 = studentID + "          Contributions:";
    String s2 = ( "Count   : " + wavePoints.size() );
    String s3 = ( "First @ : " + wavePoints.get( 0 ).cPostTime );
    String s4 = ( "Last @  : " + wavePoints.get( wavePoints.size() - 1 ).cPostTime );
    v.putTextSize( 20 );
    float[] tWidths = { textWidth(s1), textWidth(s2), textWidth(s3), textWidth(s4) };
    float tWidth = max( tWidths );
    float whiteSpace = 5;
    float lx1 = ( (mouseX-v.x1a) - (tWidth*0) - whiteSpace) + v.xScrollPos1;
    float ly1 = ((mouseY-v.y1a) - (4*v.viewTextSize) - whiteSpace - 5 ) + v.yScrollPos1;	  float lx2 = lx1 + tWidth + (2*whiteSpace);
    float ly2 = ly1 + (4*v.viewTextSize) + (2*whiteSpace);

    rectMode( CORNERS );
    stroke( popUpTxt );
    v.putRect( lx1, ly1, lx2, ly2 );
    fill( popUpTxt );
    v.putText( s1, lx1 + whiteSpace, ly2-whiteSpace-(3*v.viewTextSize) );
    v.putText( s2, lx1 + whiteSpace, ly2-whiteSpace-(2*v.viewTextSize) );
    v.putText( s3, lx1 + whiteSpace, ly2-whiteSpace-(1*v.viewTextSize) );
    v.putText( s4, lx1 + whiteSpace, ly2-whiteSpace-(0*v.viewTextSize) );
  } // end drawMouseOver()




  String getStudentID() {
    return studentID;
  } // end getStudentID()



  Student callFor( String sid ) {
    if( sid.equals( studentID ) )
      return this;
    else
      return null;
  } // end callFor()



  boolean hasFunction( String fString ) {
    for( int i = 0; i < wavePoints.size(); i++ ) {
      WavePt w = wavePoints.get( i );
      if( w.funcString.equals( fString ) ) {
        return true;
      }
    }
    return false;
  } // end hasFunction()



  WavePt getWavePoint( String fString ) {
    for( int i = 0; i < wavePoints.size(); i++ ) {
      WavePt w = wavePoints.get( i );
      if( w.funcString.equals( fString ) ) {
        return w;
      }
    }
    return null;
  } // end getWavePoint()




  void resetOrder() {
    dispOrder = serialNum;
  } // end resetOrder()



} // end class Student
