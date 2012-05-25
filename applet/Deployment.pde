// Used by the Wave visualizer. Holds data on deployment of the various Math and Social strategies.

// Requires the following classes:
                    // - Function
                    // - Table (enhanced version) ~ assuming a Table object named "artefacts" is used throughout this class
                    

class Deployment {

  // Fields

  Tab math;
  Tab social;
  Tab all;
  Tab[] tabs = new Tab[ 3 ];
  
  float pWidth = 350;
  float pHeight = 300;
  int deploymentFontSize = 14;
  int titleSize = 18;
  
  

  
  // Constructor

  Deployment( ArrayList tempFuncs, Table _artefacts ) {
    
    tabs[ 0 ] = new Tab( _artefacts, 0, " MATH", tempFuncs, 4, 6 );
    tabs[ 1 ] = new Tab( _artefacts, 1, "SOCIAL", tempFuncs, 7, 9 );
    tabs[ 2 ] = new Tab( _artefacts, 2, "   ALL", tempFuncs, 11, 11 );

/*
    for( int i = 0; i < tabs.length; i++ ) {
      initializeStrats( tabs[ i ].stratsList, tabs[ i ].startCol, tabs[ i ].endCol );
      buildStrats( tempFuncs, tabs[ i ].stratsList, tabs[ i ].startCol, tabs[ i ].endCol );
      cleanStrats( tabs[ i ].stratsList );
      sortStrats( tabs[ i ].stratsList );
    }
    */
    tabs[ 0 ].isActive = true;  // debug
 } // end constructor



  // Overloaded Constructor for use with live database "streaming"

  Deployment() {
    // doesn't do anything, maybe will never use this at all
  } // end overloaded constructor

  
  // Methods
  
  void display() {
   
   drawTabBckgrd();
   for( int i = 0; i < tabs.length; i++ )
     tabs[ i ].drawTab( titleSize, deploymentFontSize );
  
 } // end of display() 




 
 void drawTabBckgrd() {
   stroke( 100, 100, 100 );
   fill( 100, 100, 100 );
   rect( 0, 0, 348, 30 );
 }




} // end class Deployment
