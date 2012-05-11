// The main class for the Live Spiral visualizer
// see also: class SpiralUI

class SpiralActivity extends LVActivity {
    
  // Fields
  
  SpiralUI spaUI;
  Section[] sections;
  OpsStats opsStats;




  // Constructor  
  
  SpiralActivity( LiveViz o ) {
    super( o );
    bgColor = color( 255, 255, 255 );
    spaUI = new SpiralUI( this );
    aUI = spaUI;
       
    // only create a "blank shell" for the section object instance
    sections = new Section[ 1 ];    
    sections[ 0 ] = new Section(); 
    
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
    sections[ 0 ].spiral.display();
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
    text( sections[ 0 ].spiral.crvTotal, 40, 100 );
    */
  } // end render()




  void startSpiral( String[] aDetails ) {
    // aDetails [0] [1] [2] is url, startTime and title
    super.startLV( aDetails );
    
    // create a new section and populate it
    print( "Creating new Section using provided details: " + aDetails[ 1 ] + " " + aDetails[ 2 ] + " ... " );
    sections[ 0 ].sproutSection( aDetails[ 1 ], aDetails[ 2 ] );
    println( "[DONE]" );

  } // end startSpiral()



  
  void processDatastream( Table databaseStream ){
    // this method processes the datastream received from the database. It's unique for Spiral and Wave
    //
    sections[ 0 ].populateFuncs( databaseStream );
    sections[ 0 ].applyToSpiral( databaseStream );
    sections[ 0 ].lastCountForFuncs = sections[ 0 ].funcs.size();

	        
    // rebuild opsStats after each wave of new datastream
    // NOTE: may need a persistent cumulative Table of Data
    opsStats = new OpsStats( sections );
    //println( opsStats.schOpsUsage + "SCHOOL" );
    //println( opsStats.clsOpsUsage.get( 0 ) + sections[ 0 ].pdfName );

    // build stats for the sections
    sections[ 0 ].stats = new Stats( sections[ 0 ].spiral, ( OpsUsage )  opsStats.clsOpsUsage.get( 0 ), opsStats.schOpsUsage );
    //println( sections[ 0 ].stats.plusWt );
    //println( sections[ 0 ].stats.minusWt );
    //println( sections[ 0 ].stats.timesWt );
    //println( sections[ 0 ].stats.dividesWt );
    //println( sections[ 0 ].stats.squareWt );
    //println( sections[ 0 ].stats.negativeWt );
        
    // recalculate CRV scores
    for( int i = 0; i < sections[ 0 ].spiral.spokes.size(); i++ ) {
      Spoke s = ( Spoke ) sections[ 0 ].spiral.spokes.get( i );
      s.computeCRVScore( sections[ 0 ].stats.plusWt, sections[ 0 ].stats.minusWt, sections[ 0 ].stats.timesWt, sections[ 0 ].stats.dividesWt, sections[ 0 ].stats.squareWt, sections[ 0 ].stats.negativeWt );
    }
    sections[ 0 ].spiral.computeCRVTotal();
    println( "Showing contents of spiral: " );
    println( sections[ 0 ].spiral );
  } // end processDatastream()




  String toString() {
   return( "This is SpiralActivity, a descendant of class Activity ( extends LVActivity, which extends Activity ) which is set to hold a spiral viz" ); 
  }

  

  
} // end class SpiralActivity
