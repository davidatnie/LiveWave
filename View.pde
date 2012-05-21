// a class in the GUI component

class View {
  
  // Fields

  float x1, y1, x2, y2;              // edge to edge coordinate ( including scroll bars )
  float x1a, y1a, x2a, y2a;          // viewing area edge coordinates ( excluding scroll bars )
  float x1sbv, y1sbv, x2sbv, y2sbv;  // scroll bar Vertical - coordinates
  float x1sbh, y1sbh, x2sbh, y2sbh;  // scroll bar Horizontal - coordinates
  float viewWidth, viewHeight;       
  float xScrollPos1, yScrollPos1, xScrollPos2, yScrollPos2;      // scroller position for determining rendering offsets
  int viewTextSize;
  PFont viewFont;
  PImage img;
  float contentHeight, contentWidth;
  color bgColor;
  Button sbUp, sbDown, sbLeft, sbRight; // the four scrollbar buttons
  ScrollPosButton sbVer, sbHor;         // the two draggable scrollbars
  float step;  
  float xOffsetRender, yOffsetRender;
  boolean scrollableVer, scrollableHor;




  // Constructor

  View( float x1v, float y1v, float x2v, float y2v ) {
    if( x2v - x1v >= 40 || y2v - y1v >= 40 ) {   // minimum size for a View object is 40x40
      x1 = x1v;
      y1 = y1v;
      x2 = x2v;
      y2 = y2v;
      x1a = x1;
      y1a = y1;
      x2a = x2 - 20;
      y2a = y2 - 20;
      x1sbv = x2a;
      y1sbv = y1a;
      x2sbv = x2;
      y2sbv = y2a;
      x1sbh = x1a;
      y1sbh = y2a;
      x2sbh = x2a;
      y2sbh = y2;
    } else {
      x1 = 0;
      y1 = 0;
      x2 = 0;
      y2 = 0;
      x1a = 0;
      y1a = 0;
      x2a = 0;
      y2a = 0;
      x1sbv = 0;
      y1sbv = 0;
      x2sbv = 0;
      y2sbv = 0;
      x1sbh = 0;
      y1sbh = 0;
      x2sbh = 0;
      y2sbh = 0;
    }
    
    viewWidth = x2a - x1a;
    viewHeight = y2a - y1a;
    
    xScrollPos1 = 0;
    yScrollPos1 = 0;
    xScrollPos2 = xScrollPos1 + ( x2a - x1a );
    yScrollPos2 = yScrollPos1 + ( y2a - y1a );
    
    sbUp    = new Button(       x2a,       y1,      x2, y1 + 20, 0 );
    sbDown  = new Button(       x2a, y2a - 20,      x2,     y2a, 1 );
    sbLeft  = new Button(       x1,       y2a, x1 + 20,      y2, 2 );
    sbRight = new Button( x2a - 20,       y2a,     x2a,      y2, 3 );
    
    sbVer = new ScrollPosButton( this, x2a, y1a + 20, x2, y2a - 20, 4, "VERTICAL" );
    sbHor = new ScrollPosButton( this, x1a + 20, y2a, x2a - 20, y2, 5, "HORIZONTAL");
    step = 30;
    scrollableVer = determineScrollable( sbVer );
    scrollableHor = determineScrollable( sbHor );
    
    img = null;
    
    contentHeight = 0;
    contentWidth = 0;

    bgColor = color( 255, 255, 255 ); // setting white as the default color

    updateOffsetRenders();
    
  } // end constructor  




  // Methods

  float getX1() {
    return x1;
  }




  float getY1() {
    return y1;
  }




  float getX2() {
    return x2;
  }




  float getY2() {
    return y2;
  }
  
  
  
  
  float getX1A() {
   return x1a; 
  }

  
  
  
  float getY1A() {
   return y1a; 
  }
  

  
  
  float getX2A() {
   return x2a; 
  }
  



  float getY2A() {
   return y2a; 
  }
  



  float getXScrollPos1() {
   return xScrollPos1; 
  }
  

  
  
