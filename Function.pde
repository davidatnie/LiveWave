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
  String studentID, yOrder, funcString;
  boolean hit; // 1 is "HIT", 0 is "NO-HIT" OR "UNASSESSED"
  String hitTxt; // raw value of the HIT/NO-HIT cell: "HIT" / "NO-HIT" / "UNASSESSED"
  //boolean tagged; // 1 is tagged, 0 is not tagged
  


  /* NO LONGER APPLICABLE - LIVE WAVE IS BREAKING AWAY FROM USING FLAT FILES
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
  */



  // Overloaded Constructor for live Database "Streaming"

  Function( Table t, int row, int lastSerNum ) {
  // Datastream from database is very different from reading from flat files
  // The columns no longer match. And Database streaming has "Codes" instead of "Strategies"
  // serial number is derived from one of the arguments passed into the 
  // constructor
  // example INPUT:      -- NOTE: May change following implementation of "assessor"
  // 103 [student20]   Y1  2x+3x+2x+3x-x-x   UNASSESSED   VASM|MT   annotation1|ann2
  // 
    serialNum = t.getInt( row, 0 );
    postTime = t.getInt( row, 1 );
    cPostTime = new Post_Time( postTime, t.getString( row, 1 ) );
    studentID = t.getString( row, 2 );
    yOrder = t.getString( row, 3 );
    funcString = t.getString( row, 4 );
    hit = loadStatus( t, row, 5 );
    hitTxt = t.getString( row, 5 );
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



