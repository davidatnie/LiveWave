class Student {

  // Fields

  String studentID;
  ArrayList <WavePt> wavePoints;
  int serialNum, dispOrder;




  // Constructor

  Student( Table t, int row, int sn ) {
    serialNum = sn;
    dispOrder = serialNum;
    studentID = t.getString( row, 1 );
    wavePoints = new ArrayList(); 
    // wavePoints are NOT added here, 
    // but via Wave.addWavePoints() instead.
  } // end constructor


  
  // Methods

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
