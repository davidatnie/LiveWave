// Used by the Wave and Spiral visualizers
// Requires the following classes:
//         - Table (enhanced version) ~ assuming a Table object named "artefacts" is used throughout this class
//          - Post_Time

class Function {
  // A Function object holds all the fields of the GenSing artefacts dataset
  // plus a few more 'derived' fields such as serialNum and cPostTime
  
  // Fields

  int serialNum;
  int postTime;
  Post_Time cPostTime;
  String studentID, yOrder, funcString, math1, math2, math3, social1, social2, social3;
  boolean hit; // 1 is "HIT", 0 is "NO-HIT" OR "UNASSESSED"
  String hitTxt; // raw value of the HIT/NO-HIT cell: "HIT" / "NO-HIT" / "UNASSESSED"
  //boolean tagged; // 1 is tagged, 0 is not tagged
  


  
  // Constructor - a Function object is constructed by passing the row number from the dataset file as the argument
  
  Function( Table _artefacts, int row ) {
    postTime = _artefacts.getInt( row, 0 );
    cPostTime = new Post_Time( postTime, _artefacts.getString( 0, 0 ) );
    studentID = _artefacts.getString( row, 1 );
    yOrder = _artefacts.getString( row, 2 );
    funcString = _artefacts.getString( row, 3 );
    // println( "seconds in: " + _artefacts.getInt( 0, 0 ) + " funcString: " + funcString );
    math1 = _artefacts.getString( row, 4 );
    math2 = _artefacts.getString( row, 5 );
    math3 = _artefacts.getString( row, 6 );
    social1 = _artefacts.getString( row, 7 );
    social2 = _artefacts.getString( row, 8 );
    social3 = _artefacts.getString( row, 9 );
    hit = loadStatus( _artefacts, row, 10 );
    hitTxt = _artefacts.getString( row, 10 );
    // <NOT IMPLEMENTED YET> tagged = loadStatus( row, 13 );
  } // end constructor Functions 




  // Overloaded Constructor for live Database "Streaming"
  // Since datastream from database is not as complete as datasets,
  // Math & Social strategies, Hit/No-Hit are defaulted in initialization
  // serial number is derived from one of the arguments passed into the 
  // constructor
  Function( Table t, int row, int lastSerNum ) {
    serialNum = lastSerNum + 1;
    postTime = t.getInt( row, 0 );
    cPostTime = new Post_Time( postTime, t.getString( row, 0 ) );
    studentID = t.getString( row, 1 );
    yOrder = t.getString( row, 2 );
    funcString = t.getString( row, 3 );
    math1 = "";
    math2 = "";
    math3 = "";
    social1 = "";
    social2 = "";
    social3 = "";
    hit = loadStatus( t, row, 10 );
    hitTxt = t.getString( row, 10 );
  } // end overloaded constructor




  // Methods
  
  String toString() {                    // This is used mainly for debugging purposes only
    return( serialNum + "~" +cPostTime.getPost_Time_Mins() + "~" +  studentID + "~" + funcString );
  } // end toString method



  
  // Methods called by Methods fo this class

  boolean loadStatus( Table _artefacts, int row, int col ){ 
  // will convert values of the given column from string "HIT" and "NO-HIT" to boolean "true" and "false"
    if( _artefacts.getString( row, col ).equals( "HIT" ) )
      return true;
    else if( _artefacts.getString( row, col ).equals( "NO-HIT" ) )
      return false;
    else
      return false;
  } // end loadStatus()



  
} // end class Function



