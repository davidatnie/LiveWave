// used by the Spiral viz. Basically it holds statistics on operands usage in the spokes of the spiral

class Stats {
  // Fields
  Spiral statsSpiral;
  OpsUsage cou; // cou stands for classOpsUsage
  OpsUsage sou; // sou stands for schoolOpsUsage
  boolean hasData;
  
  SyringeSet clsSyringes, schSyringes;
  
  int maxNumOps;
  
  int[] opsWt = new int[ 6 ];       // REMEMBER TO INCREASE THIS AS NEW TYPES OF OPERANDS ARE ADDED
  
    float plusWt, minusWt, timesWt, dividesWt, squareWt, negativeWt; // the Weight for the various Ops


  
  // Constructor
  Stats( Spiral tempSpiral, OpsUsage tempCou, OpsUsage tempSou ) {
    statsSpiral = tempSpiral;
    cou = tempCou;
    sou = tempSou;
    hasData = tempSpiral.hasData;
    
    // obtaining maxNumOps - to be passed on as argument when creating Syringe instance objects ( called scaleBase )
    maxNumOps = 0;
    
    int[] numOpsSch = new int[ 6 ]; // REMEMBER TO INCREASE THIS AS NEW TYPES OF OPERANDS ARE ADDED
        
    for( int i = 0; i < tempSou.plusOp.pointsAll.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.plusOp.pointsAll.get( i );
      numOpsSch[ 0 ] += pt.value * pt.count;      
    } // end for i for plusOp 
    
    for( int i = 0; i < tempSou.minusOp.pointsAll.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.minusOp.pointsAll.get( i );
      numOpsSch[ 1 ] += pt.value * pt.count;      
    } // end for i for minusOp
    
    for( int i = 0; i < tempSou.timesOp.pointsAll.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.timesOp.pointsAll.get( i );
      numOpsSch[ 2 ] += pt.value * pt.count;      
    } // end for i for timesOp
    
    for( int i = 0; i < tempSou.dividesOp.pointsAll.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.dividesOp.pointsAll.get( i );
      numOpsSch[ 3 ] += pt.value * pt.count;      
    } // end for i for dividesOp
    
    for( int i = 0; i < tempSou.squareOp.pointsAll.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.squareOp.pointsAll.get( i );
      numOpsSch[ 4 ] += pt.value * pt.count;      
    } // end for i for squareOp
    
    for( int i = 0; i < tempSou.negativeOp.pointsAll.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.negativeOp.pointsAll.get( i );
      numOpsSch[ 5 ] += pt.value * pt.count;     
    } // end for i for negativeOp
    
    maxNumOps = max( numOpsSch );
    // end of calculating maxNumOps
    

    /* NOTE : bypassing the routines below for Live Spiral
    // calculating Weight for the various types of Ops
        // <<see Stats.Fields above>> int[] opsWt = new int[ 6 ];       // REMEMBER TO INCREASE THIS AS NEW TYPES OF OPERANDS ARE ADDED
        
    for( int i = 0; i < tempSou.plusOp.pointsHit.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.plusOp.pointsHit.get( i );
      opsWt[ 0 ] += pt.value * pt.count;
    } // end for i for plusOp 
    
    for( int i = 0; i < tempSou.minusOp.pointsHit.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.minusOp.pointsHit.get( i );
      opsWt[ 1 ] += pt.value * pt.count;      
    } // end for i for minusOp
    
    for( int i = 0; i < tempSou.timesOp.pointsHit.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.timesOp.pointsHit.get( i );
      opsWt[ 2 ] += pt.value * pt.count;      
    } // end for i for timesOp
    
    for( int i = 0; i < tempSou.dividesOp.pointsHit.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.dividesOp.pointsHit.get( i );
      opsWt[ 3 ] += pt.value * pt.count;      
    } // end for i for dividesOp
    
    for( int i = 0; i < tempSou.squareOp.pointsHit.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.squareOp.pointsHit.get( i );
      opsWt[ 4 ] += pt.value * pt.count;      
    } // end for i for squareOp
    
    for( int i = 0; i < tempSou.negativeOp.pointsHit.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.negativeOp.pointsHit.get( i );
      opsWt[ 5 ] += pt.value * pt.count;
    } // end for i for negativeOp
    
    // FORMULA FOR CALCULATING WEIGHTS: WeightforOperandtypeX = Sum of totalnumberofHitOperands across all types of Operands / totalnumberofHitOperandsforOperandtypeX
    int grandTotalNumOps = 0;
    for( int i = 0; i < opsWt.length; i++ ) {
     grandTotalNumOps += opsWt[ i ];
    }
    plusWt = myRound( float( grandTotalNumOps ) / float( opsWt [ 0 ] ), 2 );
      if( opsWt[ 0 ] == 0 )         // Be careful of DIVISION BY ZERO!
        plusWt = 0;
    minusWt = myRound( float( grandTotalNumOps ) / float( opsWt [ 1 ] ), 2 );
      if( opsWt[ 1 ] == 0 ) 
        minusWt = 0;
    timesWt = myRound( float( grandTotalNumOps ) / float( opsWt [ 2 ] ), 2 );
      if( opsWt[ 2 ] == 0 ) 
        timesWt = 0;
    dividesWt = myRound( float( grandTotalNumOps ) / float( opsWt [ 3 ] ), 2 );
      if( opsWt[ 3 ] == 0 ) 
        dividesWt = 0;
    squareWt = myRound( float( grandTotalNumOps ) / float( opsWt [ 4 ] ), 2 );
      if( opsWt[ 4 ] == 0 ) 
        squareWt = 0;
    negativeWt = myRound( float( grandTotalNumOps ) / float( opsWt [ 5 ] ), 2 );
      if( opsWt[ 5 ] == 0 ) 
        negativeWt = 0;
    
    
    // end of calculating Weight for the various types of Ops
    */
    calculateWeightsForLiveSpiral( sou );
    
    
    //clsSyringes = new SyringeSet( tempCou, "cls", maxNumOps );
    //schSyringes = new SyringeSet( tempSou, "sch", maxNumOps );
    
  } // end constructor
  
