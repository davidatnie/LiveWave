// used by the Spiral viz. OpDistrib stands for Operand Distribution

class OpDistrib {
  // Fields:
  int[] procVals, procCounts;
  int walker = 0;
  ArrayList pointsHit, pointsNoHit, pointsAll;
  String label;
  
  // Constructor

  OpDistrib( char opType, Spiral _spiral ) {
    procVals = new int[ 1 ];
    procCounts = new int[ 1 ];
    
    // Live Spiral will ignore the seed - populate - harvest cycles for HIT and NO-HITs since the live data
    // are still UNASSESSED
    /*
    seedProcArrs( opType, _spiral, true ); // for Hit functions first; HIT = true, No-Hit = false;
    populateProcArrs( opType, _spiral, true );
    harvestProcArrs( true );
    
    resetProcArrs();
    
    seedProcArrs( opType, _spiral, false ); // now for NoHit functions; HIT = true, No-Hit = false;
    populateProcArrs( opType, _spiral, false );
    harvestProcArrs( false );
    
    resetProcArrs();
    */
    populateProcArrs( opType, _spiral ); // now for both Hit and NoHit functions. Note: No Seeding needed for All
    harvestProcArrs();
    
    // Live Spiral will ignore HIT and NO-HIT
    // sortDistribPoints( pointsHit );
    // sortDistribPoints( pointsNoHit );
    sortDistribPoints( pointsAll );
        
    //showDistribPoints();
  
  } // end constructor
  
  OpDistrib( char _opType ) {         // Overloaded constructor for instantiating OpDistrib objects for datasets which contain no data ("NO DATA")
    switch( _opType ) {      // pass on _opType to determine label
      case 'P':
        label = "[ + ]";
      break;
      case 'M':
        label = "[ - ]";
      break;
      case 'T':
        label = "[ * ]";
      break;
      case 'D':
        label = "[ / ]";
      break;
      case 'S':
        label = "[ ^ ]";
      break;
      case 'N':
        label = "[ -() ]";
      break;
      default :
        label = "";
      break;      
    } // end switch
    
    // create three ArrayLists of DistribPt objects, with value and count of 0 and 0 - for the NO DATA section
    pointsHit = new ArrayList();
    pointsHit.add( new DistribPt( 0, 0 ) );
    pointsNoHit = new ArrayList();
    pointsNoHit.add( new DistribPt( 0, 0 ) );
    pointsAll = new ArrayList();
    pointsAll.add( new DistribPt( 0, 0 ) );
    
    
  } // end constructor (Overloaded)
  
  OpDistrib( ArrayList _pointsHit, ArrayList _pointsNoHit, ArrayList _pointsAll, String _label ) { // overloaded constructor for instantiating School-level OpDistrib objects
    pointsHit = _pointsHit;
    pointsNoHit = _pointsNoHit;
    pointsAll = _pointsAll;
    label = _label;
  } // end constructor ( Overloaded )
  
  
  // can a class have no constructor??? YES
  // the array dimension for vals and counts have not yet been declared. Is there a need to declare the dimensions first before assigning values into them??? YES ( but the object instance must be instantiated first - the OpDistrib object must be instantiated first )
  
  // Methods
  void seedProcArrs( char opType, Spiral _spiral, boolean _hit ) {
    int comparisonOp = 0;
    boolean hitMatch = false;
    int c = 0;
    while( ( hitMatch == false )  && ( c <= _spiral.spokes.size() )  ){
      Spoke s1 = ( Spoke ) _spiral.spokes.get( c ); // go through each row till first hitMatch is found
      c++;
      if( _hit == s1.hit ) {
        hitMatch = true;
        switch( opType ) {
          case 'P' :
            comparisonOp = s1.numOpPlus;
            label = "[ + ]";
          break;
          case 'M' :
            comparisonOp = s1.numOpMinus;
            label = "[ - ]";
          break;
          case 'T' :
            comparisonOp = s1.numOpTimes;
            label = "[ * ]";
          break;
          case 'D' :
            comparisonOp = s1.numOpDivides;
            label = "[ / ]";
          break;
          case 'S' :
            comparisonOp = s1.numBonSquare;
            label = "[ ^ ]";
          break;
          case 'N' :
            comparisonOp = s1.numBonNegative;
            label = "[ -() ]";
          break;
          default :
            //comparisonOp = 0;
          break;
        } // end switch
        
        // switch
        // label = 
        // TO BE CONTINUED
        
        procVals[ 0 ] = comparisonOp;
        procCounts[ 0 ] = 1;
        walker = c + 1;
        //hitMatch = true;
      } // end if hitMatch
    } // end while
  } // end seedProcArrs()  
  
  void populateProcArrs( char opType, Spiral _spiral, boolean _hit ) {
    int comparisonOp = 0;
    for( int i = walker - 1; i < _spiral.spokes.size(); i++ ) {
      Spoke s = ( Spoke ) _spiral.spokes.get( i );
      if( _hit == s.hit ) { // only execute the code below if hitMatch
        switch( opType ) {
          case 'P' :
            comparisonOp = s.numOpPlus;
          break;
          case 'M' :
            comparisonOp = s.numOpMinus;
          break;
          case 'T' :
            comparisonOp = s.numOpTimes;
          break;
          case 'D' :
            comparisonOp = s.numOpDivides;
          break;
          case 'S' :
            comparisonOp = s.numBonSquare;
          break;
          case 'N' :
            comparisonOp = s.numBonNegative;
          break;
          default :
            //comparisonOp = 0;
          break;
        } // end switch
          
        int found = 0;
        int sumfound = 0;
        for( int l = 0; l < procVals.length; l++ ) { // go through procVals array
          if( procVals[ l ] == comparisonOp ) { // check if the value of comparisonOp is already in the procVals array
            found = 1;  
            procCounts[ l ] ++; // increase the count for that value
          } // end if the value of comparisonOp is already in the procVals array
          sumfound += found;
        } // end for l   

        if( sumfound == 0 ) { // the value of comparisonOp is not found within the current procVals array (its a new value)
          procVals = append( procVals, comparisonOp );
          procCounts = append( procCounts, 1 );

        } // end if its a new value
      } // end if hitMatch
    } // end for i
  } // end populateProcArrs()
  
