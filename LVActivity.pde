// The ancestor class for both the Live Spiral and Live Wave visualizer

class LVActivity extends Activity {
  import simpleML.*;
    
  // Fields
  
  Table databaseStream;
  String activityDetails;
  String dataWholeChunk;
  String baseURLAddress;
  HTMLRequest htmlRequest;
  int lastRequestTime;
  int lastIndexReceived;
  boolean hasNewDatastream;
  /*
  ArrayList<CodeItem> codeItemsList;
  ArrayList<CodeCateogry> codeCategoriesList;
  Map<String, CodeItem> codeItemsDictionary;
  Map<String, CodeCategory> codeCategoriesDictionary;
  Map<CodeItem, CodeCategory> codeBook;
  */
  CodeCabinet codeCabinet; 




  // Constructor  
  
  LVActivity( LiveWave o ) {
    super( o, 0, 0, o.width, o.height ); // maximize window area
    bgColor = color( 255, 255, 255 );    // default bgColor is white

    // does not have a concrete member that extends AUI, 
    // those will be done at the children classes of SpiralActivity and WaveActivity

    dataWholeChunk  ="";
    lastRequestTime = millis();
    lastIndexReceived = 0;
    baseURLAddress = "";
    hasNewDatastream = false;
    /*
    codeItemsList = new ArrayList<CodeItem>();
    codeCategoriesList = new ArrayList<CodeCategory>();
    codeItemsDictionary = new HashMap<String, CodeItem>();
    codeCategoriesDictionary = new HashMap<String, CodeCategory>();
    codeBook = new HashMap<CodeItem, CodeCategory>();
    */
    codeCabinet = new CodeCabinet();
  } // end constructor
  



  // Methods

  void startLV( String[] aDetails ) {
  // aDetails [0] [1] [2] is url, startTime and title

    buildCodeCabinet();
    connectDB( aDetails[ 0 ] );
    baseURLAddress = makeBaseURLAddress( aDetails[ 0 ] );
    activityDetails = aDetails[ 1 ] + "\t" + aDetails[ 2 ] + "\t\t\t\t\t"; // REMEMBER to tally number of \t-s with number of column in the dataset as this will become the column title row for the dataStream

  } // end startLV() 




  void display() {
    super.display();
    // Put details of drawing stuff inside render() below
  } // end display()




  void prerender() {
    super.prerender();
  } // end prerender()
    
    
    
    
  void render() {
  //  draw background and update datastream
  // from the database
  //
    super.drawFrameBkground();
    updateDatastream();
  } // end render()




  void updateDatastream() {
  // this method polls database every five seconds and 
  // do cleanup on the received data
  // PROCESSWISE:
  //     UPDATES lastIndexReceived
  //     UPDATES data ( if any ) :
  //         INPUT: a String, very long, from database
  //         OUTPUT: a Table, called databaseStream
  //     SETS hasNewDataStream to true ( if got data ), so child classes can process the data
  //
    // the polling:
    int now = millis();
    if( now - lastRequestTime > 5000 ) {
      println( htmlRequest );
      if( htmlRequest == null ) {
        println( "[ MAKING NEXT URL ADDRESS ]");
	println( "     base URL is " + baseURLAddress );
        String s = makeNextURLAddress( baseURLAddress );
        println( "     next URL is " + s );
	println( "[ DONE MAKING NEXT URL ADDRESS ]" );
        connectDB( s );
      }
      htmlRequest.makeRequest();
      println( "making request to database ..." );
      lastRequestTime = millis();
    }

    // the cleanup & updating of lastIndexReceived:
    if( dataWholeChunk.equals( "" ) == false ) {
      String[] dataInRows = split( dataWholeChunk, "\n"); 

      // if looks ok, turn it into table and populate funcs then add spokes
      if( dataInRows[ 0 ].equals( "Contributions:" ) == true && dataInRows.length > 1 ) {
        lastIndexReceived = updateLastIndexReceived( dataInRows );
        dataInRows = cleanRows( dataInRows );
        //println( "cleaned dataInRows is: " );
        //println( dataInRows ); // check to see if dataInRows is now in the desired format
	databaseStream = new Table( dataInRows );
        hasNewDatastream = true;
        // NOTE: children classes will need to check if 
        // hasNewDatastream is true, before running their processDatastream() method
      }
    }    
  } // end updateDatastream()




