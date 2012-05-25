// a class in the GUI component. This imitates classic drop-down boxes

class Dropdown {
  
  // Fields
  
  float x1, y1, x2, y2;  // edge to edge coordinats
  float x1b, y1b, x2b, y2b; // dropdown button coordinates
  float x1e, y1e, x2e, y2e; // expanded coordinates
  int maxExpandedRows; // maximum number of rows displayed when expanded
  float rowWidth, rowHeight; // width and height (in pixels) of each row
  float stepperWidth; // width of the "stepper", the interface to scroll up & down an expanded list
  int linkIndex;  // unique index for each Dropdown object instance
  String label;
  float xlabel, ylabel;
  color bgColor;  // background color
  color selColor;  // selector color
  color textColor;  // text color
  String[] ddItems;  // dropdown items
  String selItem;  // selected item
  String prevSelItem;  // previous selected Item
  Button ddButton;  // dropdown button
  boolean expanded;  // true if displaying items to user for selection




  // Constructor
  
  Dropdown( float x1d, float y1d, float x2d, float y2d, int index, String lbl ) {
    expanded = false;
    maxExpandedRows = 5;
    rowHeight = 20;
    rowWidth = 40;
    stepperWidth = 20;
    if( x2d - x1d >= rowWidth || y2d - y1d >= rowHeight ) {  // minimum size is 40x20
      x1 = x1d;
      y1 = y1d;
      x2 = x2d;
      y2 = y2d;
      x1b = x2 - rowHeight;
      y1b = y1;
      x2b = x2;
      y2b = y2;
      linkIndex = index;
      label = lbl;
      xlabel = x1 - 10 - textWidth( label );
      ylabel = y2 - 5;
    } else {
      x1 = 0;
      y1 = 0;
      x2 = 0;
      y2 = 0;
      x1b = 0;
      y1b = 0;
      x2b = 0;
      y2b = 0;
      linkIndex = index;
      label = "Dropdown box for [" + lbl + "] is defined too small!";
      xlabel = width * 0.1;
      ylabel = ( linkIndex + 1 ) * rowHeight;
    }
    ddButton = new Button( x1b, y1b, x2b, y2b, 0 );
    bgColor = color( 255, 255, 255 );
    selColor = color( 200, 80, 80 );
    textColor = color( 0, 0, 0 );
    selItem = "";
    prevSelItem = "";
  } // end constructor




  // Methods

  void display() {
    fill( 0 );
    text( label, xlabel, ylabel );
    stroke( 0, 0, 0 );
    fill( bgColor );
    rectMode( CORNERS );
    rect( x1, y1, x2, y2 );
    // print selected item
    fill( 0 );
    if( selItem == "" )
      text( " --- ", x1 + 3, y2 - 3 );
    else
      text( selItem, x1 + 3, y2 - 3 );
    // handle dropdown button
    ddButton.update();
    ddButton.display();
    fill( 0 );
    triangle( ddButton.x1 + 5, ddButton.y1 + 5, ddButton.x1 + ((ddButton.x2-ddButton.x1)/2), ddButton.y2 - 5, ddButton.x2 - 5, ddButton.y1+5 );
  } // end display()



  
  void secondLayerDisplay() {
    if( getExpanded() ) {
      updateExpanded();
      displayExpanded();
    }
  } // end secondLayerDisplay()



  
  void expanded() {
    expanded = true;
  } // end expanded()



  
  boolean getExpanded() {
    return expanded;
  }



  
  String getSelectedItem() {
   return selItem; 
  }



  
  void setSelectedItem( String s ) {
    selItem = s; 
  }



  
  String getPrevSelectedItem() {
   return prevSelItem; 
  }



  
  void setPrevSelectedItem( String s ) {
   prevSelItem = s; 
  }



  
  void destroyDDItems() {
    ddItems = new String[ 0 ];
    x1e = x1;
    y1e = y2;
    x2e = x2;
    y2e = y1e + ( ddItems.length * rowHeight );
  } // end destroyDDItems()




  void buildDDItems( String[] ddi ) {
    ddItems = new String[ ddi.length ];
    for( int i = 0; i < ddi.length; i++ )
      ddItems[ i ] = ddi[ i ];
    x1e = x1;
    y1e = y2;
    x2e = x2;
    if( ddi.length <= maxExpandedRows ) 
      y2e = y1e + ( ddi.length * rowHeight );
    else
      y2e = y1e + ( maxExpandedRows * rowHeight );
  } // end buildDDItems()




