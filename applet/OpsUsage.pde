// used by the Spiral viz. OpsUsage stands for Operands Usage

class OpsUsage {
  // Fields
  OpDistrib plusOp, minusOp, timesOp, dividesOp, squareOp, negativeOp;
  
  // Constructors
  
  // Methods
  String toString() {
    String ret = "";
    ret += "showing details of OpsUsage object instance:\n";
    ret += "============================================\n"; 
    
    ret += "\tplusOp:\n";
    ret += "\t\tpointsAll:\n";
    for( int i = 0; i < plusOp.pointsAll.size(); i++ ) {
      DistribPt dp = ( DistribPt ) plusOp.pointsAll.get( i );
      ret += "\t\t\t" + dp.toString() + "\n";
    }
    ret += "\n";

    ret += "\tminusOp:\n";
    ret += "\t\tpointsAll:\n";
    for( int i = 0; i < minusOp.pointsAll.size(); i++ ) {
      DistribPt dp = ( DistribPt ) minusOp.pointsAll.get( i );
      ret += "\t\t\t" + dp.toString() + "\n";
    }
    ret += "\n";

    ret += "\ttimesOp:\n";
    ret += "\t\tpointsAll:\n";
    for( int i = 0; i < timesOp.pointsAll.size(); i++ ) {
      DistribPt dp = ( DistribPt ) timesOp.pointsAll.get( i );
      ret += "\t\t\t" + dp.toString() + "\n";
    }
    ret += "\n";

    ret += "\tdividesOp:\n";
    ret += "\t\tpointsAll:\n";
    for( int i = 0; i < dividesOp.pointsAll.size(); i++ ) {
      DistribPt dp = ( DistribPt ) dividesOp.pointsAll.get( i );
      ret += "\t\t\t" + dp.toString() + "\n";
    }
    ret += "\n";

    ret += "\tsquareOp:\n";
    ret += "\t\tpointsAll:\n";
    for( int i = 0; i < squareOp.pointsAll.size(); i++ ) {
      DistribPt dp = ( DistribPt ) squareOp.pointsAll.get( i );
      ret += "\t\t\t" + dp.toString() + "\n";
    }
    ret += "\n";

    ret += "\tnegativeOp:\n";
    ret += "\t\tpointsAll:\n";
    for( int i = 0; i < negativeOp.pointsAll.size(); i++ ) {
      DistribPt dp = ( DistribPt ) negativeOp.pointsAll.get( i );
      ret += "\t\t\t" + dp.toString() + "\n";
    }
    ret += "\n";

    return ret;
  } // end toString()
} // end class OpsUsage
