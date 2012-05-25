// a class in the GUI component. This imitates classic drop-down boxes

class Dropdown {
  
  // Fields
  
  float x1, y1, x2, y2;  // edge to edge coordinats
  float x1b, y1b, x2b, y2b; // dropdown button coordinates
  float x1e, y1e, x2e, y2e; // expanded coordinates
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
    if( x2d - x1d >= 40 || y2d - y1d >= 20 ) {  // minimum size is 40x20
      x1 = x1d;
      y1 = y1d;
      x2 = x2d;
      y2 = y2d;
      x1b = x2 - 20;
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
      ylabel = ( linkIndex + 1 ) * 20;
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
    y2e = y1e + ( ddItems.length * 20 );
  } // end destroyDDItems()




  void buildDDItems( String[] ddi ) {
    ddItems = new String[ ddi.length ];
    for( int i = 0; i < ddi.length; i++ )
      ddItems[ i ] = ddi[ i ];
    x1e = x1;
    y1e = y2;
    x2e = x2;
    y2e = y1e + ( ddi.length * 20 );
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
      // draw dropdown contents
      for( int i = 0; i < ddItems.length; i++ ) {
        // draw highlight
        if( mouseX >= x1e && mouseX <= x2e && mouseY > y1e + ( i * 20 ) && mouseY <= y1e + ((i+1)*20) ) {
          fill( 180, 180, 240 );
          noStroke();
          rectMode( CORNERS );
          rect( x1e, y1e+( i * 20 ), x2e, y1e+((i+1)*20) );
        } 
        // print dropdown items 
        fill( 0 );
        text( ddItems[ i ], x1+ 3, y2 - 3 + ( ( i+1 ) * 20 ) );
      } // end for
    }
  } // end displayExpanded()



  
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
      for( int i = 0; i < ddItems.length; i++ ) {
        if( mouseX >= x1e && mouseX <= x2e && mouseY > y1e + ( i * 20 ) && mouseY <= y1e + ((i+1)*20) ) {
          setPrevSelectedItem( getSelectedItem() );
          setSelectedItem( ddItems[ i ] );
          expanded = false;
        }
      } // end for
  } // end updateSelection()




} // end class Dropdown