  // Methods
  void display() {
    fill( 255 );
    stroke( 255 );
    rect( 0, 302, 348, height ); // clears panel
    fill( 0 );
    textSize( 10 );
    text( "DISTRIBUTION OF OPERANDS", 70, 335 );
    textSize( 8 );
    text( "Class", 280, 330 );
    text( "School", 280, 340 );
    stroke( 0, 64, 28 ); fill( 0, 64, 28 ); rect( 255, 320, 265,330);
    stroke( 61, 178, 112 ); fill( 61, 178, 112 ); rect( 265, 320, 275,330);
    stroke( 21, 137, 72 ); fill( 21, 137, 72 ); rect( 255, 330, 265,340);
    stroke(117, 232, 166 ); fill(117, 232, 166 ); rect( 265, 330, 275,340);
    // Displaying the pointsHit and PointsNoHit distributions of the specified operator in the current Active Dataset <testing>
    text( "For negativeOp, its Hit Distribution are as follows: ", 30, 400 );
    for( int i = 0; i < cou.negativeOp.pointsHit.size(); i++ ) {
      DistribPt p = ( DistribPt ) cou.negativeOp.pointsHit.get( i );
     text( p.value + " <===> " + p.count, 50, 410 + ( i * 10 ) );
    }
    
     text( "For negativeOp, its No-Hit Distribution are as follows: ", 30, 500 );
    for( int i = 0; i < cou.negativeOp.pointsNoHit.size(); i++ ) {
      DistribPt p = ( DistribPt ) cou.negativeOp.pointsNoHit.get( i );
     text( p.value + " <===> " + p.count, 50, 510 + ( i * 10 ) );
    }
    
    
    clsSyringes.plusSyr.drawSyringe();
    clsSyringes.minusSyr.drawSyringe();
    clsSyringes.timesSyr.drawSyringe();
    clsSyringes.dividesSyr.drawSyringe();
    clsSyringes.squareSyr.drawSyringe();
    clsSyringes.negativeSyr.drawSyringe();
    
    schSyringes.plusSyr.drawSyringe();
    schSyringes.minusSyr.drawSyringe();
    schSyringes.timesSyr.drawSyringe();
    schSyringes.dividesSyr.drawSyringe();
    schSyringes.squareSyr.drawSyringe();
    schSyringes.negativeSyr.drawSyringe();
    
    clsSyringes.plusSyr.isMouseOver = checkMouse( clsSyringes.plusSyr );
    clsSyringes.minusSyr.isMouseOver = checkMouse( clsSyringes.minusSyr );
    clsSyringes.timesSyr.isMouseOver = checkMouse( clsSyringes.timesSyr );    
    clsSyringes.dividesSyr.isMouseOver = checkMouse( clsSyringes.dividesSyr );
    clsSyringes.squareSyr.isMouseOver = checkMouse( clsSyringes.squareSyr );
    clsSyringes.negativeSyr.isMouseOver = checkMouse( clsSyringes.negativeSyr );  

    
    schSyringes.plusSyr.isMouseOver = checkMouse( schSyringes.plusSyr );
    schSyringes.minusSyr.isMouseOver = checkMouse( schSyringes.minusSyr );
    schSyringes.timesSyr.isMouseOver = checkMouse( schSyringes.timesSyr );    
    schSyringes.dividesSyr.isMouseOver = checkMouse( schSyringes.dividesSyr );
    schSyringes.squareSyr.isMouseOver = checkMouse( schSyringes.squareSyr );
    schSyringes.negativeSyr.isMouseOver = checkMouse( schSyringes.negativeSyr );  
    
    // display calculated Weights and the formula for the calculation
    String formula1, formula2, formula3;
    formula1 = "Weight of Operand type X = ";
    formula2 = "Schol-wise sum of ( Number of Operands on Hit functions ) across all Operands";
     formula3 = "School-wise Number of Operands on Hit functions for Operand type X ";
    fill( 0 );
    textSize( 10 );
    text( "CALCULATED WEIGHTS" , 70, 585 );
    fill( popUpBkgrd );
    stroke( popUpTxt ); 
    textSize( 8 );
    rect( 275, 575, 275 + (textWidth ( "  Formula?  " ) ), 588 );
    fill( popUpTxt );
    text( "  Formula?  ", 275, 585 );
    
    // show formula on mouseover
    if( ( mouseX > 275 ) && ( mouseX < 275 + (textWidth ( "  Formula?  " ) ) ) && ( mouseY > 575 ) && ( mouseY < 585 ) )  {
      fill( popUpBkgrd );
      stroke( popUpTxt );
      textSize(10  );
      rect( 275, 575 - 100, 275 + textWidth( formula1 ) + textWidth( formula2 ) + 30, 575 ); 
      // printing formula
      fill( popUpTxt );
      text( formula1, 275 + 5, 575  - 70 );
      text( formula2, 275 + 5 + textWidth( formula1 ) + 10, 575 - 80 );
      line( 275 + 5 + textWidth( formula1 ) + 5, 575 - 75, 275 + 5 + textWidth( formula1 ) + textWidth( formula2 ) + 15, 575 - 75 );
      text( formula3, 275 + 5 + textWidth( formula1 ) + 40, 575 - 60 );
      
      // printing example
      text( "Ex.      Weight [ + ] = ", 275 + 5, 575  - 20 );
      text( opsWt[ 0 ] + " + " + opsWt[ 1 ] + " + " + opsWt[ 2 ] + " + ... + " + opsWt[ 5 ], 275 + 5 + textWidth( "Ex.      Weight [ + ] = " ) + 10, 575 - 30 );
      line( 275 + 5 + textWidth( "Ex.      Weight [ + ] = " ) + 5, 575 - 25, 275 + 5 + textWidth( "Ex.      Weight [ + ] = " ) + 145 + 15, 575 - 25 );
      text( opsWt[ 0 ], 275 + 5 + textWidth( "Ex.      Weight [ + ] = " ) + 70, 575 - 10 );
      text( " = " + plusWt, 275 + 5 + textWidth( "Ex.      Weight [ + ] = " ) + 145 + 15 + 10, 575 - 20 );
    
    } // end if mouse within formula button
    
    
    fill( 0 );
    textSize( 8 );
    text( "The calculated Weights for the Operands are as follows: ", 30, 600 );
    text( "Weight  [ + ]    : " + plusWt, 50, 610 );
    text( "Weight   [ - ]    : " + minusWt, 50, 620 );
    text( "Weight   [ * ]    : " + timesWt, 50, 630 );
    text( "Weight   [ / ]    : " + dividesWt, 50, 640 );
    text( "Weight  [ ^ ]    : " + squareWt, 50, 650 );
    text( "Weight [ -() ]    : " + negativeWt, 50, 660 );
    
    
  } // end display(); 
 
