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
    owner = o;
  } // end constructor




  // Methods

  @Override
  void executeMousePressed() {
    if( mouseButton == LEFT ) {
      processClickedView();
      // For Dropdowns
      processClickedDropdown();
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