  float getYScrollPos1() {
   return yScrollPos1; 
  }
  

  
  
  float getXScrollPos2() {
   return xScrollPos2; 
  }
  

  
  
  float getYScrollPos2() {
   return yScrollPos2; 
  }
  
  
  
  
  void updateContentDimension( float xCheck, float yCheck ) {
    if( contentWidth < xCheck ) {
      contentWidth = xCheck;
      sbHor.reposition( getScrollPos() ); 
    }
    if( contentHeight < yCheck ) {
      contentHeight = yCheck;
      sbVer.reposition( getScrollPos() );
    }
  } // end updateContentDimension()




  float calcX( float val ) {
    return xOffsetRender + val;
  }




  float calcY( float val ) {
    return yOffsetRender + val;
  } // end calcY()
  
  
  
  void clearBackground() {
    fill( bgColor );
    rectMode( CORNERS );
    rect( x1, y1, x2, y2 );
    noFill();
  } // end clearBackground()




  void putRect( float tx1, float ty1, float tx2, float ty2 ) {
    rectMode( CORNERS );
    
    updateContentDimension( tx1, ty1 );
    updateContentDimension( tx2, ty2 );
    
    rect( calcX( tx1 ), calcY( ty1 ), calcX( tx2 ), calcY( ty2 ) );
  }



  
  void putImage() {
  // this version of putImage() puts an image at a fixed position, starting from 0,0
  // there's no need to updateContentDimension, that's done when the image was set
  // typically used for displaying background image
    if( img != null )
      image( img, calcX( 0 ), calcY( 0 ) ); 
  } // end putImage()
  
  
  
  
  void putImage( float tx, float ty ) {
  // this version of putImage may put the image at arbitrary position, so need to upate content dimension
  // typically used with small images for animation purposes
    if( img != null ) {
      updateContentDimension( tx, ty );
      image( img, calcX( tx ), calcY( ty ) ); 
    }
  } // end putImage()
  
  


  void putLine( float tx1, float ty1, float tx2, float ty2 ) {
    updateContentDimension( tx1, ty1 );
    updateContentDimension( tx2, ty2 );    
    line( calcX( tx1 ), calcY( ty1 ), calcX( tx2 ), calcY( ty2 ) );
  } // end putLine()




  void putEllipse( float tx, float ty, float txdiam, float tydiam  ) {
    ellipseMode( CENTER );    
    updateContentDimension( tx + 0.5 * txdiam, ty + 0.5 * tydiam );
    ellipse( calcX( tx ), calcY( ty ), txdiam, tydiam );
  } // end putEllipse()




  void putText( String s, float tx, float ty ) {
    textFont( viewFont, viewTextSize );
    updateContentDimension( tx, ty - viewTextSize );
    updateContentDimension( tx + textWidth( s ), ty + ( viewTextSize / 2 ) );
    text( s, calcX( tx ), calcY( ty ) );
  } // end putText()




  void setImage( PImage pimg ) {
    img = pimg;
    setContentHeight( pimg.height );
    setContentWidth( pimg.width );
  } // end setImage()
  

  
  
  void setContentHeight( int h ) {
    contentHeight = float( h );
  } // end setContentHeight()
  

  
  
  void setContentHeight( float h ) {
    contentHeight = h;
  } // end setContentHeight()
  

  
  
  void setContentWidth( int w ) {
    contentWidth = float( w );
  } // end setContentWidth()
  

  
  
  void setContentWidth( float w ) {
    contentWidth = w;
  } // end setContentWidth()



  
  void putTextFont( PFont f ) {
    viewFont = f;
    textFont( f );
  } // end putTextfont()




  void putTextFont( PFont f, int size ) {
    viewFont = f;
    viewTextSize = size;
    textFont( f, size );
  } // end putTextFont()




  void putTextSize( int size ) {
    viewTextSize = size;
    textSize( size );
  } // end putTextSize()




  void putBgColor( color c ) {
    bgColor = c;
  } // end putBgColor()




  float calculateXOffsetRender() {
    return ( x1a - xScrollPos1 );
  }




