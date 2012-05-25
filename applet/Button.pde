// Ancestor class of the GUI component.
// see also: class View, class Divider, class Dropdown, class View

class Button {

  // Fields

  float x1, y1;                              // The UL x- and y- coordinates
  float x2, y2;                              // The LR x- and y- coordinates
  color baseGray;                    // Default Gray value
  color overGray;                     // Value when mouse is over the button
  color pressGray;                   // Value when mouse is over and pressed
  boolean over = false;             // True when the mouse is over
  boolean pressed = false;       // True when the mouse is over and pressed
  int linkIndex;




  // Constructor

  Button( float x1p, float y1p, float x2p, float y2p, int linkIndexp ) {
    x1 = x1p;
    y1 = y1p;
    x2 = x2p;
    y2 = y2p;
    linkIndex = linkIndexp;
  } // end constructor




  // Methods

  // Updates the over field every frame
  void update() {
    if( ( mouseX > x1 ) && ( mouseX < x2 ) &&
      ( mouseY > y1 ) && ( mouseY < y2 ) )
      over = true;
    else
      over = false;
  } // end update()




  boolean press() {
    if( over == true ) {
      pressed = true;
      return true;
    } 
    else {
      return false;
    }
  } // end press()

  void release() {
    pressed = false;                 // Set to false when the mouse is released
  }



  
  void display() {
    stroke( 0 );
    if( pressed )
      fill( 50, 50, 50 );
    else {
      if( over )  
        fill( 240, 240, 240 );
      else
        fill( 180, 180, 180 );
    }
    rectMode( CORNERS );
    rect( x1, y1, x2, y2 );
  } // end display()
  
  int getIndex() {
    return linkIndex;
  } // end getIndex()




} // end Button class
