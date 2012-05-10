// The main class for the Live Spiral visualizer
// see also: class SpiralUI

class SpiralActivity extends Activity {
  import simpleML.*;
    
  // Fields
  
  SpiralUI spaUI;
  Section[] sections;
  Table databaseStream;
  String activityDetails;
  String dataWholeChunk;
  String baseURLAddress;
  HTMLRequest htmlRequest;
  int lastRequestTime;
  int lastIndexReceived;
  OpsStats opsStats;




  // Constructor  
  
  SpiralActivity( Tester o ) {
    super( o, 0, 0, o.width, o.height );
    bgColor = color( 255, 255, 255 );
    spaUI = new SpiralUI( this );
    aUI = spaUI;
       
    // section and spiral objects NOT created in constructor
    sections = new Section[ 1 ];    
    sections[ 0 ] = new Section(); 

    dataWholeChunk  ="";
    lastRequestTime = millis();
    lastIndexReceived = 0;
    
    baseURLAddress = "";
    
  } // end constructor
  



  // Methods

  void display() {
    super.display();
    // Put details of drawing stuff inside render() below
  } // end display()



  
  void render() {
    View renderer = aUI.view;
    updateDatastream();
    // Drawing routines
    sections[ 0 ].spiral.display();
    fill( popUpBkgrd );
    stroke( popUpTxt );
    rectMode( CORNERS );
    rect( 30, 30, 230, 130 );
    fill( popUpTxt );
    textSize( 15 );
    text( "Total Creativity Score:", 50, 55 );
    textSize( 40 );
    text( sections[ 0 ].spiral.crvTotal, 40, 100 );
  } // end render()




  void startSpiral( String[] aDetails ) {
  // aDetails [0] [1] [2] is url, startTime and title
    connectDB( aDetails[ 0 ] );
    this.baseURLAddress = makeBaseURLAddress( aDetails[ 0 ] );
    
    // create a new section and populate it
    print( "Creating new Section using provided details: " + aDetails[ 1 ] + " " + aDetails[ 2 ] + " ... " );
    sections[ 0 ].sproutSection( aDetails[ 1 ], aDetails[ 2 ] );
    println( "[DONE]" );

    activityDetails = aDetails[ 1 ] + "\t" + aDetails[ 2 ] + "\t\t\t\t\t\t"; // REMEMBER to tally number of \t-s with number of column
    
  } // end startSpiral()




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
    htmlRequest = new HTMLRequest( owner, s );
    lastRequestTime = millis();
    htmlRequest.makeRequest();
    println( "connecting to DB with the following address: " + s );
  } // end connectDB
  
  

  
  void updateDatastream() {
    // poll database every five seconds
    int now = millis();
    if( now - lastRequestTime > 5000 ) {
      if( htmlRequest == null ) {
        println( "[ MAKING NEXT URL ADDRESS ]");
	println( "     base URL is " + baseURLAddress );
        String s = makeNextURLAddress( baseURLAddress );
        println( "     next URL is " + s );
	println( "[ DONE MAKING NEXT URL ADDRESS ]" );
        connectDB( makeNextURLAddress( baseURLAddress ) );
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
	
	sections[ 0 ].populateFuncs( databaseStream );
        sections[ 0 ].applyToSpiral( databaseStream );
	        
	// rebuild opsStats after each wave of new datastream
	// NOTE: may need a persistent cumulative Table of Data
	opsStats = new OpsStats( sections );
    	println( opsStats.schOpsUsage + "SCHOOL" );
	println( opsStats.clsOpsUsage.get( 0 ) + sections[ 0 ].pdfName );

	// build stats for the sections
	sections[ 0 ].stats = new Stats( sections[ 0 ].spiral, ( OpsUsage ) opsStats.clsOpsUsage.get( 0 ), opsStats.schOpsUsage );
        println( sections[ 0 ].stats.plusWt );
        println( sections[ 0 ].stats.minusWt );
        println( sections[ 0 ].stats.timesWt );
        println( sections[ 0 ].stats.dividesWt );
        println( sections[ 0 ].stats.squareWt );
        println( sections[ 0 ].stats.negativeWt );
        
	// recalculate CRV scores
	for( int i = 0; i < sections[ 0 ].spiral.spokes.size(); i++ ) {
	  Spoke s = ( Spoke ) sections[ 0 ].spiral.spokes.get( i );
	  s.computeCRVScore( sections[ 0 ].stats.plusWt, sections[ 0 ].stats.minusWt, sections[ 0 ].stats.timesWt, sections[ 0 ].stats.dividesWt, sections[ 0 ].stats.squareWt, sections[ 0 ].stats.negativeWt );
        }
        sections[ 0 ].spiral.computeCRVTotal();
	println( "Showing contents of spiral: " );
	println( sections[ 0 ].spiral );

        // prepare for next wave of data
        sections[ 0 ].lastCountForFuncs = sections[ 0 ].funcs.size();
        dataWholeChunk = "";
        String addressForNextPoll = makeNextURLAddress( baseURLAddress );
        htmlRequest = new HTMLRequest( owner, addressForNextPoll );
      }
    }    
  } // end updateDatastream()
  
  
  

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
  

  

  void netEvent( HTMLRequest ml ) {
    dataWholeChunk = ml.readRawSource();
  }




  String toString() {
   return( "An object of class Activity which is set to hold a spiral viz" ); 
  }

  

  
} // end class SpiralActivity