  float calculateYOffsetRender() {
    return ( y1a - yScrollPos1 );
  } 




  void updateOffsetRenders() {
    xOffsetRender = calculateXOffsetRender();
    yOffsetRender = calculateYOffsetRender();
  } // end updateOffsets()




  void display() {
    stroke( 0 );
    noFill();
    rectMode( CORNERS );
    rect( x1, y1, x2, y2 );
    drawDebugInfo();
    fill( 60, 60, 60 );
    rect( x1sbv, y1sbv, x2sbv, y2sbv );
    rect( x1sbh, y1sbh, x2sbh, y2sbh );
    rect( x1sbv,y1sbh, x2sbv,y2sbh );
    
    sbUp.update();
    sbDown.update();
    sbLeft.update();
    sbRight.update();
    sbVer.update();
    sbHor.update();
    
    sbUp.display();
    sbDown.display();
    sbLeft.display();
    sbRight.display();
    sbVer.display();
    sbHor.display();
    
    stroke( 0 );
    fill( 0 );
    triangle( sbUp.x1 + 5, sbUp.y2 - 5, sbUp.x1 + 10, sbUp.y1 + 5, sbUp.x2 - 5, sbUp.y2 - 5 );
    triangle( sbDown.x1 + 5, sbDown.y1 + 5, sbDown.x1 + 10, sbDown.y2 - 5, sbDown.x2 - 5, sbDown.y1 + 5 );
    triangle( sbLeft.x2 - 5, sbLeft.y2 - 5, sbLeft.x1 + 5, sbLeft.y1 +10, sbLeft.x2 - 5, sbLeft.y1 + 5 );
    triangle( sbRight.x1 + 5, sbRight.y2 - 5, sbRight.x2 - 5, sbRight.y1 + 10, sbRight.x1 + 5, sbRight.y1 + 5 );


  } // end display()
  
  
  
  
  void drawDebugInfo() {
    fill( 128 );
    textSize( 10 );
    text( "view Width x view Height: " + ( x2a-x1a ) + " " + (y2a-y1a), x1, y1 + 10 );
    text( "contentWidth x contentHeight: " + contentWidth + " " + contentHeight, x1, y1 + 20 );
    text( "sbHor.x1 sbHor.x2: " + sbHor.x1 + " " + sbHor.x2, x1, y1 + 30 );
    text( "sbVer.y1 sbVer.y2: " + sbVer.y1 + " " + sbVer.y2, x1, y1 + 40 );
    text( "xScrollPos2, yScrollPos2: " + xScrollPos2 + " " + yScrollPos2, x1, y1 + 50 );

  } // end drawDebugInfo()
  
  
  
  void releaseAllButtons() {
    sbUp.release();
    sbDown.release();
    sbLeft.release();
    sbRight.release();
    sbVer.release();
    sbHor.release();
  } // end release All Buttons()
 



  void repositionScrollPosBtns() {
  // calculates new position for the two scrollPosBtns, call this method after every change
  // in the xScrollPoses or yScrollPoses
    sbVer.y1 = map( yScrollPos1, 0, contentHeight, y1+20, y2a - 20 );
    if( yScrollPos2 < contentHeight )
      sbVer.y2 = map( yScrollPos2, 0, contentHeight, y1+20, y2a - 20 );
    else
      sbVer.y2 = y2a - 20;
    sbHor.x1 = map( xScrollPos1, 0, contentWidth, x1a + 20, x2a - 20 );
    if( xScrollPos2 < contentWidth )
      sbHor.x2 = map( xScrollPos2, 0, contentWidth, x1a + 20, x2a - 20 );
    else
      sbHor.x2 = x2a - 20;
    updateScrollables();
  } // end repositionScrollPosBtns()
  
  
  
  
  void updateScrollables() {
    scrollableVer = determineScrollable( sbVer );
    scrollableHor = determineScrollable( sbHor );
  } // end updateScrollables()
  
  
  
  
  boolean determineScrollable( ScrollPosButton scpos ) {
    boolean ret = true;
    if( scpos.equals( sbVer ) )
      if( scpos.y1 == y1+20 && scpos.y2 == y2a-20 ) // can't scroll if scrollposbutton occupies the whole scrollbar
        ret = false;
    else if( scpos.equals( sbHor ) )
      if( scpos.x1 == x1a+20 && scpos.x2 == x2a-20 )
        ret = false;
    return ret;
  } // end determineScrollable()




