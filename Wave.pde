class Wave extends Section {

  // Fields
  
  ArrayList <Student> students;
  ArrayList <WavePt> wavePoints;

  // The following fields also exist in class Spiral, consider
  // moving them upclass to become members of class Section instead
  Post_Time cExerciseStart, cMaxPostTime, cMinPostTime, cDuration;
  int maxPostTime, minPostTime;
  String title;
  
  float x, y, xRibbon, yRibbon;
  int maxRad, maxRibbonLength, oneMinLength;

  int maxLevel, stepUpWindow, stepDownWindow, resetWindow;
  float rgbPropRate, rgbSmoothRate;



  // Constructor

  Wave() {
    super();
    students = new ArrayList();
    wavePoints = new ArrayList();
    
    maxPostTime = 0;
    minPostTime = 10000;
    x = 150;
    y = 400;
    maxRad = 125;

    // variables for the Ribbon, should just make this into an object instead
    xRibbon = 475;
    yRibbon = 50;
    maxRibbonLength = 700;
    oneMinLength = 60;

    // properties of the Intensity and Wave coloring
    maxLevel = 20;
    stepUpWindow = 5;
    resetWindow = 15;
    rgbPropRate = 12;
    rgbSmoothRate = rgbPropRate;
    stepDownWindow = resetWindow - stepUpWindow;
    rgbPropRate = ( 255 - 15 ) / maxLevel;
    
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
    int wpCountBefore = wavePoints.size();
    super.populateFuncs( t );
    print( "Applying Datastream to Wave ... " );
    addStudents( funcs, lastCountForFuncs, minPostTime, maxPostTime, t );
    addWavePoints( funcs, lastCountForFuncs, t );
    int wpCountAfter = wavePoints.size(); 
    updateHasData();
    processWavePoints( wpCountBefore, wpCountAfter );
    println( "finished going trhough growWave()" );
  } // end growWave()




  void processWavePoints( int indexPrev, int indexNow ) {
  // Needs to do the following:
  // calculate intensity score for each wavePoint
  // calculate radius distance for each wavePoint
  // link wavePoints to students
  // 
    for( int i = indexPrev; i < indexNow; i++ ) {
      if( i == 0 ) { // processing for the first wavePoint
        WavePt wpNow = wavePoints.get( i );
	wpNow.intensityScore = 1;
        wpNow.updateWaveRad();
        wpNow.updateWaveRadC();

      } else { // for subsequent wavePoints

        WavePt wpPrev = wavePoints.get( i-1 );
        WavePt wpNow  = wavePoints.get( i );
	int lag = wpNow.postTime - wpPrev.postTime;

	if( lag <= stepUpWindow ) {

	  wpNow.intensityScore = wpPrev.intensityScore + 1; // step it up
	  wpNow.intensityScore = constrain( wpNow.intensityScore, 1, maxLevel ); // make sure its within the range
	  wpNow.updateWaveRad();
          wpNow.updateWaveRadC();

	} else if( lag > resetWindow ) {

	  wpNow.intensityScore = 1; // if lag too long, reset back to 1
	  wpNow.updateWaveRad();
	  wpNow.updateWaveRadC();

	} else {

	  wpNow.intensityScore = floor( ( lag - stepUpWindow ) * ( maxLevel / stepDownWindow ) );
	  wpNow.intensityScore = constrain( wpNow.intensityScore, 1, maxLevel );
	  wpNow.updateWaveRad();
          wpNow.waveRadc =color( floor( wpNow.intensityScore * rgbSmoothRate ) + 15 ); // uses rgbSmoothRate instead of rgbPropRate (different from WavePt.updateWaveRadC() )
	}
      }	
    } // end for i
  } // end processWavePoints()




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
    fill( 90 );
    if( hasData ) {
      for( WavePt wp : wavePoints ) {
        fill( 0 );
        r.putText( wp.funcString, 50 + wp.postTime, ( wp.serialNum + 1 ) * 12 );
        fill( 0,0,0,0 );
        stroke( wp.waveRadc );
	ellipseMode( CENTER );
	ellipse( wp.x, wp.y, wp.waveRad, wp.waveRad );
      } // end for wavePoints
    }
    else 
      drawLabel( r, "No Data For This Class" );
   r.repositionScrollPosBtns();
  } // end display()
  
  
  
  void drawWave() {
    if( hasData ) {
      for( WavePt wp : wavePoints ) {

      } // end for wavePoints
    }
  } // end drawWave()


  

  void drawLabel( View v, String s ) {
  // displays a textbox containing a text in the middle of the View
  // 
      stroke( popUpTxt );
      fill( popUpBkgrd );
      v.putTextSize( 30 );
      float lx1 = ( ( ( v.x2-v.x1 ) - textWidth( s ) ) / 2 ) - 10;
      float lx2 = ( v.x2-v.x1 ) - (((v.x2-v.x1)-textWidth(s))/2) + 10;
      float ly1 = ( ((v.y2-v.y1) - v.viewTextSize ) / 2);      
      float ly2 = (v.y2-v.y1) - ( ( ( v.y2-v.y1 ) - v.viewTextSize ) / 2 ) + 10;
      
      rectMode( CORNERS );
      v.putRect( lx1, ly1, lx2, ly2 );
      fill( popUpTxt );
      v.putText( "No Data For This Class", lx1 + 10, ly2 - 10 );
  } // end drawLabel()




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