  int[] getUniqueVals( int[] _dataArr ) {
    int[] result = new int[ 1 ];
    result[ 0 ] = _dataArr[ 0 ];
    
    for( int i = 1; i < _dataArr.length; i++ ) {
      int accounted = 0;
      for (int j = 0; j < result.length; j++ ) {
        if( _dataArr[ i ] == result[ j ] ) {
          accounted++;
        }
      } // end for j
      if( accounted == 0 ) {
        result = append( result, _dataArr[ i ] );// add to result array
      }
    } // end for i
    return result;
  } // end int[] makeDistrib
  
  int[] getCountVals( int[] _dataArr, int[] _vals ) {
    int[] result = new int[ _vals.length ];
    for( int i = 0; i < _vals.length; i++ ) { 
      for( int j = 0; j < _dataArr.length; j++ ) {
        if( _dataArr[ j ] == _vals[ i ] )
          result[ i ] ++; 
      } // end for j
    } // end for i
    return result;
  } // end getCountVals()
  
  boolean checkMouse( Syringe _s ) {
    if( ( mouseX >= _s.xS - 30 ) && ( mouseX <= _s.xS + _s.maxLength ) && ( mouseY >= _s.yS ) && ( mouseY <= _s.yS + _s.maxHeight ) ) {
      return true;
    } else
    return false;
  } // end checkMouse()




void calculateWeightsForLiveSpiral( OpsUsage tempSou ) {
 // calculating Weight for the various types of Ops --- FOR USE WITH LIVE SPIRAL ONLY
        
    for( int i = 0; i < tempSou.plusOp.pointsAll.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.plusOp.pointsAll.get( i );
      opsWt[ 0 ] += pt.value * pt.count;
    } // end for i for plusOp 
    
    for( int i = 0; i < tempSou.minusOp.pointsAll.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.minusOp.pointsAll.get( i );
      opsWt[ 1 ] += pt.value * pt.count;      
    } // end for i for minusOp
    
    for( int i = 0; i < tempSou.timesOp.pointsAll.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.timesOp.pointsAll.get( i );
      opsWt[ 2 ] += pt.value * pt.count;      
    } // end for i for timesOp
    
    for( int i = 0; i < tempSou.dividesOp.pointsAll.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.dividesOp.pointsAll.get( i );
      opsWt[ 3 ] += pt.value * pt.count;      
    } // end for i for dividesOp
    
    for( int i = 0; i < tempSou.squareOp.pointsAll.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.squareOp.pointsAll.get( i );
      opsWt[ 4 ] += pt.value * pt.count;      
    } // end for i for squareOp
    
    for( int i = 0; i < tempSou.negativeOp.pointsAll.size(); i++ ){
      DistribPt pt = ( DistribPt ) tempSou.negativeOp.pointsAll.get( i );
      opsWt[ 5 ] += pt.value * pt.count;
    } // end for i for negativeOp
    
    // FORMULA FOR CALCULATING WEIGHTS: WeightforOperandtypeX = Sum of totalnumberofHitOperands across all types of Operands / totalnumberofHitOperandsforOperandtypeX
    int grandTotalNumOps = 0;
    for( int i = 0; i < opsWt.length; i++ ) {
     grandTotalNumOps += opsWt[ i ];
    }
    plusWt = myRound( float( grandTotalNumOps ) / float( opsWt [ 0 ] ), 2 );
      if( opsWt[ 0 ] == 0 )         // Be careful of DIVISION BY ZERO!
        plusWt = 0;
    minusWt = myRound( float( grandTotalNumOps ) / float( opsWt [ 1 ] ), 2 );
      if( opsWt[ 1 ] == 0 ) 
        minusWt = 0;
    timesWt = myRound( float( grandTotalNumOps ) / float( opsWt [ 2 ] ), 2 );
      if( opsWt[ 2 ] == 0 ) 
        timesWt = 0;
    dividesWt = myRound( float( grandTotalNumOps ) / float( opsWt [ 3 ] ), 2 );
      if( opsWt[ 3 ] == 0 ) 
        dividesWt = 0;
    squareWt = myRound( float( grandTotalNumOps ) / float( opsWt [ 4 ] ), 2 );
      if( opsWt[ 4 ] == 0 ) 
        squareWt = 0;
    negativeWt = myRound( float( grandTotalNumOps ) / float( opsWt [ 5 ] ), 2 );
      if( opsWt[ 5 ] == 0 ) 
        negativeWt = 0;
    
    // end of calculating Weight for the various types of Ops
} // end calculateWeightsForLiveSpiral()
  
} // end class Stats


