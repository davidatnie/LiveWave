// a class in the GUI component

class SpButton extends Button {

  // Fields

  String label;
  float xlabel, ylabel;
  color labelCol, baseCol, overCol, pressedCol;



  // Constructor

  SpButton( float x1p, float y1p, float x2p, float y2p, int linkIndexp, String labelp, color labelcolp, color basep, color overp, color pressedp ) {
    super( x1p, y1p, x2p, y2p, linkIndexp );
    x1 = x1p;
    y1 = y1p;
    x2 = x2p;
    y2 = y2p;
    linkIndex = linkIndexp;
    label = labelp;
    xlabel = x1 + ( ( (x2-x1) - textWidth( label ) ) / 2 );
    ylabel = y2 - ( ( (y2-y1) - 10 ) / 2 );
    labelCol = labelcolp;
    baseCol = basep;
    overCol = overp;
    pressedCol = pressedp;
  } // end constructor




  // Methods

  @Override
  void update() {
   super.update(); 
  }




  @Override
  void display() {
    //super.display();
    rectMode( CORNERS );
    if( over == true ) {
      if( pressed == true ) {
        stroke( labelCol );
        fill( pressedCol );              // Button pressed
        rect( x1, y1, x2, y2 );
      } 
      else {
        stroke( labelCol );
        fill( overCol );                    // Mouseover
        rect( x1, y1, x2, y2 );
      }
    } 
    else {
      stroke( labelCol );
      fill( baseCol );
      rect( x1, y1, x2, y2 ); // Base
    }
    textSize( 12 );
    fill( labelCol );
    text( label, xlabel, ylabel );     // Label
  } // end display()




} // end class spButton

