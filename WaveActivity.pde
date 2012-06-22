// The main class for the Live Wave visualizer
// see also class WaveUI

class WaveActivity extends LVActivity {

  // Fields
  WaveUI wvaUI;
  Wave wave;
  PopUpInput poInput;




  // Constructor
  WaveActivity( LiveWave o ) {
    super( o );
    //bgColor = color( 250, 250, 250 );
    bgColor = color( 0, 0, 0 );
    wvaUI = new WaveUI( this );
    aUI = wvaUI;

    wave = new Wave();
  } // end constructor




  // Methods
  
  void display() {
    super.display();
  } // end display()




  void prerender() {
    super.prerender();
    View renderer = aUI.view;
    wave.drawWave( renderer );
  } // end prerender()
  
  
  
  
  void render() {
    super.render();
    if( hasNewDatastream ) // hasNewDatastream is set in LVActivity.updateDataStream()
      processDatastream( databaseStream );
    prepForNextDatastream();
    View renderer = aUI.view;
    renderer.updateOffsetRenders();
    wave.display( renderer );
    wave.ribbon.drawThreadInView( renderer );
  } // end render()




  void startWave( String[] aDetails ) {
  // aDetails [0] [1] [2] is url, startTime and title
  //
    println( "in WaveActivity.startWave(), now calling super.startLV()" );
    super.startLV( aDetails );

    // create a new wave and put in activity details into it
    print( "Creating new Wave using provided details: " + aDetails[ 1 ] + " " + aDetails[ 2 ] + " ... " );
    wave.sproutWave( aDetails[ 1 ], aDetails[ 2 ], codeCabinet ); // pass codeCabinet to Wave
    println( "[DONE]" );
  } // end startWave()




  void processDatastream( Table databaseStream ) {
    println( "processing Databasestream for Wave ... " );
    wave.growWave( databaseStream );
    wave.lastCountForFuncs = wave.funcs.size();
  } // end processDatastream()



  Wave getWave() {
    return wave;  
  } // end getWave()
  



  void openPopUpInput() {
    WavePt wpMO = wave.getWavePointMouseOver();
    if( wpMO != null ) {
      if( poInput != null )
        poInput.dispose();
        
      String POInputTitle = "Annotate " + wpMO.funcString;
      if( POInputTitle.length() > 40 ) {
        POInputTitle = POInputTitle.substring( 0, 37 ) + "...";
      }
      poInput = new PopUpInput( this, wpMO, POInputTitle, "Type in text below:", wpMO.annotation );
    }
  }

  
  
  
  String toString() { 
    return( "This is WaveActivity." );
  } // end toString()




} // end class WaveActivity
