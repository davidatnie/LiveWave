// ancestor class of the GUI componnet. An Activity acts as the main GUI panel where stuff are
// pasted / registered on it. One of its members is an object of class AUI, which is where all
// the UI-related code are stored ( e.g. what happens when "button A" is clicked )
// See also: class AUI

abstract class Activity {

  // Fields

  Tester owner;
  float x1Frame, x2Frame, y1Frame, y2Frame;
  color bgColor;
  AUI aUI;
  PImage maskView;
  PImage maskBkground;




  // Constructor

  Activity( Tester o, int x1f, int y1f, int x2f, int y2f ) {
    owner = o;
    x1Frame = x1f;
    y1Frame = y1f;
    x2Frame = x2f;
    y2Frame = y2f;
    bgColor = color( 125, 125, 125 ); // default background color
  } // end Constructor




  // Methods

  void display() {
    //drawBackground();
    //applyMaskBkground();
    makeMasks();
    render();
    applyMasks();
    aUI.update();
    aUI.display();
  } // end display()
  



  abstract void render();
  // This is where the main drawing routines should be specified by the child classes

    
  
  
  
  void makeMasks() {
    makeMaskBkground();
    makeMaskView();
  } // end makeMasks()
  
  
  
  
  void applyMasks() {
    applyMaskView();
    applyMaskBkground();  
  } // end applyMasks()
  
  


  void drawFrameBkground() {
    stroke( 0 );
    fill( bgColor );
    rectMode( CORNERS );
    rect( x1Frame, y1Frame, x2Frame, y2Frame );
    /*
    PImage tempFrame = get( (int)x1Frame, (int)y1Frame, (int)( x2Frame - x1Frame ), (int)( y2Frame - y1Frame ) );
    
    // prepare cutout area
    float[] viewCoords = new float[ 4 ];
    viewCoords = aUI.getViewCoords();      // remember this should be absolute coordinates, start from the application window's 0,0
    int[] cutout = new int[ int( ( x2Frame - x1Frame ) * ( y2Frame - y1Frame ) ) ];
     // fill in non-transparent pixels
    for( int k = 0; k < cutout.length; k++ )
      cutout[ k ] = 0;
      
    
    // fill in transparent pixels
    for( int i = (int)(viewCoords[ 1 ] - y1Frame); i <  (int)((y2Frame - y1Frame) - (y2Frame - viewCoords[ 3 ]) ); i++ )
      for( int j = (int)(viewCoords[ 0 ] - x1Frame); j < (int)( (x2Frame - x1Frame) - (x2Frame - viewCoords[ 2 ]) ); j++ )
        cutout[ ( (int) (x2Frame - x1Frame) ) * i + j ] = 255;  
    // superimpose cutout area onto image to get the mask
    tempFrame.mask( cutout );
    image( tempFrame, x1Frame, y1Frame);
    */
} // end drawFrameBackground()
 



  void makeMaskView() {
    drawFrameBkground();
    if( aUI.view != null ) { // only need to make mask if aUI has a view object
      // get image of the Activity frame
      maskView = get( ( int )x1Frame, ( int )y1Frame, ( int )(x2Frame - x1Frame), ( int )(y2Frame - y1Frame) );

      // prepare cutout area
      float[] viewCoords = new float[ 4 ];
      viewCoords = aUI.getViewCoords();      // remember this should be absolute coordinates, start from the application window's 0,0
      int[] cutout = new int[ int( ( x2Frame - x1Frame ) * ( y2Frame - y1Frame ) ) ];

      // fill in non-transparent pixels
      for( int k = 0; k < cutout.length; k++ )
        cutout[ k ] = 255;
      
      // fill in transparent pixels
      for( int i = (int)(viewCoords[ 1 ] - y1Frame); i <  (int)((y2Frame - y1Frame) - (y2Frame - viewCoords[ 3 ] ) ) + 1; i++ )
        for( int j = (int)(viewCoords[ 0 ] - x1Frame); j < (int)( (x2Frame - x1Frame) - (x2Frame - viewCoords[ 2 ] ) ) + 1; j++ )
	  cutout[ ( (int) (x2Frame - x1Frame) ) * i + j ] = 0;  
      // superimpose cutout area onto image to get the mask
      maskView.mask( cutout );
    }
  } // end makeMaskView()

  

  void makeMaskBkground() {
    if( x2Frame - x1Frame < width || y2Frame - y1Frame < height ) { // only make backgrop mask if activity's dimensions are smaller than application's window dimension
      // get image of the whole window
      maskBkground = get();

      // prepare cutout area
      int[] cutout = new int[ width * height ];

      // fill in non-transparent pixels
      for( int k = 0; k < cutout.length; k++ ) 
        cutout[ k ] = 255;
     
      // fill in transparent pixels
      for( int i = (int)y1Frame; i < (int)y2Frame + 1; i++ )
        for( int j = (int)x1Frame; j < (int)x2Frame + 1; j++ )
 	  cutout[ ( width * i ) + j ] = 0;
      // superimpose cutout onto image to get the mask
      maskBkground.mask( cutout );
    }
  } // end makeMaskBkground()



  void applyMaskView() {
    if( aUI.view != null ) {
      if( maskView == null ) {
        makeMaskView();
      }
      if( maskView != null ) {
        image( maskView, x1Frame, y1Frame );
      }
    }
  } // end applyMaskView()



  void applyMaskBkground() {
    if( maskBkground == null )
      makeMaskBkground();
    if( maskBkground != null )
      image( maskBkground, 0, 0 );
  } // end applyMaskBkground()




  abstract String toString();




} // end class Activity
