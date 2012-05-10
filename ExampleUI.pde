// Better keep this as an example, lest I forget how the structure and flow is ..

class ExampleUI extends AUI {

  // Fields



  
  // Constructor

  ExampleUI ( ExampleActivity o, float x1v, float y1v, float x2v, float y2v ) {
    super( x1v, y1v, x2v, y2v );
    owner = o;
  } // end constructor



  
  // Methods

  @Override
  void update() {
    super.update();
  } // end update()



  
  @Override
  void display() {
    super.display();
  } // end display()



  
  @Override
  void executeMousePressed() {
  // All The Logic For UI Interaction go in here
  if( mouseButton == LEFT )
    processClickedView();
  
  } // end executeMousePressed()



  
  @Override
  void executeMouseDragged() {
    processDraggedView();
  } // end executeMouseDragged()
  
  
  
  
  @Override
  void executeMouseReleased() {
    super.executeMouseReleased();
  } // end executeMouseReleased()




} // end class ExampleUI
