// class in the GUI component

class ScrollPosButton extends Button {

  // Fields
  View owner;
  String orientation;          // values are either: "HORIZONTAL" or "VERTICAL"
  float spbWidth, spbHeight;
  boolean onDrag;



  // Constructor
  ScrollPosButton( View o, float x1Temp, float y1Temp, float x2Temp, float y2Temp, int linkIndexTemp, String typeTemp ) {
    // value of typeTemp is either "HORIZONTAL" or "VERTICAL"
    super( x1Temp, y1Temp, x2Temp, y2Temp, linkIndexTemp );
    owner = o;
    spbWidth = x2 - x1;
    spbHeight = y2 - y1;
    onDrag = false;
    orientation = typeTemp;
  } // end constructor


  // Methods

  void reposition( float[] scrollPosTemp ) {
    if( orientation.equals( "VERTICAL" ) ) {
      y1 = map( scrollPosTemp[ 1 ], 0, owner.contentHeight, owner.y1+20, owner.y2a - 20 );
     y2 = map( scrollPosTemp[ 3 ], 0, owner.contentHeight, owner.y1+20, owner.y2a - 20 );
    } else { 
    // making implicit assumption here that type must be "HORIZONTAL" if its not "VERTICAL"
      x1 = map( scrollPosTemp[ 0 ], 0, owner.contentWidth, owner.x1a + 20, owner.x2a - 20 );
      x2 = map( scrollPosTemp[ 2 ], 0, owner.contentWidth, owner.x1a + 20, owner.x2a - 20 );
    }
  } // end reposition()
  
  
  
  void release() {
    super.release();
    onDrag = false;
  } // end release()



} // end class ScrollPosButton
