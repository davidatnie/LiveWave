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
    for(  WavePt wp : downcasted.wave.wavePoints ) {
     if( wp.mouseOver )
     wp.isSelected = !wp.isSelected;
     } // end for 
  } // end processClickedWavePoint()
} // end class WaveUI

