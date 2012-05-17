// The main class for the Live Wave visualizer
// see also class WaveUI

class WaveActivity extends LVActivity {

  // Fields
  WaveUI wvaUI;
  Wave wave;




  // Constructor
  WaveActivity( LiveViz o ) {
    super( o );
    bgColor = color( 255,255,255 );
    wvaUI = new WaveUI( this );
    aUI = wvaUI;

    wave = new Wave();
  } // end constructor




  // Methods
  
  void display() {
    super.display();
  } // end display()




  void render() {
    View renderer = aUI.view;
    renderer.updateOffsetRenders();
    fill( 250, 0 , 250 );
    renderer.putRect( 50, 100, 300, 400 );
    fill( 0, 200, 160 );
    renderer.putTextFont( spiralFont, 60 );
    renderer.putText( "Aloha!", 1000, 900 );
    fill( 0, 100, 250 );
    renderer.putTextSize( 10 );
    renderer.putText( "rockin' awesome!", 700, 600 );
    wave.display( renderer );
  } // end render()




  void startWave( String[] aDetails ) {
    // aDetails [0] [1] [2] is url, startTime and title
    super.startLV( aDetails );

    // create a new wave and put in activity details into it
    print( "Creating new Wave using provided details: " + aDetails[ 1 ] + " " + aDetails[ 2 ] + " ... " );
    wave.sproutWave( aDetails[ 1 ], aDetails[ 2 ] );
    println( "[DONE]" );
  } // end startWave()




  void processDatastream( Table databaseStream ) {
    wave.growWave( databaseStream );
    wave.lastCountForFuncs = wave.funcs.size();
  } // end processDatastream()




  String toString() {
    return( "This is WaveActivity" );
  } // end toString()




} // end class WaveActivity
