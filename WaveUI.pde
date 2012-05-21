class WaveUI extends AUI {

  // Fields




  // Constructor

  WaveUI( WaveActivity o ) {
    super( 350, 200, 1050, 750 );
    view.putBgColor( color( 255, 220, 200 ) );
    owner = o;
  } // end constructor




  // Methods

  @Override
  void executeMousePressed() {
    if( mouseButton == LEFT ) {
      processClickedView();
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




} // end class WaveUI
