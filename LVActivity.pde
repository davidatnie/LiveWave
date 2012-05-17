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




  // Constructor  
  
  LVActivity( LiveViz o ) {
    super( o, 0, 0, o.width, o.height ); // maximize window area
    bgColor = color( 255, 255, 255 );    // default bgColor is white

    // does not have a concrete member that extends AUI, those will be done at the children classes of SpiralActivity and WaveActivity

    dataWholeChunk  ="";
    lastRequestTime = millis();
    lastIndexReceived = 0;
    baseURLAddress = "";
    hasNewDatastream = false;
  } // end constructor
  



  // Methods

  void startLV( String[] aDetails ) {
  // aDetails [0] [1] [2] is url, startTime and title
  connectDB( aDetails[ 0 ] );
  baseURLAddress = makeBaseURLAddress( aDetails[ 0 ] );
  activityDetails = aDetails[ 1 ] + "\t" + aDetails[ 2 ] + "\t\t\t\t\t\t"; // REMEMBER to tally number of \t-s with number of column in the dataset as this will become the column title row for the dataStream

  } // end startLV() 




  void display() {
    super.display();
    // Put details of drawing stuff inside render() below
  } // end display()



  
  void render() {
    // there's no drawing routines here, only updating datastream
    // from the database
    println( "now running LVActivity.updateDatastream()" );
    updateDatastream();
    println( "value of hasNewDatastream is: " + hasNewDatastream );
  } // end render()




  void updateDatastream() {
    // poll database every five seconds
    int now = millis();
    println( "elapsed: " + ( now - lastRequestTime ) );
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
    // if has received data, split received whole chunk
    if( dataWholeChunk.equals( "" ) == false ) {
      String[] dataInRows = split( dataWholeChunk, "\n"); 

      // if looks ok, turn it into table and populate funcs then add spokes
      if( dataInRows[ 0 ].equals( "Contributions:" ) == true && dataInRows.length > 1 ) {
        lastIndexReceived = updateLastIndexReceived( dataInRows );
        dataInRows = cleanRows( dataInRows );
        println( "cleaned dataInRows is: " );
        println( dataInRows );
	databaseStream = new Table( dataInRows );
        hasNewDatastream = true;
        // children classes will need to check if hasNewDatastream is true, before running their processDatastream() method
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
    int irrelevantRows = 0;
    for( int i = 1; i < tbCleaned.length - 1; i++ ) {
      String[] cells = split( tbCleaned[ i ], "\t" );
      if( cells[ 1 ].equals( "EQUATION" ) == false ) { // filter out non "Equation" contributions
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
        for( int k = 2; k < cells.length; k++ ) {
          tempR += cells[ k ] + "\t";
        }
        cleaned[ nextPosCleaned ] = trim(tempR + "\t\t\t\t\t\tUNASSESSED\tALL");
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
