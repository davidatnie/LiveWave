class StudentComparator implements Comparator {
 // Fields
 ArrayList<String> eqs;  

  StudentComparator( ArrayList<String> input ) {
    super();
    eqs = new ArrayList<String>();
    eqs = input;
  } // end constructor()
  
  int compare( Object o1, Object o2 ) {
    Student s1 = ( Student ) o1;
    Student s2 = ( Student ) o2;
    if( s1.onShow == true && s2.onShow == false )
      return -1;
    if( s2.onShow == true && s1.onShow == false )
      return +1;
    if( s2.countDisplayedWps() == 0 && s1.countDisplayedWps() > 0 )
      return -1;
    if( s2.countDisplayedWps() > 0 && s1.countDisplayedWps() == 0 )
      return +1;
    if( s1.getEarliestPostTimeForSelEqs( eqs ) < s2.getEarliestPostTimeForSelEqs( eqs ) )
      return -1;
if( s1.getEarliestPostTimeForSelEqs( eqs ) > s2.getEarliestPostTimeForSelEqs( eqs ) )
      return +1;
    return s1.studentID.compareTo( s2.studentID );
  } // end compare()
} // end class StudentComparator