  void updateExpanded() {
    if( mouseX <= x1 || mouseX >= x2 || mouseY <= y1 || mouseY >= y2e ) {
      expanded = false;
    }
  } // end updateExpanded()
  


  
  void displayExpanded() {
    if( ddItems != null ) {
      // draw dropdown box
      stroke( 0, 0, 0 );
      fill( bgColor );
      rectMode(CORNERS );
      int numItems = ddItems.length;
      rect( x1e, y1e, x2e, y2e );

      if( numItems <= maxExpandedRows ) {  // draw dropdown contents
        for( int i = 0; i < ddItems.length; i++ ) {
          // draw highlight
          if( mouseX >= x1e && mouseX <= x2e && mouseY > y1e + ( i * rowHeight ) && mouseY <= y1e + ((i+1)*rowHeight) ) {
            fill( 180, 180, 240 );
            noStroke();
            rectMode( CORNERS );
            rect( x1e, y1e+( i * rowHeight ), x2e, y1e+((i+1)*rowHeight) );
          } 
          // print dropdown items 
          fill( 0 );
          text( ddItems[ i ], x1+ 3, y2 - 3 + ( ( i+1 ) * rowHeight ) );
        } // end for
      } else {
        int curIndex = getItemIndex( selItem ); 
        if( curIndex == -1 )
          curIndex = 0;
        int expStartIndex = curIndex;
        if( numItems - 1 - curIndex < maxExpandedRows) // if current sel Index is within the 'last screen' of expanded display
	  expStartIndex = numItems - maxExpandedRows;  // set the beginning of the expanded display to show the 'last screen'
        int expStopIndex = expStartIndex + maxExpandedRows; 
       	for( int i = expStartIndex; i < expStopIndex; i++ ) {
          // draw highlight
	  if( mouseX >= x1e && mouseX <= x2e - stepperWidth && mouseY > y1e + ( (i-expStartIndex) * rowHeight ) && mouseY <= y1e + (i-expStartIndex+1) * rowHeight ) {
	    fill( 180, 180, 240 );
	    noStroke();
	    rectMode( CORNERS );
	    rect( x1e, y1e+( ( i-expStartIndex ) * rowHeight ), x2e-stepperWidth, y1e+((i-expStartIndex+1)*rowHeight) );
	  }
	  // print dropdown items
	  fill( 0 );
	  text( ddItems[ i ], x1+3, y2-3 + ( (i-expStartIndex+1) * rowHeight ) );
        }
        // draw stepper bar
        stroke( 0 );
        fill( 200, 200, 200 );
        rect( x2e - stepperWidth, y1e, x2e, y2e );
        line( x2e - stepperWidth, y1e + ( (y2e-y1e) / 2 ), x2e, y1e + ((y2e-y1e)/2) );
        
        line( x2e-(stepperWidth/2), y1e+20, x2e - 3, y1e + 40 );
        line( x2e-(stepperWidth/2), y1e+20, x2e-stepperWidth + 3, y1e + 40 );
        line( x2e-(stepperWidth/2), y2e-20, x2e - 3, y2e - 40 );
        line( x2e-(stepperWidth/2), y2e-20, x2e-stepperWidth + 3, y2e - 40 );
      } // end else 
    }
  } // end displayExpanded()



  
  int getItemIndex( String sel ) {
  // returns index number of selected item, starts from 0 and not 1
  // if can't find item, or selected item is "", returns -1
  //
    if( sel.equals( "" ) )
      return -1;
    else {
      int ret = 0;
      while( ret < ddItems.length ) {
        if( ddItems[ ret ].equals( sel ) )
	  break;
        ret++;
      }
      if( ret == ddItems.length ) // can't find sel in ddItems
        ret = -1;
      return ret;
    }
  } // end getItemIndex()




  int getItemCount() {
    if( ddItems != null )
      return ddItems.length;
    else
      return 0;
  } // end getItemCount()



  
  String getLabel() {
    return label;
  } // end getLabel()
  



  void clearSelection() {
    selItem = "";
    destroyDDItems();
    prevSelItem = "";
  } // end clearSelection



  
  void updateSelection() { // This would be called only after following a LEFT MOUSECLICK
    if( ddItems != null )
      if( ddItems.length <= maxExpandedRows ) {
        for( int i = 0; i < ddItems.length; i++ ) {
          if( mouseX >= x1e && mouseX <= x2e && mouseY > y1e + ( i * rowHeight ) && mouseY <= y1e + ((i+1)*rowHeight) ) {
            setPrevSelectedItem( getSelectedItem() );
            setSelectedItem( ddItems[ i ] );
            expanded = false;
          }
        } // end for
      } else {
        // scrolling ddItems up and down
	if( mouseX >= x2e-stepperWidth && mouseX <= x2e ) {
          int selIndex = 0;
          if( mouseY >= y1e && mouseY <= y1e+((y2e-y1e)/2) ) { // scroll up
            selIndex = max( getItemIndex( getSelectedItem() ) - maxExpandedRows, 0 );    
	  } else if( mouseY >= y1e+((y2e-y1e)/2) && mouseY <= y2e ) { // scroll up
            selIndex = min( getItemIndex( getSelectedItem() ) + maxExpandedRows, ddItems.length - 1 );
          }
	  setPrevSelectedItem( getSelectedItem() );
          setSelectedItem( ddItems[ selIndex ] );
	  expanded = true;
	  displayExpanded();
          //break();
        }
        int numItems = ddItems.length;
        int curIndex = getItemIndex( selItem ); 
        int expStartIndex = curIndex;
        if( numItems - 1 - curIndex < maxExpandedRows) // if current sel Index is within the 'last screen' of expanded display
	  expStartIndex = numItems - maxExpandedRows;  // set the beginning of the expanded display to show the 'last screen'
        int expStopIndex = expStartIndex + maxExpandedRows; 
       	for( int i = expStartIndex; i < expStopIndex; i++ ) {
	  if( mouseX >= x1e && mouseX <= x2e - stepperWidth && mouseY > y1e + ( (i-expStartIndex) * rowHeight ) && mouseY <= y1e + (i-expStartIndex+1) * rowHeight ) {
	    setPrevSelectedItem( getSelectedItem() );
	    setSelectedItem( ddItems[ i ] );
	    expanded = false;
	  }
      } // end else
    }
  } // end updateSelection()




} // end class Dropdown
