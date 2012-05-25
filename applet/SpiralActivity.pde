// The main class for the Live Spiral visualizer
// see also: class SpiralUI

class SpiralActivity extends LVActivity {
    
  // Fields
  
  SpiralUI spaUI;
  Spiral spiral;
  OpsStats opsStats;




  // Constructor  
  
  SpiralActivity( LiveViz o ) {
    super( o );
    bgColor = color( 255, 255, 255 );
    spaUI = new SpiralUI( this );
    aUI = spaUI;
       
    // only create a "blank shell" for the spiral object instance
    spiral = new Spiral(); 
    
  } // end constructor
  



  // Methods

  void display() {
    super.display();
    // Put details of drawing stuff inside render() below
  } // end display()



  
  void render() {
    super.render();
    if( hasNewDatastream )
      processDatastream( databaseStream );
    prepForNextDatastream();
    View renderer = aUI.view;
    // Drawing routines
    spiral.display();
    // CRV score metric needs to be tweaked, Dont show them yet
    /*
    fill( popUpBkgrd );
    stroke( popUpTxt );
    rectMode( CORNERS );
    rect( 30, 30, 230, 130 );
    fill( popUpTxt );
    textSize( 15 );
    text( "Total Creativity Score:", 50, 55 );
    textSize( 40 );
    spiral.crvTotal, 40, 100 );
    */
  } // end render()




  void startSpiral( String[] aDetails ) {
    // aDetails [0] [1] [2] is url, startTime and title
    super.startLV( aDetails );
    
    // create a new spiral and put in activity details into it
    print( "Creating new Spiral using provided details: " + aDetails[ 1 ] + " " + aDetails[ 2 ] + " ... " );
    spiral.sproutSpiral( aDetails[ 1 ], aDetails[ 2 ] );
    println( "[DONE]" );

  } // end startSpiral()



  
  void processDatastream( Table databaseStream ){
  // this method processes the datastream received from the database. It's unique for Spiral and Wave
  //
    spiral.growSpokes( databaseStream );
    spiral.lastCountForFuncs = spiral.funcs.size();

	        
    // rebuild opsStats after each wave of new datastream
    // NOTE: may need a persistent cumulative Table of Data
    opsStats = new OpsStats( spiral );
    //println( opsStats.schOpsUsage + "SCHOOL" );
    //println( opsStats.clsOpsUsage.get( 0 ) + spiral.pdfName );

    // build stats for the spiral
    spiral.stats = new Stats( spiral, ( OpsUsage )  opsStats.clsOpsUsage.get( 0 ), opsStats.schOpsUsage );
    //println( spiral.stats.plusWt );
    //println( spiral.stats.minusWt );
    //println( spiral.stats.timesWt );
    //println( spiral.stats.dividesWt );
    //println( spiral.stats.squareWt );
    //println( spiral.stats.negativeWt );
        
    // recalculate CRV scores
    for( int i = 0; i < spiral.spokes.size(); i++ ) {
      Spoke s = ( Spoke ) spiral.spokes.get( i );
      s.computeCRVScore( spiral.stats.plusWt, spiral.stats.minusWt, spiral.stats.timesWt, spiral.stats.dividesWt, spiral.stats.squareWt, spiral.stats.negativeWt );
    }
    spiral.computeCRVTotal();
    println( "Showing contents of spiral: " );
    println( spiral );
  } // end processDatastream()




  String toString() {
   return( "This is SpiralActivity, a descendant of class Activity ( extends LVActivity, which extends Activity ) which is set to hold a spiral viz" ); 
  }

  

  
} // end class SpiralActivity
