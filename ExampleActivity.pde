// Better keep this one as an example, lest I forget how the structure and flow is...

class ExampleActivity extends Activity {
  import simpleML.*;
    
  // Fields
  
  ExampleUI eUI;
  PImage test = loadImage( "black and white tux.gif" );
  Section[] sections;
  Table databaseStream;
  String activityDetails;
  String dataWholeChunk;
  String baseURLAddress;
  HTMLRequest htmlRequest;
  int lastRequestTime;
  int lastIndexReceived;




  // Constructor  
  
  ExampleActivity( Tester o ) {
    super( o, 50, 50, 1150, 650 );
    bgColor = color( 255, 255, 255 );
    eUI = new ExampleUI( this, x1Frame+10, y1Frame+10, x2Frame-170, y2Frame-10 );
    aUI = eUI;
    aUI.view.setImage( test );
    aUI.view.reposition();
    
    // section and spiral objects NOT created in constructor

    dataWholeChunk  ="";
    lastRequestTime = millis();
    lastIndexReceived = 0;
     
  } // end constructor
  



  // Methods

  void display() {
    super.display();
    // Put details of drawing stuff inside render() below
  } // end display()



  
  void connectDB( String s ) {
    htmlRequest = new HTMLRequest( owner, s );
    lastRequestTime = millis();
    htmlRequest.makeRequest();
    println( "connecting to DB with the following address: " + s );
    
  } // end connectDB
  
  

  
  void startSpiral( String[] aDetails ) {
  // aDetails [0] [1] [2] is url, startTime and title
    connectDB( aDetails[ 0 ] );
    baseURLAddress = aDetails[ 0 ].substring( 0, aDetails[ 0 ].length() - 1 );
    println( "baseURLAddress is now: " + baseURLAddress );
    
    // create a new section and populate it
    print( "Creating new Section using provided details: " + aDetails[ 1 ] + " " + aDetails[ 2 ] + " ... " );
    sections = new Section[ 1 ];
    sections[ 0 ] = new Section( aDetails[ 1 ], aDetails[ 2 ] );
    println( "[DONE]" );

    activityDetails = aDetails[ 1 ] + "\t" + aDetails[ 2 ] + "\t\t\t\t\t\t"; // REMEMBER to tally number of \t-s with number of column
    
    /*
    String flatfile = "data/AERA2011-101-BPGHS-2010-viz3.tsv";
    print( "Setting dummy databaseStream " + flatfile + "  ... " );
    databaseStream = new Table( flatfile );
    println( "[DONE]" );
    

    print( "populating Function objects for the section ... " );
    sections[0].populateFuncs( databaseStream );
    println( "[DONE]" );

    print( "Let's see what our section object looks like now:" );
    println( sections[ 0 ] );
    
    print( "adding spokes to spiral..." );
    sections[ 0 ].spiral.addSpokes( sections[ 0 ].funcs, 0, 100, databaseStream );
    println( "[DONE]" );
    println( sections[ 0 ].spiral );
    */

    // also create a new spiral and add the spokes    
  } // end startSpiral()




  String toString() {
   return( "An object of class Activity which is set to hold a spiral viz" ); 
  }



  
  void updateDatastream() {
    // poll database every five seconds
    int now = millis();
    if( now - lastRequestTime > 5000 ) {
      htmlRequest.makeRequest();
      println( "making request ..." );
      lastRequestTime = millis();
    }
  
    // if has received data, split received whole chunk
    if( dataWholeChunk.equals( "" ) == false ) {
      String[] dataInRows = split( dataWholeChunk, "\n"); 


      // if looks ok, turn it into table and populate funcs then add spokes
      if( dataInRows[ 0 ].equals( "Contributions:" ) == true && dataInRows.length > 1 ) {
        lastIndexReceived = updateLastIndexReceived( dataInRows );
        dataInRows = cleanRows( dataInRows );

	databaseStream = new Table( dataInRows );
	sections[ 0 ].populateFuncs( databaseStream );
        println( "sections.funcs populated" );
       for( int l = 0; l < sections[ 0 ].funcs.size(); l++ ) {
         Function f = ( Function ) sections[0].funcs.get( l );
         println( f );
       }
       sections[ 0 ].applyToSpiral( databaseStream );
       println( sections[0].spiral );
       for( int o = 0; o < sections[0].spiral.spokes.size(); o++ ) {
         Spoke s = ( Spoke ) sections[0].spiral.spokes.get( o );
         println( s );
       }
       
       // prepare for next wave of data
       sections[ 0 ].lastCountForFuncs = sections[ 0 ].funcs.size();
        dataWholeChunk = "";
        htmlRequest = new HTMLRequest( owner, baseURLAddress + lastIndexReceived );
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
        cleaned[ nextPosCleaned ] = trim(tempR + "\t\t\t\t\t\tHIT\tALL");
	nextPosCleaned++;
      }
    }
    println( "returning cleaned dataInRows[] :" );
    println( cleaned );
    return cleaned; 
  }  // end cleanRows()
  



  /*
  String[] trimTopElement( String[] tbTrimmed ) {
    String[] trimmedOne = new String[ tbTrimmed.length - 1 ];
    for( int i = 1; i < tbTrimmed.length; i++ ) {
      trimmedOne[ i - 1 ] = tbTrimmed[ i ];
    }
    return trimmedOne;
  } // end trimTopElement()
  */



  
  void render() {
    View renderer = aUI.view;
    
    updateDatastream();

    // Determine Offsets
    aUI.view.updateOffsetRenders();
    float xOffset = aUI.view.calculateXOffsetRender();
    float yOffset = aUI.view.calculateYOffsetRender();
    
    // Drawing routines

    //image( aUI.view.img, 0 + xOffset, 0 + yOffset );
    renderer.putImage();
    
    stroke( 255, 80, 20 );
    fill( 255, 80, 20 );
    rect( 50 + xOffset, 25 + yOffset, 100 + xOffset, 50 + yOffset );
    
    // call renderer.put... so that its drawn inside the View
    renderer.putLine( 0, 0, 1000, 10 );
    renderer.putRect( 1100, 100, 1111, 200 );
    renderer.putEllipse( 50, 1200, 50, 50 );
    renderer.putEllipse( 500, 5, 40, 20 );
    sections[ 0 ].spiral.display();
    //sections[ 0 ].spiral.display();
    
  } // end render()
  

  

  void netEvent( HTMLRequest ml ) {
    dataWholeChunk = ml.readRawSource();
  }
  


  
} // end class ExampleActivity
