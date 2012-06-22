class WaveUI extends AUI {

  // Fields




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
      
    createSpButton( o.x1Frame + 50, o.y1Frame + 50, o.x1Frame + 150, o.y1Frame + 100, getNextIndexArrSpButtons(), "Choose Code(s)", popUpTxt, popUpBkgrd, butOv, butPress );

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
        PopUpCodeChooser pc = new PopUpCodeChooser( downcasted, currentWave.codeCabinet, currentWave.selCodes );
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

