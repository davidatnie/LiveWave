// used by the Spiral viz. OpsStats stands for Operands Statistics

class OpsStats {
  // Fields
  OpsUsage schOpsUsage;
  ArrayList clsOpsUsage = new ArrayList();
  

  // Constructor
  OpsStats( Section[] _sections ) {
    Section[] tempSections = _sections;
    for( int i = 0; i < tempSections.length; i++ ) {// go through each cls and create its OpDistrib instances for all the different operator types
      clsOpsUsage.add( new OpsUsage() );
      OpsUsage co = ( OpsUsage ) clsOpsUsage.get( i );
      // check to see if tempSections has data
      if( tempSections[ i ].hasData ) {
        co.plusOp = new OpDistrib( 'P', tempSections[ i ].spiral );
        co.minusOp = new OpDistrib( 'M', tempSections[ i ].spiral );
        co.timesOp = new OpDistrib( 'T', tempSections[ i ].spiral );
        co.dividesOp = new OpDistrib( 'D', tempSections[ i ].spiral );
        co.squareOp = new OpDistrib( 'S', tempSections[ i ].spiral );
        co.negativeOp = new OpDistrib( 'N', tempSections[ i ].spiral );
      } else {    // tempSections has no data
        co.plusOp = new OpDistrib( 'P' );
        co.minusOp = new OpDistrib( 'M' );
        co.timesOp = new OpDistrib( 'T' );
        co.dividesOp = new OpDistrib( 'D' );
        co.squareOp = new OpDistrib( 'S' );
        co.negativeOp = new OpDistrib( 'N' );
      } // end if tempSections has no data
            
    } // end for i
    
    // building the schOpsUsage instance object
    schOpsUsage = new OpsUsage();
    // building instances of OpDistrib objects at the School-level should only be done after building for the Class-level
    schOpsUsage.plusOp = buildOpDistribSch( 'P', tempSections );
    schOpsUsage.minusOp = buildOpDistribSch( 'M', tempSections );
    schOpsUsage.timesOp = buildOpDistribSch( 'T', tempSections );
    schOpsUsage.dividesOp = buildOpDistribSch( 'D', tempSections );
    schOpsUsage.squareOp = buildOpDistribSch( 'S', tempSections );
    schOpsUsage.negativeOp = buildOpDistribSch( 'N', tempSections );
   
    //showOpDistribSch( schOpsUsage.negativeOp );
    
    
    
  } // end constructor

