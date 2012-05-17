class Wave extends Section {

  // Fields
  
  ArrayList <Student> students;
  ArrayList <WavePt> wavePoints;

  // The following fields also exist in class Spiral, consider
  // moving them upclass to become members of class Section instead
  Post_Time cExerciseStart, cMaxPostTime, cMinPostTime, cDuration;
  int maxPostTime;
  String title;
  



  // Constructor

  Wave() {
    super();
    students = new ArrayList();
    wavePoints = new ArrayList();
  } // end constructor




  // Methods

  void sproutWave( String tempExerciseStart, String tempExerciseTitle ) {
    setStartTime( tempExerciseStart );
    setTitle( tempExerciseTitle );
    pdfName = tempExerciseStart + ".pdf";
    cExerciseStart = new Post_Time( 0, tempExerciseStart );
    cMaxPostTime = new Post_Time( 0, tempExerciseStart );
    cMinPostTime = new Post_Time( 0, tempExerciseStart );
    title = tempExerciseTitle;
  } // end sproutWave()




  void growWave( Table t ) {
    super.populateFuncs( t );
    print( "Applying Datastream to Wave ... " );
    addStudents( funcs, lastCountForFuncs, minPostTime, maxPostTime, t );
    addWavePoints( funcs, lastCountForFuncs, t ); 
    updateHasData();
    println( "finished going trhough growWave()" );
  } // end growWave()




  void addWavePoints( ArrayList <Function> tempFuncs, int tempLastCountForFuncs, Table tempTable ) {
    println( "tempLastCountForFuncs, tempFuncs.size() - tempTable.size() " + tempLastCountForFuncs + " " + tempFuncs.size() + "-" + tempTable.getRowCount() );
    for( int i = tempLastCountForFuncs; i < tempFuncs.size(); i++ ) {
      Function tf = tempFuncs.get( i );
      println( "adding wavePoint.. " );
      println( tf );
      wavePoints.add( new WavePt( this, tempTable, i - tempLastCountForFuncs + 1, tf.serialNum ) );
    } // end for i
  } // end addWavePoints()



  void addStudents( ArrayList <Function> tempFuncs, int tempLastCountForFuncs, int tempMinPostTime, int tempMaxPostTime, Table tempTable ) {
  // This will add Student objects to the students ArrayList, using the input of an ArrayList of Function objects
  //
    // go through tempFuncs, check for duplication  
    for( int i = tempLastCountForFuncs; i < tempFuncs.size(); i++ ) {
      Function tf = tempFuncs.get( i );
      int dup = 0;
      int sumDup = 0;
      println( students.size() );
      if( students.size() == 0 ) { // first entry of the students list
        println( "tempTable's size is: " + tempTable.getRowCount() );
        students.add( new Student( tempTable, i + 1, students.size() ) );
      } else {
        for( int j = 0; j < students.size(); j++ ) { // subsequent entry to the spokes list, need to check fo duplication
	  Student std = ( Student ) students.get( j );
	  if( tf.studentID.equals( std.studentID ) ) {
	    dup ++;
	  }
	  sumDup += dup;
	} // end for j
	if( sumDup == 0 ) { // no duplicates found in the current ArrayList of j Student objects
	  students.add( new Student( tempTable, 0 - tempLastCountForFuncs +i + 1, students.size() ) );
	}
      } // end else
    } // end for i
  } // end addStudents()




  void updateHasData() {
    println( "calling updateHasData()" );
    if( wavePoints.size() > 0 )
      hasData = true;
    else
      hasData = false;
  } // end updateHasData()




  void display( View r ) {
    r.clearBackground();
    r.putTextFont( spiralFont, 12 );
    stroke( 0 );
    fill( 0 );
    if( hasData ) 
      for( WavePt wp : wavePoints ) {
        r.putText( wp.funcString, 200, ( wp.serialNum + 1 ) * 12 );
      } // end for wavePoints
  } // end display()


  

  void drawX() {

  } // end drawX()




  Student getStudent( String sID ) {
  // returns a reference to object of class Student which has sID as
  // its studentID
  //
    Student ret = null;
    for( Student sdt : students )
      if( sdt.studentID.equals(sID) )
        ret = sdt;
    return ret;
  } // end getStudent()




} // end class Wave
