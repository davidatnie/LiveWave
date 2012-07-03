class Student {

  // Fields

  String studentID;
  ArrayList <WavePt> wavePoints;
  int serialNum, dispOrder;
  float x1InView, y1InView, x2InView, y2InView;
  boolean mouseOver;
  boolean onShow;
  int sortingIndex;


;



  // Constructor

  Student( Table t, int row, int sn ) {
    serialNum = sn;
    dispOrder = serialNum;
    studentID = t.getString( row, 2 );
    wavePoints = new ArrayList(); 
    // wavePoints are NOT added here, 
    // but via Wave.addWavePoints() instead.
    x1InView = -1;
    y1InView = -1;
    x2InView = -1;
    y2InView = -1;
    mouseOver = false;
    onShow = true;
    sortingIndex = dispOrder;
  } // end constructor


  
  // Methods

  void display( View v, int printPos ) {
    if( dispOrder != -1 ) {
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
    }
  } // end display()




  void updateMouseOVer( View v ) {
    if( v.mouseWithin && mouseX >= x1InView + v.x1a - v.xScrollPos1 && mouseX <= x2InView + v.x1a - v.xScrollPos1 && mouseY >= y1InView + v.y1a - v.yScrollPos1 && mouseY <= y2InView + v.y1a - v.yScrollPos1 )
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
    float lx2 = lx1 + tWidth + (2*whiteSpace);
    float ly1 = ( (mouseY-v.y1a) - (4*v.viewTextSize) - whiteSpace - 5 ) + v.yScrollPos1;
    float ly2 = ly1 + (4*v.viewTextSize) + (2*whiteSpace);
    
    // make sure mouseOver box will be displayd inside the View
    if( lx1 < v.xScrollPos1 ) {
      float lWidth = lx2 - lx1;
      lx1 = v.xScrollPos1 + 20;
      lx2 = lx1 + lWidth; 
    } else if( lx2 > v.xScrollPos2 ) {
      float lWidth = lx2 - lx1;
      lx2 = v.xScrollPos2 - 20;
      lx1 = lx2 - lWidth;
    }
    if( ly1 < v.yScrollPos1 ) {
      float lHeight = ly2 - ly1;
      ly1 = v.yScrollPos1 + 20;
      ly2 = ly1 + lHeight;
    } else if( ly2 > v.yScrollPos2 ) {
      float lHeight = ly2 - ly1;
      ly2 = v.yScrollPos2 - 20;
      ly1 = ly2 - lHeight;
    }
    
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




  boolean hasFunction( ArrayList<String> fs ) {
    int numHit = 0;
    for( String fString : fs ) {
      if( hasFunction( fs ) )
        numHit++;  
    }
    if( numHit == 0 )
      return false;
    else
      return true;
  } // end hasFunction()




  int countDisplayedWps() {
    int num = 0;
    for( WavePt wp : wavePoints )
      if( wp.onShow )
        num++;
    return num;
  } // end countDisplayedWps()



  
  int getPostTimeFor( String eq ) {
    if( getWavePoint( eq ) == null )
      return -1;
    else
      return getWavePoint( eq ).postTime;
  } // end getPostTimeFor()



  int getPostTimeFor( ArrayList<String> eqs ) {
    int earliest = 30000;
    for( String eq : eqs )
      if( getPostTimeFor( eq ) <= earliest )
        earliest = getPostTimeFor( eq );
    return earliest;
  } // end getPostTimeFor()




  int getEarliestPostTime() {
    int earliest = 30000;
    if( wavePoints == null || countDisplayedWps() == 0 )
      return -1;
    else {
      for( WavePt wp : wavePoints )
        if( wp.onShow )
          if( wp.postTime <= earliest )
            earliest = wp.postTime;
    }
    return earliest;
  } // end getEarliestPostTime()




  int getEarliestPostTimeForSelEqs( ArrayList<String> sel ) {
    int earliest = 30000;
    for( WavePt wp : wavePoints )
      if( wp.onShow ) 
        if( wp.postTime < earliest )
          earliest = wp.postTime;
    return earliest;
  } // end getEarliestPosttimeForSelEqs()




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




  boolean hasWpSelCodes( ArrayList<String> input ) {
    boolean ret = false;
    for( WavePt wp : wavePoints )
      if( wp.hasSelCodes( input ) )
        ret = true;
    return ret;
  } // end hasWpSelCodes()




  boolean hasWpNoCodes() {
    boolean ret = false;
    for( WavePt wp : wavePoints )
      if( wp.hasNoCodes() )
        ret = true;
    return ret;
  } // end hasWpNoCodes()





} // end class Student