  String makeBaseURLAddress( String adetails ) {
      String ret = "";
      String lastOne = adetails.substring( adetails.length() - 1, adetails.length() );
      if( lastOne.matches( "[0..9]" ) ) { // ends with an index number
        ret = adetails.substring( 0, adetails.length() - 1 );
      }
      else
        ret = adetails;
      println( "baseURLAddress is now: " + ret );
      return ret;
    } // end makeBaseURLAddress()
    
    
    
    
  String makeNextURLAddress( String baseAdd ) {
    if( baseAdd.endsWith( "getAllContributions" ) )
      return baseAdd;
    else
      return baseAdd + lastIndexReceived;
  } // end makeNextURLAddress() 
    
    

    
  void buildCodeCabinet() {
  // populates the ArrayLists and HashMaps that facilitate usage of Codes
  //     
    println( "BUILDING CODECABINET : " );
    String[] dbGetCodeD = loadStrings( "http://localhost:9000/getCodeDictionary" );
    String codeCatStamp = "";
    CodeCategory stampObject = null;
    String codeItemStamp = "";

    if( dbGetCodeD.equals( null ) == false && dbGetCodeD[ 0 ].equals( "FAILED" ) == false ) { // safety check
      // clean dbGetCodeD from blank rows
      ArrayList<String> dbGetCodeDCleaned = new ArrayList();
      for( String row : dbGetCodeD ) {
        if( row.equals( "" ) == false )
          dbGetCodeDCleaned.add( row );
      }
      // overwrite the original dbGetCodeD
      dbGetCodeD = new String[ dbGetCodeDCleaned.size() ];
      for( int i = 0; i < dbGetCodeD.length; i++ ) {
        dbGetCodeD[ i ] = dbGetCodeDCleaned.get( i ); 
      }
      String [] [] dbCodeDPieces = new String[ dbGetCodeD.length ][ 2 ];
      
      for( int i = 0; i <  dbGetCodeD.length; i++ ) {
        dbCodeDPieces [ i ] = splitTokens( dbGetCodeD[ i ], " " );
        
        if( dbCodeDPieces[ i ] [ 0 ].equals( "CATEGORY:" ) ) {
          codeCatStamp = dbCodeDPieces[ i ] [ 1 ];  
          if( codeCatStamp.equals( "UNCATEGORIZED" ) == false ) { // if category is concrete
            stampObject = new CodeCategory( codeCatStamp );
            println( "\tAdded " + stampObject );
            codeCabinet.codeCategoriesList.add( stampObject );
            codeCabinet.codeCategoriesDictionary.put( codeCatStamp, stampObject );
          }

        } else if( dbCodeDPieces[ i ] [ 0 ].equals( "DESCRIPTOR:" ) ) {
          codeItemStamp = dbCodeDPieces[ i ] [ 1 ];
          //println( dbCodeDPieces[ i ] [1] );
          CodeItem ctemp = null;
          if( codeCatStamp.equals( "UNCATEGORIZED" ) == false ) { // if category is concrete
            ctemp = new CodeItem( stampObject, codeItemStamp );
            println( "\t\tAdded: " + ctemp );
            codeCabinet.codeBook.put( ctemp, stampObject );
            stampObject.addCodeItem( ctemp );
          } else {
            // dont put in codeBook HashMap coz ctemp's owner is null, 
            // the owner is  NOT an instance of CodeCategory with dispName="UNCATEGORIZED"
            ctemp = new CodeItem( codeItemStamp );
            println( "\tAdded: " + ctemp ); 
          }
          codeCabinet.codeItemsList.add( ctemp );
          codeCabinet.codeItemsDictionary.put( codeItemStamp, ctemp );
            
        } // end else "DESCRIPTOR:"
      } // end for i
    } // end if got valid data
  } // end buildCodeCabinet()



  
  void connectDB( String s ) {
    println( "in connectDB(), setting htmlRequest to this address: " + s );
    htmlRequest = new HTMLRequest( owner, s );
    lastRequestTime = millis();
    htmlRequest.makeRequest();
    println( "connecting to DB with the following address: " + s );
    println( lastRequestTime );
  } // end connectDB