  void stepUp() {
    int yScrollPosInSteps = ceil( yScrollPos1 / step );
    yScrollPosInSteps--;
    if( yScrollPosInSteps < 0 )
      yScrollPosInSteps = 0;
    yScrollPos1 = yScrollPosInSteps * step;
    yScrollPos2 = yScrollPos1 + viewHeight;
    sbVer.reposition( getScrollPos() );
  } // end stepUp()




  void stepDown() {
    int yScrollPosInSteps = ceil( yScrollPos2 / step ); 
    yScrollPosInSteps++;
    if( yScrollPosInSteps > ceil( contentHeight / step ) )
      yScrollPosInSteps = ceil( contentHeight / step );
    yScrollPos2 = yScrollPosInSteps * step;
    if( yScrollPos2 > contentHeight )
      yScrollPos2 = contentHeight;
    yScrollPos1 = yScrollPos2 - viewHeight;
    sbVer.reposition( getScrollPos() );
  } // end stepDown()




  void stepLeft() {
    int xScrollPosInSteps = ceil( xScrollPos1 / step );
    xScrollPosInSteps--;
    if( xScrollPosInSteps < 0 )
      xScrollPosInSteps = 0;
    xScrollPos1 = xScrollPosInSteps * step;
    xScrollPos2 = xScrollPos1 + viewWidth;
    sbHor.reposition( getScrollPos() );
  } // end stepLeft()



  
  void stepRight() {
    int xScrollPosInSteps = floor( xScrollPos2 / step ); 
    xScrollPosInSteps++;
    if( xScrollPosInSteps > ceil( contentWidth / step ) )
      xScrollPosInSteps = ceil( contentWidth / step );
    xScrollPos2 = xScrollPosInSteps * step;
    if( xScrollPos2 > contentWidth )
      xScrollPos2 = contentWidth;
    xScrollPos1 = xScrollPos2 - viewWidth;  
    sbHor.reposition( getScrollPos() );
  } // end stepRight()




  float[] getScrollPos() {
    float[] sp = new float[ 4 ];
    sp[ 0 ] = getXScrollPos1();
    sp[ 1 ] = getYScrollPos1();
    sp[ 2 ] = getXScrollPos2();
    sp[ 3 ] = getYScrollPos2();
    return sp;
  } // end getScrollPos();




  void reposition() {
    sbVer.reposition( getScrollPos() );
    sbHor.reposition( getScrollPos() );
  } // end reposition()




  void updateDrag() {
    if( sbVer.over && scrollableVer )
        sbVer.onDrag = true;
    else if( sbHor.over && scrollableHor )
      sbHor.onDrag = true;
      
    if( sbVer.onDrag ) {
      float mouseYAnchor = pmouseY;
      float yGap = mouseY - mouseYAnchor;
      yScrollPos1 = map( sbVer.y1 + yGap, y1+20, y2a - 20, 0, contentHeight );
      yScrollPos1 = constrain( yScrollPos1, 0, contentHeight - viewHeight );
      yScrollPos2 = yScrollPos1 + viewHeight;
      reposition();
    } 

    if( sbHor.onDrag ) {
      float mouseXAnchor = pmouseX;
      float xGap = mouseX - mouseXAnchor;
      xScrollPos1 = map( sbHor.x1 + xGap, x1a + 20, x2a - 20, 0, contentWidth );
      xScrollPos1 = constrain( xScrollPos1, 0, contentWidth - viewWidth );
      xScrollPos2 = xScrollPos1 + viewWidth;
      reposition();
    } 

  } // end updateDrag()
  
  
  
  
} // end class View
