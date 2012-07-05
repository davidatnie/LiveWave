class WaveUI extends AUI {

  // Fields
  PopUpCodeChooser pucc;




  // Constructor

  WaveUI( WaveActivity o ) {
    super( 300, 200, 1150, 750 );
    view.putBgColor( color( 255, 220, 200 ) );
    /*
    createDropdown( o.x1Frame + 500, o.y2Frame - 30, o.x1Frame + 780, o.y2Frame - 10, getNextIndexArrDropdowns(), "BLAH :" );
     Dropdown d = arrDropdowns.get( 0 );
     String[] bleh = { "a", "b", "c" };
     d.buildDDItems( bleh );
     */
      
    createSpButton( o.x2Frame - 120, o.y1Frame + 50, o.x2Frame - 20, o.y1Frame + 90, getNextIndexArrSpButtons(), "Choose Code(s)", color( 0, 0, 0 ), color( 180, 180, 180 ), color( 250, 250, 250 ), butPress );

    createSpButton( o.x1Frame + 400, o.y1Frame + 760, o.x1Frame + 500, o.y1Frame + 790, getNextIndexArrSpButtons(), "SORT", color( 0, 0, 0 ), color( 180, 180, 180 ), color( 250, 250, 250 ), butPress );

    //createSpButton( o.x1Frame + 550, o.y1Frame + 760, o.x1Frame + 650, o.y1Frame + 790, getNextIndexArrSpButtons(), "COMMENT", color( 0, 0, 0 ), color( 180, 180, 180 ), color( 250, 250, 250 ), butPress );

    createSpButton( o.x1Frame + 700, o.y1Frame + 760, o.x1Frame + 800, o.y1Frame + 790, getNextIndexArrSpButtons(), "LOAD", color( 0, 0, 0 ), color( 180, 180, 180 ), color( 250, 250, 250 ), butPress );

    createSpButton( o.x1Frame + 850, o.y1Frame + 760, o.x1Frame + 950, o.y1Frame + 790, getNextIndexArrSpButtons(), "SAVE", color( 0, 0, 0 ), color( 180, 180, 180 ), color( 250, 250, 250 ), butPress );

    owner = o;
  } // end constructor




  // Methods

  @Override
    void executeMousePressed() {

    WaveActivity downcasted = ( WaveActivity ) owner;
    Wave currentWave = downcasted.wave;
    if ( mouseButton == LEFT ) { 
      
      int whichOne = getPressedArrSpButton();
      if( whichOne == 0 ) { // "Choose Code(s)"
        if( pucc!= null) 
          pucc.dispose();
        pucc= new PopUpCodeChooser( downcasted, currentWave.codeCabinet, currentWave.selCodes );
      } else if( whichOne == 1 ) { // "SORT"
        downcasted.wave.sortBy( downcasted.wave.selEqs );
      } else if( whichOne == 2 )  { // "LOAD"
      
        // NEED TO ENSURE ONLY ONE INSTANCE OF THE DIALOG OPENS UP FOR LOAD AND SAVE
      
        PopUpLoadState puls = new PopUpLoadState( downcasted, downcasted.wave );
      } else if( whichOne == 3 ) { // "SAVE"
        PopUpSaveState ps = new PopUpSaveState( downcasted, downcasted.wave, downcasted.wave.stateName, downcasted.wave.actid, downcasted.wave.comments );
      }
           
      processClickedView();
      processClickedWavePoint();
      // For Dropdowns
      processClickedDropdown();
    } else if( mouseButton == RIGHT ) {
      downcasted.openPopUpInput();
    }
  } // end executeMousePressed()




  @Override
    void executeMouseDragged() {
    processDraggedView();
  } // end executeMouseDragged()




  @Override
    void update() {
    super.update();
  } // end update()




  @Override
    void display() {
    super.display();
  } // end display()




  void processClickedWavePoint() {
    WaveActivity downcasted = (WaveActivity) owner;
    String fString = "";

    for(  WavePt wp : downcasted.wave.wavePoints ) {
     if( wp.mouseOver ) {
        fString = wp.funcString;
        ArrayList<String> sel = downcasted.wave.selEqs;
        if( sel.contains( fString ) == false )
          sel.add( fString );
        else
          sel.remove( fString );
        break;
      }
    }

    for( WavePt wp : downcasted.wave.wavePoints ) {
      if( wp.funcString.equals( fString ) )
        wp.isSelected = !wp.isSelected;
     } // end for
 
  } // end processClickedWavePoint()
} // end class WaveUI