// =======================================================================================
class Syringe {
  // Fields
  float maxLength, maxHeight, cylLength, cylFill, xS, yS;
  int valAll, valNoHit, valHit, scaleBase;
  boolean isMouseOver, showLabel;
  String label;
  color colFill, colNoFill, colSlot;
  int[] countOpHit, countOpNoHit, countOpAll;
  OpDistrib distribHit, distribNoHit, distribAll;
  
  ArrayList pointsHit, pointsNoHit, pointsAll;
  
  // Constructor
  Syringe( float _xS, float _yS,  String _label, boolean _showLabel, ArrayList _pointsHit, ArrayList _pointsNoHit, ArrayList _pointsAll, int _scaleBase, color _colNoFill, color _colFill ) {
    colNoFill = _colNoFill;
    colFill = _colFill;
    colSlot = color( 230, 230, 230 , 255 );
    maxLength = 300;
    maxHeight = 15;
    xS = _xS;
    yS = _yS;
    label = _label;
    showLabel = _showLabel;
    isMouseOver = false;   
    scaleBase = _scaleBase;
    pointsHit = _pointsHit;
    pointsNoHit = _pointsNoHit;
    pointsAll = _pointsAll;
    
    // computing cylFill and cylLength
    valHit = 0;
    for( int i = 0; i < _pointsHit.size(); i++ ) {
      DistribPt pt = ( DistribPt ) _pointsHit.get( i );
      valHit += ( pt.value * pt.count );
    } // end for i
    cylFill = float( valHit);
    
    valNoHit = 0;
    for( int i = 0; i < _pointsNoHit.size(); i++ ) {
      DistribPt pt = ( DistribPt ) _pointsNoHit.get( i );
      valNoHit += ( pt.value * pt.count );
    } // end for i
    valAll = valHit + valNoHit;
    cylLength = float( valAll );

  } // end constructor
  
