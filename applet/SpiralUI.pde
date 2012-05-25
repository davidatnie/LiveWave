// an extension of the AUI class which holds all interaction code for the Live Spiral visualizer
// See also: SpiralActivity.pde

class SpiralUI extends AUI {

  // Fields



  
  // Constructor

  SpiralUI ( SpiralActivity o ) {
    super();
    owner = o;

    createSpButton( o.x2Frame -100, o.y1Frame + 570, o.x2Frame -45, o.y1Frame + 590, getNextIndexArrSpButtons(), "-> PDF",   popUpTxt, popUpBkgrd, butOv, butPress );
    createSpButton( o.x2Frame -100, o.y1Frame + 595, o.x2Frame - 45, o.y1Frame + 615, getNextIndexArrSpButtons(), "Font +", popUpTxt, popUpBkgrd, butOv, butPress );
    createSpButton( o.x2Frame -100, o.y1Frame + 620, o.x2Frame - 45, o.y1Frame + 640, getNextIndexArrSpButtons(), "Font -", popUpTxt, popUpBkgrd, butOv, butPress );

    createSpButton( o.x2Frame -100, o.y1Frame + 665, o.x2Frame - 45, o.y1Frame + 685, getNextIndexArrSpButtons(), "R. CW", popUpTxt, popUpBkgrd, butOv, butPress );
    createSpButton( o.x2Frame -160, o.y1Frame + 665, o.x2Frame - 105, o.y1Frame + 685, getNextIndexArrSpButtons(), "Reset", popUpTxt, popUpBkgrd, butOv, butPress );
    createSpButton( o.x2Frame -220, o.y1Frame + 665, o.x2Frame - 165, o.y1Frame + 685, getNextIndexArrSpButtons(), "R. CCW", popUpTxt, popUpBkgrd, butOv, butPress );

  } // end constructor



  
  // Methods

  @Override
  void update() {
    super.update();
  } // end update()



  
  @Override
  void display() {
    super.display();
  } // end display()



  
  @Override
  void executeMousePressed() {
  // All The Logic For UI Interaction go in here
  
  // First, some temp local variables for helpers
  SpiralActivity downcasted = (SpiralActivity) owner;
  Spiral currentSpiral = downcasted.spiral;
  
  // then, UI routines
  if( mouseButton == LEFT ) {
    int whichOne = getPressedArrSpButton();
    if( whichOne == 0 ) {       // "-> PDF"
      /* Do Nothing - temporary, until solutin for applet is implemented
      owner.owner.savePDF = true;
      */
    }
    else if( whichOne == 1 ) {  // "Font +"
      currentSpiral.spokeFontSize++;
      currentSpiral.spokeFontSize = constrain( currentSpiral.spokeFontSize, 8, 18 );
    }
    else if( whichOne == 2 ) {  // "Font -"
      currentSpiral.spokeFontSize--;
      currentSpiral.spokeFontSize = constrain( currentSpiral.spokeFontSize, 8, 18 );
    }
    else if( whichOne == 3 ) {  // "R. CW"
      currentSpiral.rotateClockWise();
    }
    else if( whichOne == 4 ) {  // "Reset"
      currentSpiral.rotateReset();
    } 
    else if( whichOne == 5 ) {  // "R. CCW"
      currentSpiral.rotateCounterClockWise();
    }
  } // end if mouseButton == LEFT
  
  } // end executeMousePressed()



  
  @Override
  void executeMouseDragged() {
    // First, some temp local variables for helpers
    SpiralActivity downcasted = (SpiralActivity) owner;
    Spiral currentSpiral = downcasted.spiral;

    // then, UI routines
    if( dist( mouseX, mouseY, currentSpiral.x, currentSpiral.y ) < currentSpiral.rad ) {
      currentSpiral.x = mouseX;
      currentSpiral.y = mouseY;
    }
  } // end executeMouseDragged()
  
  
  
  
  @Override
  void executeMouseReleased() {
    super.executeMouseReleased();
  } // end executeMouseReleased()




} // end class SpiralUI
