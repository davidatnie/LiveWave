// used by the Spiral viz. DistribPt stands for Distribution Point

class DistribPt {
  // Fields
  int value, count;
  
  // Constructor
  DistribPt( int _value, int _count ) {
    value = _value;
    count = _count;
  }
  // Methods
  String toString() {
    return( "Val:" + value + " , Count:" + count );
  }
} // end class DistribPt