  // overloaded Constructor
  Syringe( float _xS, float _yS, String _label, boolean _showLabel, int _valHit, int _valAll, int _scaleBase, color _colNoFill, color _colFill, int[] _distribVals, int[] _distribCounts ) {
    colFill = _colFill;
    colNoFill = _colNoFill;
    colSlot = color( 230, 230, 230 , 255 );
    maxLength = 300;
    maxHeight = 15;
    xS = _xS;
    yS = _yS;
    valHit = _valHit;
    valAll = _valAll;
    label = _label;
    showLabel = _showLabel;
    isMouseOver = false;    
    cylFill = float( _valHit );
    cylLength = float( _valAll );
    scaleBase = _scaleBase;
  } // end constructor
  
  // Methods
  void drawSyringe() {
    stroke( colSlot );
    fill( colSlot );
    rect( xS, yS, xS + maxLength, yS + maxHeight );
    stroke( colNoFill );
    fill( colNoFill );
    if( cylLength > 0 )     // draw only if value of cylLength is > 0
      rect( xS, yS, xS + map( cylLength, 0, scaleBase, 0, maxLength ) - 1, yS + maxHeight );
    stroke( colFill );
    fill( colFill );
    if( cylFill > 0 )     // draw only if value of cylFill is  > 0
      rect( xS, yS, xS + map( cylFill, 0, scaleBase, 0, maxLength ) - 1, yS + maxHeight );
    
    if( showLabel ) {
      fill( 0 );
      stroke( 0 );
      textSize( 8 );
      text( label, xS - 30, yS + 12);
    } // end if showLabel
      
    if( isMouseOver ) {
      drawMouseOver();
    }
  } // end drawSyringe()
  
