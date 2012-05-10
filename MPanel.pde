// Class for GenSing Controller
// Has class MButton as a composite class ( see below )

class MPanel {

  // Fields

  MButton[] mButtons;         // array of Memory Buttons
  MButton swapButton;         // one Memory Button object for swapping Memory Buttons
  int mode;                   // to keep track of the mode - 0:Recall, 1:Store, 2:Swap
  boolean swapAIn;            // to keep track of whether or not the first MButton for swapping (A) has been identified   
  int aIndex;                 // index of MButton A to be swapped



  
  // Constructor

  MPanel( int n ) {
    mButtons = new MButton[ n ];             // creates n number of Memory Buttons
    for( int i = 0; i < n; i++ ) {
      mButtons[ i ] = new MButton();          // create an array of MButtons
    } // end for i
    swapButton = new MButton();              // create the swap MButton
    mode = 0;                                // sets default mode to 0:Recall                                // sets the mode according to message from Arduino Controller
  } // end constructor



  
  // Mehods

  void setMode( int m ) {
    mode = m;
  } // end setMode()
  



  void update( int index ) {
    if( mode == 0 ) {
      recall( index );
    } else if( mode == 1 ) {
      store( index );
    } else if( mode == 2 ) {
      if( !swapAIn ) {        // if swap A has not been identified
        swapButton.replicate( mButtons[ index ] );
        swapAIn = true;
        aIndex = index;
      } else {                // if swap A has been identified
        mButtons[ aIndex ].replicate( mButtons[ index ] );
        mButtons[ index ].replicate( swapButton );
        swapAIn = false;
        aIndex = mButtons.length;
      } // end control structure (if) given mode = swap
    } // end if swap = 2
  } // end update()
  



  void recall( int index ) {
    activeDataset = mButtons[ index ].getSectionIndex();
    sections[ activeDataset ].spiral.userRotate = mButtons[ index ].getUserRotateDegree();  
    sections[ activeDataset ].spiral.deltaRotate = mButtons[ index ].getUserRotateDegree(); // to disable "turning effect"
   
  } // end recall()
  



  void store( int index ) {
    mButtons[ index ].setSectionIndex( activeDataset );
    mButtons[ index ].setUserRotateDegree( sections[ activeDataset ].spiral.userRotate );
  } // end store()



} // end class MPanel


//========================================================================================
//========================================================================================
// Class for GenSing Controller - requires class MPanel

class MButton {

  // Fields

  int sectionIndex;          // index number of sections[] that this MButton stores                      
  float userRotateDegree;                // userRotateDegree of rotated Spiral that this MButton stores (this is only for Spiral Visualizer )
  
  // Constructor
  MButton () {
    sectionIndex = 0;
    userRotateDegree = 0; 
  } // end constructor



  
  // Methods

  void replicate( MButton target ) {
    sectionIndex = target.getSectionIndex();
    userRotateDegree = target.getUserRotateDegree();
  } // end replicate()
  



  int getSectionIndex() {
    return sectionIndex; 
  }




  float getUserRotateDegree() {
    return userRotateDegree; 
  }
  



  void setSectionIndex( int s ) {
    sectionIndex = s; 
  }
  



  void setUserRotateDegree( float d ) {
    userRotateDegree = d;
  }




} // end class MButton
