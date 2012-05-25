// used by the Sipral viz. Each instance of Spoke holds information about one "unique" contribution. 
// see also : class Function

// Requires the following classes:
//         - Function (as a super class)

class Spoke extends Function {

  // Fields

  int serialNum;                     // holds the serial number of the Spoke, sorted by Genesis, in min to max
  int genesis;                         // holds the time (in int) this function first occured in the exercise
  Post_Time cGenesis;          // holds the genesis converted into Post_Time object
  int freq;                             // holds the frequency of occurence of this function throughout the exercise 
  float mappedLength;          // holds the length of the spoke, mapped from (0 - maximum post time in the exercise) to (0 - 200 pixels). Value is not set in constructor
  color c;                               // color of the spoke when displayed. Green - HIT; Red - NO-HIT
  PFont f;                              // holds the font to display the function string

  int numOpPlus, numOpMinus, numOpTimes, numOpDivides, numBonSquare, numBonNegative;

  float baseX, baseY, innerX, innerY, outerX, outerY, shortX, shortY;
  boolean isMouseOverFunc;
  int xMOFunc, yMOFunc;         // coordinate of the pointer that is hovering over the spoke's Func
  boolean isMouseOverFreq;
  int xMOFreq, yMOFreq;          // coordinate of the pointer that is hovering over the spoke's Freq

    float crvScore; // Creativity Metric Score




    // Constructor

  Spoke( Table _artefacts, int row ) {
    super( _artefacts, row );  
    c = setColor( hitTxt );
    freq = 1;
    isMouseOverFunc = false;
    isMouseOverFreq = false;
    mineOpsBons( funcString );
    cGenesis = new Post_Time( genesis, "00:00:00" );
    xMOFunc = int( outerX );
    yMOFunc = int( outerY );
    xMOFreq = int( innerX );
    yMOFreq = int( innerY );
  } // end constructor




  // Overloaded constructor for live database streaming
  Spoke( Table _artefacts, int row, int tempSN ) {
    super( _artefacts, row, tempSN );  
    c = setColor( hitTxt );
    freq = 1;
    isMouseOverFunc = false;
    isMouseOverFreq = false;
    mineOpsBons( funcString );
    cGenesis = new Post_Time( genesis, "00:00:00" );
    xMOFunc = int( outerX );
    yMOFunc = int( outerY );
    xMOFreq = int( innerX );
    yMOFreq = int( innerY );
  } // end overloaded constructor




  // Methods

  color setColor( boolean hit ) {
    if ( hit )
      return color( hitColor );       // hitColor and noHitColor are global variables for easy modification
    else
      return color( noHitColor);
  } // end setColor




    // Overloaded version
  color setColor( String s ) {
    if ( s.equals( "HIT" ) )
      return color( hitColor );
    else if ( s.equals( "NO-HIT" ) )
      return color( noHitColor );
    else if ( s.equals( "UNASSESSED" ) )
      return color( 128 );
    else
      return color( 128 );
  } // end setColor




  void mineOpsBons( String tempFuncString ) {
    for ( int i = 0; i < tempFuncString.length(); i++ ) {
      if ( tempFuncString.charAt( i ) == '+' ) 
        numOpPlus++;
      else if ( tempFuncString.charAt( i ) == '*' )
        numOpTimes++;
      else if ( tempFuncString.charAt( i ) == '/' )
        numOpDivides++;
      else if ( tempFuncString.charAt( i ) == '^' )
        numBonSquare++;
      else if ( tempFuncString.charAt( i ) == '-' ) {
        if ( ( i == 0 ) || ( hasPrecedingOp( tempFuncString, i - 1 ) ) )
          numBonNegative++;
        else
          numOpMinus++;
      } // end if found minus sign
    } // end for i
  } // end mineOpsBons()




  boolean hasPrecedingOp( String func, int loc ) {
    if ( ( func.charAt( loc ) == '+' ) || ( func.charAt( loc ) == '-' ) || ( func.charAt( loc ) == '*' ) 
      || ( func.charAt( loc ) == '/' ) || ( func.charAt( loc ) == '^' ) ) {
      return true;
    } 
    else {
      return false;
    }
  } // end hasPrecedingOp()




  void computeCRVScore( float _plusWt, float _minusWt, float _timesWt, float _dividesWt, float _squareWt, float _negativeWt  ) {
    crvScore = 0;
    crvScore = ( numOpPlus * _plusWt ) + ( numOpMinus * _minusWt ) + ( numOpTimes * _timesWt ) + ( numOpDivides * _dividesWt ) + ( numBonSquare * _squareWt ) + ( numBonNegative * _negativeWt );
  } // end computeCRVScore()




  String toString() {
    String ret = "";
    ret += ( serialNum + " ~ " + genesis + " ~ " + cGenesis + " ~ " + funcString + " ~ " + freq + " ~ " + mappedLength + " ~ " + crvScore + "\n" );
    ret += ( "          baseX:" + baseX + " baseY:" + baseY + " innerX:" + innerX + " innerY:" + innerY + " outerX:" + outerX + " outerY:" + outerY + " shortX:" + shortX + " shortY:" + shortY + "\n" );
    return ret;
  } // end toString()
} // end class Spoke

