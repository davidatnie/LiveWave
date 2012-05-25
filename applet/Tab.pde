class Tab {

  // Fields

  String name;
  ArrayList stratsList;
  int total;
  float llx, lly, ulx, uly, urx, ury, lrx, lry;         // to hold tab Quad coordinate points
  boolean isActive;
  int startCol;
  int endCol;
  



  // Constructor

  Tab( Table _artefacts, int pos, String tempName, ArrayList tempFuncs, int tempStartCol, int tempEndCol ) {    
    // On Screen location of the tabs
    if( pos == 0 ) {
      llx = 20;
      lly = 27;
      ulx = 30;
      uly = 3;
      urx = 110;
      ury = 3;
      lrx = 120;
      lry = 27;
    } else if( pos == 1 ) {
      llx = 120;
      lly = 27;
      ulx = 130;
      uly = 3;
      urx = 210;
      ury = 3;
      lrx = 220;
      lry = 27;
    } else {
      llx = 220;
      lly = 27;
      ulx = 230;
      uly = 3;
      urx = 310;
      ury = 3;
      lrx = 320;
      lry = 27;
    }
    
    name = tempName;
    startCol = tempStartCol;
    endCol = tempEndCol;
    stratsList = new ArrayList();
    
    initializeStrats( stratsList, startCol, endCol, _artefacts );
    buildStrats( tempFuncs, stratsList, startCol, endCol, _artefacts );
    cleanStrats( stratsList );
    sortStrats( stratsList );
    
    // calculating total number of strats under this tab
    for( int t = 0; t < stratsList.size(); t++ ) {
      Strat tot = ( Strat ) stratsList.get( t );
      total += tot.freq;  
    } // end for t
  } // end constructor
  



  // Methods
  
  void drawTab( int tempTitleSize, int tempDeploymentFontSize ) {
    if( ! isActive ) {
      // draw tab
      stroke( 200 );
      fill( 200 );
      quad( llx, lly, ulx, uly, urx, ury, lrx, lry );
      // draw tab title 
      fill( 0, 160, 255 );
      textSize( tempTitleSize );
      text( name, llx+15, lly-5 );
      
    } else {
      
      // draw tab
      stroke( 255 );
      fill( 255 );
      quad( llx, lly, ulx, uly, urx, ury, lrx, lry );
      rect( 0, lly+1, 348, 298 );
      // draw tab title
      fill( 0 );
      textSize( tempTitleSize );
      text( name, llx+15, lly-5 );
      // draw contents of the active Tab     
      textSize( tempDeploymentFontSize );
       for( int j = 0; j < stratsList.size(); j++ ) {
         Strat dispStrat = ( Strat ) stratsList.get( j );
         fill( 0 );
         text( dispStrat.name, 30, 50 + j * 25 );         // Strategy name
         text( dispStrat.freq, 100, 50 + j * 25 );          // Frequency count for that Strategy
         // Bar chart
         stroke( 0, 90, 185 );
         fill( 0, 90, 185 );
         rectMode( CORNERS );
         rect( 130, 35 + ( j ) * 25, 130 + dispStrat.freq, 35 + j * 25 + 20 );
      } // end for j
      fill( 0 );
      text( "Total ", 55, 50 + stratsList.size() * 25 );    // Total
      text( total, 100, 50 + stratsList.size() * 25 );
    }
  } // end drawTab()



  
  void initializeStrats( ArrayList targetList, int startCol, int endCol, Table _artefacts ) { // To initialize a strategy list. Must pass in starting and ending columns
    for( int c = startCol; c <= endCol; c++ ) {
      if( _artefacts.getString( 1, c ).equals("") != true ) { // if there is valid data in the cell
        targetList.add( new Strat( _artefacts.getString( 1, c ) ) );
      }
    } // end for c
  } // end initializeStrats



  
  void buildStrats( ArrayList sourceList, ArrayList targetList, int startCol, int endCol, Table _artefacts ) {         // To build a strategy list by populating it after the first array element was initialized in initializeStrats()
    // go through each row, read the cell(s) add freq of a strat if its already in the list, or add to stratsList if its not yet in the list
    for( int i = 2; i < sourceList.size()+1; i++ ) {
      int dup = 0;
      int sumDup = 0;
      for( int c = startCol; c <= endCol; c++ ) {
        if( _artefacts.getString( i, c ) != null ) {                   // if the cell has valid data
        String check = _artefacts.getString( i, c );
          for( int t = 0; t < targetList.size(); t++ ) {
            Strat target = ( Strat ) targetList.get( t );
            if( check.equals(target.name) == true ) {
              target.addFreq();
              dup++;
            }
          } // end for t
          sumDup += dup;
        } // end if cell has valid data
        if( sumDup == 0 )
            targetList.add( new Strat( _artefacts.getString( i, c ) ) );
      } // end for c
    } // end for i
    Strat x = (Strat) targetList.get(targetList.size() - 1 );
  } // end buildStrats



  
  void cleanStrats( ArrayList targetList ) {                                           // removes any Strat objects with a blank ( "" ) name
    for( int i = 0; i < targetList.size(); i++ ) {
      Strat check = ( Strat ) targetList.get( i );
      if( check.name.equals( "" ) == true ) {
        targetList.remove( i );
      } // end if
    } // end for i
  } // end cleanStrats



  
  void sortStrats( ArrayList targetList ) {                                                   // sorts Strats in descending order. Greatest freqs at the top 
    int largest;
    for( int i = 0; i < targetList.size()-1; i++ ) {
      Strat current = ( Strat ) targetList.get( i );
      largest = i;
      for( int j = i + 1; j < targetList.size(); j++ ) {
        Strat check = ( Strat ) targetList.get( j );
        Strat test = ( Strat ) targetList.get( largest );
        if( check.freq > test.freq ) {               // gotta swap it if check is greater than current
          largest = j;
        }
      } // end for j
      Strat temp = ( Strat ) targetList.get( largest );
      targetList.remove( largest );
      targetList.add( i, temp );
      Strat swap = ( Strat ) targetList.get( i );
      swap.serialNum = i;
    } // end for i
  } // end sortStrats



  
}// end class Tab