  // Methods  
  OpDistrib buildOpDistribSch( char opType, Section[] sections ) {
  
    ArrayList tempPointsHit = new ArrayList();
    ArrayList tempPointsNoHit = new ArrayList();
    ArrayList tempPointsAll = new ArrayList();
    String tempLabel = " ";
    
    // Live Spiral will ignore HIT and NO-HIT routines
    for( int i = 0; i < sections.length; i++ ) { // go through each section, get the appropriate OpDistrib object's pointsHit, pointsNoHit and pointsAll
      OpsUsage co = ( OpsUsage ) clsOpsUsage.get( i );
      switch ( opType ) {
        case 'P' :
          //tempPointsHit = buildSchDistribPt( co.plusOp.pointsHit, tempPointsHit);
          //tempPointsNoHit = buildSchDistribPt( co.plusOp.pointsNoHit, tempPointsNoHit );
          tempPointsAll = buildSchDistribPt( co.plusOp.pointsAll, tempPointsAll );
          tempLabel = "[ + ]";  
        break;   
        case 'M' :
          //tempPointsHit = buildSchDistribPt( co.minusOp.pointsHit, tempPointsHit);
          //tempPointsNoHit = buildSchDistribPt( co.minusOp.pointsNoHit, tempPointsNoHit );
          tempPointsAll = buildSchDistribPt( co.minusOp.pointsAll, tempPointsAll );
          tempLabel = "[ - ]";  
        break;
        case 'T' :      
          //tempPointsHit = buildSchDistribPt( co.timesOp.pointsHit, tempPointsHit);
          //tempPointsNoHit = buildSchDistribPt( co.timesOp.pointsNoHit, tempPointsNoHit );
          tempPointsAll = buildSchDistribPt( co.timesOp.pointsAll, tempPointsAll );
          tempLabel = "[ * ]";  
        break;
        case 'D' :
          //tempPointsHit = buildSchDistribPt( co.dividesOp.pointsHit, tempPointsHit);
          //tempPointsNoHit = buildSchDistribPt( co.dividesOp.pointsNoHit, tempPointsNoHit );
          tempPointsAll = buildSchDistribPt( co.dividesOp.pointsAll, tempPointsAll );
          tempLabel = "[ / ]";  
        break;
        case 'S' :    
          //tempPointsHit = buildSchDistribPt( co.squareOp.pointsHit, tempPointsHit);
          //tempPointsNoHit = buildSchDistribPt( co.squareOp.pointsNoHit, tempPointsNoHit );
          tempPointsAll = buildSchDistribPt( co.squareOp.pointsAll, tempPointsAll );
          tempLabel = "[ ^ ]";  
        break;
        case 'N' :
          //tempPointsHit = buildSchDistribPt( co.negativeOp.pointsHit, tempPointsHit);
          //tempPointsNoHit = buildSchDistribPt( co.negativeOp.pointsNoHit, tempPointsNoHit );
          tempPointsAll = buildSchDistribPt( co.negativeOp.pointsAll, tempPointsAll );
          tempLabel = "[ -() ]";  
        break;
        default :
          tempLabel = " ";
        break;
      } // end switch
    } // end for i
    OpDistrib tempOpSch = new OpDistrib( tempPointsHit, tempPointsNoHit, tempPointsAll, tempLabel );
    /*
    println( "From tempOpSch - Label: " + tempOpSch.label );  
    for( int i = 0; i < tempOpSch.pointsHit.size(); i++ ) {
     DistribPt pt = ( DistribPt ) tempOpSch.pointsHit.get( i );
      println( pt.value +"---"+pt.count ); 
    }
    println(" +++++++++++++ " );
    */
    return tempOpSch;
  } // end buildOpDistribSch

  
  ArrayList buildSchDistribPt( ArrayList _points, ArrayList _pointsSch ) {
    for( int i = 0; i < _points.size(); i++ ) { // go through each element of _points
      int found = 0;
      int sumfound = 0;
      DistribPt pi = ( DistribPt ) _points.get( i );
      for( int j = 0; j < _pointsSch.size(); j++ ) { // go through each element of _pointsSch and look for current match
        DistribPt pj = ( DistribPt ) _pointsSch.get( j );
        if( pi.value == pj.value ) {
          found = 1;
          pj.count += pi.count; // add the count of pi to the count of pj
        
        } // end if found already in the _pointsSch list
      } // end for j
      sumfound += found;
      if( sumfound == 0 ) { // element not found, must add to _pointsSch
        _pointsSch.add( new DistribPt( pi.value, pi.count ) );
      } // end if element not found, adding new element to _pointsSch
    } // end for i
    return _pointsSch; 
  } // end buildSchDistribPt
    
  void showOpDistribSch( OpDistrib _toShow ) { // for Debugging and Double-checking purposes
    println( _toShow.label );
    int total = 0;
    println( "HIT" );
    for( int i = 0; i < _toShow.pointsHit.size(); i++ ) {
      DistribPt pi = ( DistribPt ) _toShow.pointsHit.get( i );
      println( pi.value + " <===> " + pi.count );
      total += pi.count;
    }
    println( "total: " + total );
  
    total = 0;
  
    println( "NO-HIT" );
    for( int i = 0; i < _toShow.pointsNoHit.size(); i++ ) {
      DistribPt pi = ( DistribPt ) _toShow.pointsNoHit.get( i );
      println( pi.value + " <===> " + pi.count );
      total += pi.count;
    }
    println( "total: " + total );
  
    total = 0;
  
    println( "ALL" );
    for( int i = 0; i < _toShow.pointsAll.size(); i++ ) {
      DistribPt pi = ( DistribPt ) _toShow.pointsAll.get( i );
      println( pi.value + " <===> " + pi.count );
      total += pi.count;
    }
    println( "total: " + total );
  } // end showOpDistribSch()
  
} // end class OpsStats