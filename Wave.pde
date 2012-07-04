class Wave extends Section {

  // Fields
  
  ArrayList <Student> students;
  ArrayList <WavePt> wavePoints;
  Ribbon ribbon;

  // The following fields also exist in class Spiral, consider
  // moving them upclass to become members of class Section instead
  Post_Time cExerciseStart, cMaxPostTime, cMinPostTime, cDuration;
  //int maxPostTime, minPostTime;
  String title;
  
  float x, y;
  float maxRad;

  int maxLevel, stepUpWindow, stepDownWindow, resetWindow;
  float rgbPropRate, rgbSmoothRate;

  CodeCabinet codeCabinet;
  ArrayList<String> selCodes;
  String selCodesDisp, selCodesDispPrev;

  ArrayList<String> selEqs;

  long actid;
  String hostip; // value is set in WaveActivity.startWave()
  
  String comments;
  String stateName;
  long stateID;




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

    // properties of the Intensity and Wave coloring
    maxLevel = 20;
    stepUpWindow = 5;
    resetWindow = 15;
    rgbPropRate = 12;
    rgbSmoothRate = rgbPropRate;
    stepDownWindow = resetWindow - stepUpWindow;
    rgbPropRate = ( 255 - 15 ) / maxLevel;
    
    ribbon = new Ribbon( this );
    
    comments = "";
    stateName = "";
    stateID = -1; // -1 means NOT referring to oany states on the database

  } // end constructor




  // Methods

  void sproutWave( String tempExerciseStart, String tempExerciseTitle, long id, CodeCabinet cc ) {
  // when run, data is plugged-in and the wave is started / sprouted
    setStartTime( tempExerciseStart );
    setTitle( tempExerciseTitle );
    pdfName = tempExerciseStart + ".pdf";
    cExerciseStart = new Post_Time( 0, tempExerciseStart );
    cMaxPostTime = new Post_Time( 0, tempExerciseStart );
    cMinPostTime = new Post_Time( 0, tempExerciseStart );
    title = tempExerciseTitle;
    actid = id;
    codeCabinet = cc;
    for( CodeItem ci : codeCabinet.codeItemsList )
      println( "\t" + ci );
    selCodes = new ArrayList<String>();
    for( CodeItem ci : codeCabinet.codeItemsList )
      selCodes.add( ci.dispName );
      CodeCategory ccg = codeCabinet.codeCategoriesDictionary.get( "Math" );
      for( CodeItem ci : ccg.codeItems )
        println( ccg.dispName + "-=" + ci.dispName );
        
    selCodesDisp = setSelCodesDisp( selCodes );
    selEqs = new ArrayList<String>();
  } // end sproutWave()




  void growWave( Table t ) {
  // Needs to be commented and reworked
    int wpCountBefore = wavePoints.size();
    super.populateFuncs( t );
    print( "Applying Datastream to Wave ... " );
    addStudents( funcs, lastCountForFuncs, minPostTime, maxPostTime, t );
    addWavePoints( funcs, lastCountForFuncs, t );
    int wpCountAfter = wavePoints.size(); 
    updateHasData();
    processWavePoints( wpCountBefore, wpCountAfter );
    ribbon.updateMinsCount();
    //println( "finished going trhough growWave()" );
    markForDisplay( selCodes );
    sortBy( selEqs );
    println( wavePoints.size() );
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
        Student sNow = getStudent( wpNow.student.studentID );
        sNow.wavePoints.add( wpNow );

      } else { // for subsequent wavePoints

        WavePt wpPrev = wavePoints.get( i-1 );
        WavePt wpNow  = wavePoints.get( i );
	int lag = wpNow.postTime - wpPrev.postTime;

	if( lag <= stepUpWindow ) {

	  wpNow.intensityScore = wpPrev.intensityScore + 1; // step it up
	  wpNow.intensityScore = constrain( wpNow.intensityScore, 1, maxLevel ); // make sure its within the range
	  wpNow.updateWaveRad();
          wpNow.updateWaveRadC();
          Student sNow = getStudent( wpNow.student.studentID );
          sNow.wavePoints.add( wpNow );

	} else if( lag > resetWindow ) {

	  wpNow.intensityScore = 1; // if lag too long, reset back to 1
	  wpNow.updateWaveRad();
	  wpNow.updateWaveRadC();
          Student sNow = getStudent( wpNow.student.studentID );
          sNow.wavePoints.add( wpNow );

	} else {

	  wpNow.intensityScore = floor( ( lag - stepUpWindow ) * ( maxLevel / stepDownWindow ) );
	  wpNow.intensityScore = constrain( wpNow.intensityScore, 1, maxLevel );
	  wpNow.updateWaveRad();
          wpNow.waveRadc =color( floor( wpNow.intensityScore * rgbSmoothRate ) + 15 ); // uses rgbSmoothRate instead of rgbPropRate (different from WavePt.updateWaveRadC() )
	  Student sNow = getStudent( wpNow.student.studentID );
          sNow.wavePoints.add( wpNow );
        }
      }	
    } // end for i
  } // end processWavePoints()




  void addWavePoints( ArrayList <Function> tempFuncs, int tempLastCountForFuncs, Table tempTable ) {
    println( "tempLastCountForFuncs, tempFuncs.size() - tempTable.size() " + tempLastCountForFuncs + " " + tempFuncs.size() + "-" + tempTable.getRowCount() );
    for( int i = tempLastCountForFuncs; i < tempFuncs.size(); i++ ) {
      Function tf = tempFuncs.get( i );
      //println( "adding wavePoint.. " );
      //println( tf );
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
      if( students.size() == 0 ) { // first entry of the students list
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
    r.putTextFont( waveFont, 12 );
    stroke( 0 );
    fill( 90 );
    if( hasData )
      printFunctions( r, selCodes );
    else 
      drawLabel( "No Data For This Class", 30, r, "CENTER" );
   r.repositionScrollPosBtns();
  } // end display()
  
  

  
  void printFunctions( View r, ArrayList<String> sc ) {
  // prints the Function equations which has at least one Code in the 
  // Selected Codes list  on to the View. Hides the rest of the equations.
  // 


  // NOTE : MUST THINK TRHOUGH THE STEPS - SHOULD JUST PUT MARKFORDISPLAY() AND SORTBY() HERE ? IF NOT, HOW WOULD NEW INCOMING DATA BE DISPLAYED WHEN THERE'S A NEW DATASTREAM COMING IN?

    for( Student s : students ) {
      if( s.onShow ) {
        s.display( r, s.dispOrder );
        // println( "NOW PRINTING " + s.studentID );
        for( WavePt wp : s.wavePoints )
          if( wp.onShow )
            wp.display( r, wp.dispOrder );
      }
    }
  } // end printFunctions()




  void markForDisplay( ArrayList<String> sc ) {
  // this should be called everytime there's a change in the
  // selected Code(s) to display, or immediately following
  // incoming of new dataStream()
    /*
    if( sc.isEmpty() ) {            // show everything
      for( Student s : students )
        s.onShow = true;
      for( WavePt wp : wavePoints )
        wp.onShow = true;
    } else { */

        println( " >>> selCodes is : " + selCodes );
      
      for( Student s : students ) {
        //println( " >>>> hasWpNoCodes is: " + s.hasWpNoCodes() );
        if( s.hasWpSelCodes( selCodes ) || s.hasWpNoCodes() ) {
          //println( "showing " + s.studentID );
          s.onShow = true;
        } else
          s.onShow = false;
          
        for( WavePt wp : s.wavePoints ) {
          if( wp.hasSelCodes( selCodes ) || wp.hasNoCodes() ) {
            //println( "\tshowing " + wp );
            wp.onShow = true;
          } else
            wp.onShow = false;
        } // end for wp
      } // end for s 
    //} // end else   
  } // end markForDisplay()




  void sortBy( ArrayList<String> eqs ) {
  // This must be run ONLY AFTER markForDisplay()
  // and following that, AFTER loadSelectedEqs()
  //
    //println( "BEFORE SORTING is contributor on Show? " + students.get( 0 ).onShow );
    Collections.sort( students, new StudentComparator( eqs ) );
    //println( "AFTER SORTING is contributor on Show? " + students.get( 0 ).onShow );
    int dispOrder = 1;
    for( int is = 0; is < students.size(); is++ ) {
      Student s = students.get( is );
      if( s.onShow ) {
        s.dispOrder = dispOrder;
        //println( dispOrder );
        dispOrder++;
      } else
        s.dispOrder = -1;
      Collections.sort( s.wavePoints, new WavePtComparator( eqs ) );
      for( int iw = 0; iw <s.wavePoints.size(); iw++ ) {
        WavePt wp = s.wavePoints.get( iw );
        if( wp.onShow ) {
          wp.dispOrder = dispOrder;
          //println( "\t" + dispOrder );
          dispOrder++;
        } else
          wp.dispOrder = -1;
      } // end for iw
    } // end for is
  } // end sortBy()



  
  void loadSelectedEqs( ArrayList<String> sels ) {
  // this should be called ONLY AFTER markForDisplay()
  // and it should be caled BEFORE sortBy()
    if( sels.isEmpty() == false )
      for( WavePt wp: wavePoints ) {
        if( wp.onShow )
          if( sels.contains( wp.funcString ) )
            wp.isSelected = true;
          else
            wp.isSelected = false;
      } // end for  
  } // end loadSelectedEqs()




  void drawWave( View r ) {
  // draws the Wave plot and the Ribbon / timeline plot
  //
    // draw title
    textSize( 20 );
    float x1Title = ( ( ( width - 300 ) - ( textWidth( exerciseTitle ) ) ) / 2 ) + 300;
    float x2Title = x1Title + textWidth( exerciseTitle );
    float y1Title = 5;
    float y2Title = 30;
    stroke( 0, 255, 0 );
    noFill();
    rect( x1Title - 5, y1Title - 5, x2Title + 5, y2Title + 5 );
        fill( 0, 255, 0 );
    text( exerciseTitle, x1Title, y2Title );
    
    // draw waveplot label
    fill( 0, 255, 0 );
    textSize( 10 );
    text( "Wave Plot:", x - maxRad - 3, y - maxRad - 3 );
    
    if( hasData ) {
      for( WavePt wp : wavePoints ) {
        
        // draw Wave
        
        noFill();
        stroke( wp.waveRadc );
	ellipseMode( RADIUS );
	ellipse( x, y, wp.waveRad, wp.waveRad );
	
        /* draw end of contribution
        if( wp.serialNum == wavePoints.size() - 1 ) {	      
          stroke( 1255, 90, 50 ); // orangey color
          strokeWeight( 1 );
            ellipse( x, y, wp.waveRad + 1, wp.waveRad + 1 );

            line( xOnRibbon + 1, yRibbon - 20, xOnRibbon + 1, yRibbon );
            strokeWeight( 1 );
        }
        */
      } // end for wavePoints
      ribbon.display( r );
      printSelCodesDisp();
    }
  } // end drawWave()


  

  void drawLabel( String s, int tSize, View v, String orientation  ) {
  // displays a textbox containing a text in the middle of the View
  // 
      stroke( popUpTxt );
      fill( popUpBkgrd );
      v.putTextSize( tSize );
      
      float lx1 = 0;
      float  lx2 = 0;
      float ly1 = lx1 + textWidth( s );
      float ly2 = ly1 + v.viewTextSize;
      float whiteSpace = 0;

      // right now only have three types of orientation: CENTER / MOUSE and default (all others )
      if( orientation.equals( "CENTER" ) ) {
        whiteSpace = 10;
        lx1 = ( ( ( v.x2-v.x1 ) - textWidth( s ) ) / 2 ) - whiteSpace;
	lx2 = lx1 + textWidth( s ) + 2*whiteSpace;
        ly1 = ( ((v.y2-v.y1) - v.viewTextSize ) / 2) - whiteSpace;      
	ly2 = ly1 + v.viewTextSize + 2*whiteSpace;
	
      } else if( orientation.equals( "MOUSE" ) ) {
        whiteSpace = 5;
        lx1 = (mouseX - v.x1a) - ( textWidth( s ) / 2 ) - whiteSpace;
        lx2 = lx1 + textWidth(s) + 2*whiteSpace;
        ly1 = ( ((mouseY - v.y1a) - v.viewTextSize )) - 5 - whiteSpace;      
        ly2 = ly1 + v.viewTextSize + 2*whiteSpace;
      }
      rectMode( CORNERS );
      v.putRect( lx1, ly1, lx2, ly2 );
      fill( popUpTxt );
      v.putText( s, lx1 + whiteSpace, ly2 - whiteSpace );
  } // end drawLabel()




  Student getStudent( String sID ) {
  // returns a reference to object of class Student which has sID as
  // its studentID
  //
    Student ret = null;
    for( Student sdt : students )
      if( sdt.studentID.equals(sID) ) {
        ret = sdt;
        break;
      }
    return ret;
  } // end getStudent()



  WavePt getWavePointMouseOver() {
  // returns WavePt object on top of which the mouse pointer is at
  // returns null if no such WavePt exists
    WavePt ret = null;
    for( WavePt wp : wavePoints ) {
      if( wp.mouseOver ) {
        ret = wp;
	break;
      }
    }
    return ret;
  } // end getWavePointMouseOver()




  String setSelCodesDisp( ArrayList<String> input ) {
    String ret = "";
    for( String s : input )
      ret += s + "   ";
    return ret;
  } // end setSelCodesDisp()




  void printSelCodesDisp() {
    fill( popUpTxt );
    textSize( 12 );
    text( "Showing :      " + setSelCodesDisp( selCodes ), 300, 80  );
  } // end printSelCodesDisp()

} // end class Wave
