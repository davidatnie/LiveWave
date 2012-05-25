// Class for GenSing Controller
// Joystick pointer ( pointer controlled by joystick on the GenSing Controller - emulating standard Mouse Pointer )

// has got a shape ( not implemented yet, now its just a dot ), with color and other visual properties
// has got coordinates
// has got set get and update methods

class JPointer {

  // Fields

  int xPos;
  int yPos;
  color bColor;  // border color
  color fColor;  // fill color
  



  // Constructor

  JPointer( int tempXPos, int tempYPos, color tempBColor, color tempFColor ) {
    xPos = tempXPos;
    yPos = tempYPos;
    bColor = tempBColor;
    fColor = tempFColor;
  } // end constructor



  
  // Methods

  void updateXY( int dX, int dY ) {
    xPos = xPos + dX;
    yPos = yPos + dY;
    constrain( xPos, 0, width );
    constrain( yPos, 0, height );
  } // end setXY()



  
  int getX() {
   return xPos; 
  } // end getX()



  
  int getY() { 
    return yPos;
  } // end getY()



  
  void display() {
    stroke( bColor );
    fill( fColor );
    strokeWeight( 2 );
    ellipse( xPos, yPos, 10, 10 );
  } // end update()




} // end class JPointer
