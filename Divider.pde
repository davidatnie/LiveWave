// a class in the GUI component. This is just a single straight line divider.

class Divider {
  // Fields
  float x1, y1, x2, y2;
  int coll, colb, cold;
  boolean horizontal;

  // Constructor
  Divider( boolean _horizontal, float _x1, float _y1, float _x2, float _y2, int _col ) {
    horizontal = _horizontal;
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
    coll = constrain( _col + 60, 0, 255 );
    colb = _col;
    cold = constrain( _col - 60, 0, 255 );
  } // end constructor

  void display() {
    strokeWeight( 1 );
    if( horizontal ) {                              // divider is horizontal
      stroke( coll );
      line( x1, y1 - 1, x2, y2 - 1 );
      stroke( colb );
      line( x1, y1,      x2,      y2 );
      stroke( cold );
      line( x1, y1 + 1, x2, y2 + 1 );
    } 
    else {                                            // divider is vertical
      stroke( coll );
      line( x1 - 1, y1, x2 - 1, y2 );
      stroke( colb );
      line( x1, y1,      x2,      y2 );
      stroke( cold );
      line( x1 + 1, y1, x2 + 1, y2 );
    }
  } // end display()
} // end class Divider