  void populateProcArrs( char opType, Spiral _spiral ) { // OVERLOADED METHOD FOR BOTH HIT & NOHIT FUNCTIONS
    int comparisonOp = 0;
    for( int i = 0; i < _spiral.spokes.size(); i++ ) {
      Spoke s = ( Spoke ) _spiral.spokes.get( i );
      switch( opType ) {
        case 'P' :
          comparisonOp = s.numOpPlus;
        break;
        case 'M' :
          comparisonOp = s.numOpMinus;
        break;
        case 'T' :
          comparisonOp = s.numOpTimes;
        break;
        case 'D' :
          comparisonOp = s.numOpDivides;
        break;
        case 'S' :
          comparisonOp = s.numBonSquare;
        break;
        case 'N' :
          comparisonOp = s.numBonNegative;
        break;
        default :
          //comparisonOp = 0;
        break;
      } // end switch
          
      int found = 0;
      int sumfound = 0;
      for( int l = 0; l < procVals.length; l++ ) { // go through procVals array
        if( procVals[ l ] == comparisonOp ) { // check if the value of comparisonOp is already in the procVals array
          found = 1;  
          procCounts[ l ] ++; // increase the count for that value
        } // end if the value of comparisonOp is already in the procVals array
        sumfound += found;
      } // end for l   

      if( sumfound == 0 ) { // the value of comparisonOp is not found within the current procVals array (its a new value)
        procVals = append( procVals, comparisonOp );
        procCounts = append( procCounts, 1 );
      } // end if its a new value
    } // end for i
  } // end populateProcArrs()
  
  void harvestProcArrs( boolean _hit ) {
    if( _hit ) { // store to Hit araylist
      pointsHit = new ArrayList();
      for( int i = 0; i < procVals.length; i++ )
        pointsHit.add( new DistribPt( procVals[ i ], procCounts[ i ] ) );
    } else { // store to NoHit arraylist
      pointsNoHit = new ArrayList();
      for( int i = 0; i < procVals.length; i++ )
        pointsNoHit.add( new DistribPt( procVals[ i ], procCounts[ i ] ) );      
    } // end else
  } // end harvestProcArrs
  
  void harvestProcArrs() { // OVERLOADED METHOD FOR BOTH HIT & NOHIT (ALL) FUNCTIONS
    pointsAll = new ArrayList();
    for( int i = 0; i < procVals.length; i++ )
      pointsAll.add( new DistribPt( procVals[ i ], procCounts[ i ] ) );
  } // end harvestProcArrs
  
  
  
  void resetProcArrs() {
    procVals = expand( procVals, 1 );
    procVals[ 0 ] = 0;
    procCounts = expand( procCounts, 1 );
    procCounts[ 0 ] = 0;
    walker = 0;
  } // end resetProcArrs()
  
  void sortDistribPoints( ArrayList _points ) {
   // will sort pointsHit, pointsNoHit, pointsAll depending on the passed argument 
   for( int i = 0; i < _points.size(); i++ ) {
     
     for( int j = 0; j < i; j++ ) {
         DistribPt pj = ( DistribPt ) _points.get( j );
         DistribPt pi = ( DistribPt ) _points.get( i );
         if( pj.value > pi.value ) { 
           // swap
           DistribPt pswap = pj;
           
           _points.remove( j );
           _points.add( j, new DistribPt( pi.value, pi.count ) );
           
           _points.remove( i );
           _points.add( i, new DistribPt( pswap.value, pswap.count ) );
             
         } // end if
     } // end for j
   } // end for i
  } // end sortDistrib()
  
  void showArrayPoints(  ) {
    println( "====================================");
    println( "Array of Points for the " + label + " operator : ");
    println( "Values >-< Counts" );
    for( int i = 0; i < procVals.length; i++ ) {
      println( procVals[ i ] + " >-< " + procCounts[ i ] );
   } // end for i
  } // end showArrayPoints()
  
  void showDistribPoints() {
    println( "====================================");
    println( "Distribution Points for the " + label + " operator  (from the ArrayList): ");
    println( "HIT");
    println( "------------" );
    println( "Values >-< Counts" );
    for( int i = 0; i < pointsHit.size(); i++ ) {
      DistribPt p = ( DistribPt ) pointsHit.get( i );
      println( p.value + " >-< " + p.count );
    } // end for i
    println( "------------" );
    println( "NO-HIT");
    println( "------------" );
    println( "Values >-< Counts" );      
    for( int i = 0; i < pointsNoHit.size(); i++ ) {
      DistribPt p = ( DistribPt ) pointsNoHit.get( i );
    println( p.value + " >-< " + p.count );
    } // end for i
    println( "------------" );
    println( "ALL");
    println( "------------" );
    println( "Values >-< Counts" );      
    for( int i = 0; i < pointsAll.size(); i++ ) {
      DistribPt p = ( DistribPt ) pointsAll.get( i );
    println( p.value + " >-< " + p.count );
    } // end for i
    
  } // end showDistribPoitn
  
} // end class OpDistrib
