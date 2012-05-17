// a class displaying GUI menu on the Live vizes. Users selects school, teacher, class and activity
// and then choose which viz he'd like to see.
// see also: class MenuUI

class MenuActivity extends Activity {
  
// Fields

  MenuUI mUI;
  Table allActvs;
  Header h;



  // Constructor

  MenuActivity( LiveViz o ) {
    super( o, 250, height/3, width-250, height*2/3 );    
    h = new Header( "http://203.116.116.34:80/getAllActivities" );
    mUI = new MenuUI( this );
    aUI = mUI;
  } // end constructor


  
  
  // Methods 

  void display() {
    super.display();
  } // end display()



  
  void passActivityDetails( String[] aDetails ) {
    owner.initSpiral( aDetails );
    owner.initWave( aDetails );
  } // end passActivityDetails()




  String toString() {
    return ( "This is Menu Activity" ); 
  }



  
  void render() {
    // there's nothing to render in MenuActivity
  } // end render()
  
  
  
  
} // end class MenuActivity
