class WavePtComparator implements Comparator{
  // fields
  ArrayList<String> eqs;

  WavePtComparator( ArrayList<String> input ) {
    super();
    eqs = new ArrayList<String>();
    eqs = input;
  } // end constructor

  int compare( Object o1, Object o2 ) {
    WavePt w1 = ( WavePt ) o1;
    WavePt w2 = ( WavePt ) o2;
    if( w1.onShow == true && w2.onShow == false )
      return -1;
    if( w2.onShow == true && w1.onShow == false )
      return +1;
    if( w1.postTime < w2.postTime )
      return -1;
    if( w1.postTime > w2.postTime )
      return +1;
    return w1.funcString.compareTo( w2.funcString );
  } // end compare()

} // end class WavePtComparator