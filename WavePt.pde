class WavePt extends Function {

  // Fields

  int dispOrder;
  float intensityScore, x, y;
  Student student;
  Wave owner;
  String annotation;
  boolean isSelected;
  

  // Constructor
  WavePt( Wave o, Table t, int row, int tempSN ) {
  // WavePoints are created after Wave is created
  //
    super( t, row, tempSN );
    owner = o;
    student = owner.getStudent( studentID );
    isSelected = false;
    annotation = "";
    intensityScore = 0;
    x = 0;
    y = 0;
  } // end constructor



  // Methods



} // end class WavePt
