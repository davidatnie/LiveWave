class WavePt extends Function {

  // Fields

  int dispOrder;
  float intensityScore, waveRad, x, y;
  color waveRadc;
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
    println( " studentID " + studentID );
    student = owner.getStudent( studentID );
    println( "student with ID " + studentID + " added : " + ( student != null ) );
    isSelected = false;
    annotation = "";
    intensityScore = 0;
    x = o.x;
    y = o.y;
  } // end constructor



  // Methods

  void updateWaveRad() {
  // calculates the radius for this wavePoint, by mapping
  // its postTime from range of owner.minPostTime ~ owner.maxPostTime
  // to range of 0 ~ owner.maxRad  
  // 
    waveRad = map( postTime, 0, owner.maxPostTime, 0, owner.maxRad );
  } // end updateWaveRad()

  void updateWaveRadC() {
    waveRadc = color( floor( intensityScore * owner.rgbPropRate ) + 15 ); // color range is from 15 to 255 NEED TO CONFIRM
  } // end updateWaveRadC()




} // end class WavePt
