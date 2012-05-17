class Strat {
  // its got a name, frequency, and serial number
  // can add Hit frequency / Hit proportion etc here
  
  // Fields

  String name;
  int serialNum, freq;



  
  // Constructor

  Strat ( String tempName ) {
    name = tempName;
    freq = 1;
  } // end constructor



  
  // Methods

  void addFreq() {
    freq ++; 
  } // end addFreq




} // end class Strat
