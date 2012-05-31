// the UI code for MenuActivity. Basically does the "narrowing down of the dropdown options" as the
// user goes through them to specify an activity to see
// see also: class MenuActivity

class MenuUI extends AUI {

  // Fields
  
  String[] aDetails = new String[ 3 ];
  



  // Constructor

  MenuUI( MenuActivity o ) {
    super(); 
    owner = o;
    createSpButton( o.x1Frame + 520, o.y1Frame + 20, o.x1Frame + 600, o.y1Frame + 40, getNextIndexArrSpButtons(), "CLEAR",   color(0), color(180), color(240), color(50) );
    createSpButton( o.x1Frame + 520, o.y1Frame + 50, o.x1Frame + 600, o.y1Frame + 70, getNextIndexArrSpButtons(), "CONNECT", color(0), color(180), color(240), color(50) );
    
    createDropdown( o.x1Frame + 300, o.y1Frame + 20, o.x1Frame + 480, o.y1Frame + 40, getNextIndexArrDropdowns(), "School :" ); // School dropdown
    createDropdown( o.x1Frame + 300, o.y1Frame + 70, o.x1Frame + 480, o.y1Frame + 90, getNextIndexArrDropdowns(), "Teacher :" ); // Teacher dropdown
    createDropdown( o.x1Frame + 300, o.y1Frame + 120, o.x1Frame + 480, o.y1Frame + 140, getNextIndexArrDropdowns(), "Class :" ); // Class dropdown
    createDropdown( o.x1Frame + 300, o.y1Frame + 170, o.x1Frame + 480, o.y1Frame + 190, getNextIndexArrDropdowns(), "Activity :" ); // Activity dropdown
    /*
    createDropdown( o.x1Frame + 300, o.y2Frame - 20, o.x1Frame + 480, o.y2Frame, getNextIndexArrDropdowns(), "Test :" );
    String[] testFeed = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k" };
    Dropdown dt = arrDropdowns.get( 4 );
    dt.buildDDItems( testFeed );
    */
    Dropdown d = arrDropdowns.get( 0 );
    MenuActivity ma = (MenuActivity) owner;
    d.buildDDItems( ma.h.getSchools() );

  } // end constructor 




  // Methods

  @Override
    void display() {
    super.display();
  } // end display()



  
  @Override
    void executeMousePressed() {
    if ( mouseButton == LEFT )
    { 
      // For SpButtons
      int whichOne = getPressedArrSpButton();
      if ( whichOne == 0 ) {
        for( Dropdown d : arrDropdowns ) {
          d.clearSelection();
        }
	Dropdown d = arrDropdowns.get( 0 );
        MenuActivity ma = (MenuActivity) owner;
	d.buildDDItems( ma.h.getSchools() );
      }
      else if ( whichOne == 1 ) {
        String d0sel = arrDropdowns.get( 0 ).getSelectedItem();
        String d1sel = arrDropdowns.get( 1 ).getSelectedItem();
        String d2sel = arrDropdowns.get( 2 ).getSelectedItem();
        String d3sel = arrDropdowns.get( 3 ).getSelectedItem();
       
        if( !d0sel.equals( "" ) && !d1sel.equals( "" ) && !d2sel.equals( "" ) && !d3sel.equals( "" ) ) {
          String addr = buildQueryAddress();
	  String startTime = acquireActivityStartTime();
          String title = buildActivityTitle();
	  //String[] aDetails = new String[ 3 ];
	  aDetails[ 0 ] = addr;
	  aDetails[ 1 ] = startTime;
	  aDetails[ 2 ] = title;
          MenuActivity downcasted = (MenuActivity) owner;
          downcasted.passActivityDetails( aDetails );
        }
      }
      // For Dropdowns
      processClickedDropdown();
      for( int i = 0; i < arrDropdowns.size()-1; i++ ) {

        String prevSel = arrDropdowns.get( i ).getPrevSelectedItem();
        String sel = arrDropdowns.get( i ).getSelectedItem();
        
        if( prevSel == sel ) {

        } else if( !prevSel.equals(sel) && prevSel.equals("") ) { 	       // if moving from no-selection to a selection

            buildDownstreamFrom( i, sel );
          
	} else if(!prevSel.equals(sel) && !sel.equals("") ) {  // if selection changes value but not to blank

          // need to clear downstream dropdowns
          for( int j = i+1; j < 4; j++ ) {

            Dropdown dj = arrDropdowns.get( j );
           dj.clearSelection(); 

          }
          Dropdown dcurrent = arrDropdowns.get( i );
          dcurrent.setSelectedItem( sel );
          dcurrent.setPrevSelectedItem( sel );
          // and then rebuilt just for the dropdown immediately below the current one
          buildDownstreamFrom( i, sel );
          Dropdown di = arrDropdowns.get( i + 1 );
          di.updateSelection();
          
        }	
      } // end for i
    } // end if mouseButton == LEFT
  } // end executeMousePressed()




  String buildQueryAddress() {
    String ret = "";
    String[] pieces = splitTokens( arrDropdowns.get( 2 ).getSelectedItem(), ":" );
    String selSch = arrDropdowns.get( 0 ).getSelectedItem();
    String selTch = arrDropdowns.get( 1 ).getSelectedItem();
    String selCrm = arrDropdowns.get( 2 ).getSelectedItem();
    String selActv = arrDropdowns.get( 3 ).getSelectedItem();
    MenuActivity ma = ( MenuActivity ) owner;
    Long selActvID = ma.h.getGSActivity( selSch, selTch, selCrm, selActv ).getAID();
    
    ret = ( "http://203.116.116.34:80/getAllContributionsAfter" + "?aid=" + selActvID  + "&ind=0" );
    
    return ret;
  } // end buildQueryAddress()
  



  String buildActivityTitle() {
    String schoolName = arrDropdowns.get( 0 ).getSelectedItem();
    String[] pieces = splitTokens( arrDropdowns.get( 2 ).getSelectedItem(), ":" );
    String className = pieces[ 0 ];
    String classYear = pieces[ 1 ];
    String activityTitle = arrDropdowns.get( 3 ).getSelectedItem();
    return( activityTitle + " " + schoolName + " " + className + " " + classYear );
  } // end buildActivityTitle()
  
  

  
  String acquireActivityStartTime() {
    String[] pieces = splitTokens( arrDropdowns.get( 3 ).getSelectedItem(), " " );
    String startTime = pieces[ 1 ].substring( 0, pieces[ 1 ].length() - 2 );
    return startTime;
  } // end acquireActivityStartTime()




  void buildDownstreamFrom( int i, String sel ) {
    MenuActivity ma = (MenuActivity) owner;
    Dropdown d = arrDropdowns.get( i + 1 );
    if( i == 0 ) { 
      d.buildDDItems( ma.h.getTeachers( sel ) );

    } else if( i == 1 ) {

      Dropdown ds = arrDropdowns.get( 0 );
      d.buildDDItems( ma.h.getClassrooms( ds.getSelectedItem(), sel ) );

    } else if( i == 2 ) {

      Dropdown ds = arrDropdowns.get( 0 );
      Dropdown dt = arrDropdowns.get( 1 );

      d.buildDDItems( ma.h.getGSActivities( ds.getSelectedItem(), dt.getSelectedItem(), sel ) );

    }
  } // end buildDownstreamFrom( i )




  @Override
  void executeMouseReleased() {
    super.executeMouseReleased();
  }




  @Override
    void update() {
    super.update();
  }



  @Override
  void executeMouseDragged() {
    // do nothing here
  } // end mouseDragged()
  
  
  
  
} // end class MenuUI