  void drawMouseOver() {
    if( mouseX < xS ) { // show composition of the counts for the Hit and No-Hit functions
      fill( colSlot );
      stroke( colSlot );
      rect( xS, yS, xS + ( 1 * maxLength ), yS + maxHeight );
          
      // display composition:
      int v, c, k, startNH;
      fill( colFill );
      stroke( colFill );
      k = 0;
      startNH = 0;
      for( int i = 0; i < pointsHit.size(); i++ ) {
        DistribPt pt = ( DistribPt ) pointsHit.get( i );
        v = pt.value;
        c = pt.count;
        if( v > 0 ) {     // only draw if value > 0
          for( int j = 0; j < c; j++ ) {
            rect( xS + k, yS, xS + k + v - 1, yS + maxHeight );
            k += v + 1;
            startNH = k;
          } // end for j
        } // end if v > 0
      } // end for i
      
      
      // show composition for the No-Hit Ops
      v = 0;
      c = 0;
      k = 0;
      fill( colNoFill );
      stroke( colNoFill );
      k = 0;
      for( int i = 0; i < pointsNoHit.size(); i++ ) {
        DistribPt pt = ( DistribPt ) pointsNoHit.get( i );
        v = pt.value;
        c = pt.count;
        if( v > 0 ) {     // only draw for values  > 0
          for( int j = 0; j < c; j++ ) {
            rect( xS + startNH + k, yS, xS + startNH + k + v - 1, yS + maxHeight );
            k += v + 1;
          } // end for j
       } // end if v > 0
      } // end for i
    } else { // show count numbers for the Hit and No-Hit functions ( mouseX > xS )
      fill( 0 );
      textSize( 12 );
      text( "Count: " + ( valHit ) + " / " + ( valAll ), xS + ( 1 * maxLength ) - 120 + 10, yS + maxHeight - 3 );
    } // end show count numbers

  } // end drawMouseOver()
  
  
} // end class Syringe

// ====================================================================
class SyringeSet {
  // Fields
  Syringe plusSyr, minusSyr, timesSyr, dividesSyr, squareSyr, negativeSyr;
  int maxRange;
  
  // Constructor
  SyringeSet( OpsUsage _ou, String setType, int _maxRange ) {
    int[] yPoses = new int[ 6 ];
    boolean showLabel;
    color colFill, colNoFill;
    if( setType.equals( "cls" ) == true ) { // set yPoses, showLabel, and colors for clsSyringes
      showLabel = true;
      colNoFill = color( 61, 178, 112 );
      colFill = color( 0, 64, 28 );
      for( int y = 0; y < 6; y++ ) {
        yPoses[ y ] = 345 + ( y * 35 );
      } // end for y
    } else { // settings for schSyringes
    showLabel = false;
      colNoFill = color( 117, 232, 166 );
      colFill = color( 21, 137, 70 );
      for( int y = 0; y < 6; y++ ) {
        yPoses[ y ] = 360 + ( y * 35 );
      } // end for y
    } // end else ( settings )
    maxRange = _maxRange;
    
    plusSyr = new Syringe( 30, yPoses[ 0 ], _ou.plusOp.label, showLabel, _ou.plusOp.pointsHit, _ou.plusOp.pointsNoHit, _ou.plusOp.pointsAll, maxRange, colNoFill, colFill );
    minusSyr = new Syringe( 30, yPoses[ 1 ], _ou.minusOp.label, showLabel,  _ou.minusOp.pointsHit, _ou.minusOp.pointsNoHit, _ou.minusOp.pointsAll, maxRange, colNoFill, colFill );
    timesSyr = new Syringe( 30, yPoses[ 2 ], _ou.timesOp.label, showLabel,  _ou.timesOp.pointsHit, _ou.timesOp.pointsNoHit, _ou.timesOp.pointsAll, maxRange, colNoFill, colFill );
    dividesSyr = new Syringe( 30, yPoses[ 3 ], _ou.dividesOp.label, showLabel,  _ou.dividesOp.pointsHit, _ou.dividesOp.pointsNoHit, _ou.dividesOp.pointsAll, maxRange, colNoFill, colFill );
    squareSyr = new Syringe( 30, yPoses[ 4 ], _ou.squareOp.label, showLabel,  _ou.squareOp.pointsHit, _ou.squareOp.pointsNoHit, _ou.squareOp.pointsAll, maxRange, colNoFill, colFill );
    negativeSyr = new Syringe( 30, yPoses[ 5 ], _ou.negativeOp.label, showLabel,  _ou.negativeOp.pointsHit, _ou.negativeOp.pointsNoHit, _ou.negativeOp.pointsAll, maxRange, colNoFill, colFill );
 
  } // end constructor
  
  // Methods
} // end class SyringeSet
