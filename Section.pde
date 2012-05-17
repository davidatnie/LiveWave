// used by both the Wave and the Spiral viz. Holds very important information on the class of interest (section).

class Section {

  // Fields

  Table artefacts;
  
  int maxPostTime, minPostTime;
  String exerciseStart, exerciseTitle;
  Post_Time cExerciseStart, cMaxPostTime, cMinPostTime, cDuration;
  ArrayList funcs; // of type Function
  int lastCountForFuncs;
  String pdfName;
  boolean hasData;  



  
  // Constructor

  Section( int _activeDataset ) {
    artefacts = new Table( datasets[ _activeDataset ] );
    funcs = new ArrayList();
    pdfName = artefacts.getString( 0, 1 ) + ".pdf";
        
    maxPostTime = getColumnMax( 0 );
    minPostTime = getColumnMin( 0 );
    exerciseStart = artefacts.getString( 0, 0 );
    exerciseTitle = artefacts.getString( 0, 1 );
    
    for( int i = 1; i < artefacts.getRowCount(); i++ ) {
     funcs.add( new Function( artefacts, i ) ); 
    }
    
    // Checking for absence (or presence) of data
    // For those classes which didn't conduct this particular activity or for which the GenSing recorder script was not run
    // no data will be available to be visualized, although a dataset will still be created.
    // The dataset will contain only one row of data, where the cells will contain the string "NO DATA"
    if( funcs.size() == 1 ) // no data collected for this class
      hasData = false;
    else if( funcs.size() > 1 )
      hasData = true;
    else                           // this is just in case, should never happen, but if it does, the error message will be displayed
      hasData = false;
      text( "ERROR IN DATASET: DATASET CONTAINS 0 ROWS OF DATA!!!" );
    
    //spiral = new Spiral( funcs, maxPostTime, minPostTime, exerciseStart, exerciseTitle, artefacts, hasData );
    
    //deployment = new Deployment( funcs, artefacts );
    
    // stats will be built after the section's spiral and deployment are built, and after OpUsage has been built
    
  } // end constructor
  



  // Overloaded Constructor for Database "Streaming"

  Section() {
    artefacts = null;         // NOT going to use artefacts in Database "Streaming"
    funcs = new ArrayList();
    lastCountForFuncs = 0;
    pdfName =  "";
    
    maxPostTime = 0;
    minPostTime = 0; // call updateMinMaxPostTime() later to fill these
    exerciseStart = "";
    exerciseTitle = "";
    hasData = false;
    
    // This version of the constructor only creates a new instance, but will NOT populate it with data.
    // Population of data will come in via another method populateWStream()
    
    // stats will be built after the section's spiral is built, and after OpUsage has been built
  } // end Overloaded constructor for Database "Streaming"
  



  // Methods 

  void setStartTime( String st ) {
    exerciseStart = st;
  } // end setStartTime()




  void setTitle( String t ) {
    exerciseTitle = t;
  } // end setTitle()




  int getColumnMax(int col) {
    int m = MIN_INT;
    for (int row = 0; row < artefacts.getRowCount(); row++) {
      if (artefacts.getInt(row,col) > m) {
        m = artefacts.getInt(row,col);
      }
    }
    return m;
  } // end getColumnMax fudnction




  int getColumnMin(int col) {
    int m = MAX_INT;
    for (int row = 0; row < artefacts.getRowCount(); row++) {
      if (artefacts.getInt(row,col) < m) {
        m = artefacts.getInt(row,col);
      }
    }
    return m;
  }  // end getColumnMin()

  


  void updateHasData(){
    if( getFuncsCount() > 0 )
      hasData = true;
    else
      hasData = false;
  } // end updateHasData()



  
  void updateMinMaxPostTime() {
    if( funcs.size() > 0 ) {
      // I'm setting minPostTime and maxPostTime to be simply the postTime
      // of the first and last element of the funcs arraylist.
      // This is BAD practice, should implement a sorting here.
      // Will come back to it at a later date.
      Function f = ( Function ) funcs.get( 0 );
      minPostTime = f.postTime;
      f = ( Function ) funcs.get( funcs.size() - 1 );
      maxPostTime = f.postTime;
    }
  }  // end updateMinMaxPostTime()




  int getFuncsCount() {
    return funcs.size();
  } // end getFuncsCount()




  Table fetchDatastream( String urlAddress ) {  // consider removing, not called by any one
  // connects to the database and get new datastream ( if any )
    String[] rows;
    rows = loadStrings( urlAddress );
    Table t = new Table ( rows );
    return t;
  }  // end fetchDatastream()




  void populateFuncs( Table t ) {
  // Only used with live database "streaming"
    print( "populating funcs with Datastream ... " );
    for( int i = 1; i < t.getRowCount(); i++ )
      funcs.add( new Function ( t, i, getFuncsCount() ) );
    //lastCountForFuncs = funcs.size();
    updateHasData();
    updateMinMaxPostTime();
    println( "funcs count is now: " + funcs.size() + " [ DONE ]" );
  } // end populateFuncs()




  String toString() {
    String ret = ( "=========================================" + "\n" );
    ret += ( "Section Object Instance Details: " + "\n" );
    ret += ( "exerciseTitle: " + exerciseTitle + "\n" );
    ret += ( "exerciseStart: " + exerciseStart + "\n" );
    ret += ( "maxPostTime: " + maxPostTime + "           minPostTime: " + minPostTime + "\n" );
    ret += ( "pdfName: " + pdfName + "\n" );
    ret += ( "hasData: " + hasData + "\n" );
    ret += ( "size of funcs: " + funcs.size() + "\n");
    ret += ( "listing all Function objects inside funcs: " + "\n" );
    ret += ( "-------------------------------------------" + "\n" );
    for( int i = 0; i < funcs.size(); i++ ) {
      Function f = ( Function ) funcs.get( i );
      ret += ( f + "\n" );
    }
    ret += ( "-------------------------------------------" + "\n" );
    
    ret += ( "artefacts is: " );
    if( artefacts == null )
      ret += ( "still NULL" + "\n" );
    else
      ret += ( "NOT null" + "\n" );
    
    ret += ( "============================================" + "\n" );
    return ret;
  } // end toString()




} // end class Section