  int updateLastIndexReceived( String[] received ) {
    String lastRow = received[ received.length - 2 ];
    String[] pieces = split( lastRow, "\t" );
    int ret = Integer.parseInt( pieces[ 0 ] );
    return ret;
  }  // end updateLastIndexReceived()




  String[] cleanRows( String[] tbCleaned ) {
  // discards all rows which is not a contribution of type "EQUATION" and 
  // ensures  that each row contains the correct number of columns with 
  // correct column data in place.
  // example INPUT:
  // 39	  EQUATION  103   [student20]   Y1   2x+3x+2x+3x-x-x    VASM|MT   annotation1|ann2
  // example OUTPUT:      -- NOTE: May change following implementation of "assessor"
  // 103 [student20]   Y1  2x+3x+2x+3x-x-x   UNASSESSED   VASM|MT   annotation1|ann2
  //
    int irrelevantRows = 0;
    for( int i = 1; i < tbCleaned.length - 1; i++ ) {
      String[] cells = split( tbCleaned[ i ], "\t" );
      if( cells[ 1 ].equals( "EQUATION" ) == false ) { // discard non "EQUATION" contributions
        tbCleaned[ i ] = "";         
        irrelevantRows++;
      }
    }

    // Copy over all non-blank rows into a new array of rows
    String[] cleaned = new String[ tbCleaned.length - irrelevantRows - 1 ];     
    cleaned[ 0 ] = activityDetails;
    int nextPosCleaned = 1;
    for( int z = 1; z < tbCleaned.length; z++ ) {    
      if( tbCleaned[ z ].equals( "" ) == false ) {
        String[] cells = split( tbCleaned[ z ], "\t" );
        String tempR = "";
        // sewing back all the columns received from database except 
        // the first two columns ( Contribution Index and Contribution Type )
        for( int k = 2; k < cells.length-2; k++ ) {
          tempR += cells[ k ] + "\t";  
        }
        tempR += "\tUNASSESSED\t" + cells[ cells.length-2 ] + "\t" + cells[ cells.length-1 ];

        // NOTE: the line above mayneed to be changed following implementation of an assessor
        // for (Hit/No-Hit) for historical sessions.

	cleaned[ nextPosCleaned ] = trim(tempR); 
	nextPosCleaned++;
      }
    }
    return cleaned; 
  }  // end cleanRows()



  
  void prepForNextDatastream() {
    // prepare for next wave of data - designed to be called only
    // by children classes of SpiralActivity and WaveActivity,
    // after they called super.render() and their respective 
    // populatefuncs() and applyToX() routines
    // 
    dataWholeChunk = "";
    databaseStream = null;
    hasNewDatastream = false;
    String addressForNextPoll = makeNextURLAddress( baseURLAddress );
    htmlRequest = new HTMLRequest( owner, addressForNextPoll );
  } // end prepForNextDatastream()  

  


  void netEvent( HTMLRequest ml ) {
    dataWholeChunk = ml.readRawSource();
  } // end netEvent()




  String toString() {
   return( "This is LVActivity, an object of class Activity which is the ancestor for both the Live Spiral and Live Wave viz" ); 
  }

  

  
} // end class LVActivity
