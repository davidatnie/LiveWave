import java.awt.Button;
import java.awt.TextArea;
import java.awt.Label;
import java.awt.Frame;
import java.awt.Panel;
import java.awt.Color;
import java.awt.event.*;





class PopUpInput extends Frame{
  // Fields
  LVActivity owner;
  WavePt referredPt;
  TextArea input;
  Label captionL;
  String title, caption,  contents;
  Button okB, cancelB, clearB;




  //Methods

  PopUpInput( LVActivity o, WavePt ref, String t, String c, String cont ) {
    super( t );
    owner = o;
    referredPt = ref;
    title = t;
    caption = c;
    contents = cont;
    float popUpWidth = 500;
    float popUpHeight = 200;
    setSize( int( popUpWidth ), int( popUpHeight ) );
    setLocation( int( mouseX-popUpWidth ), mouseY );
    setBackground( new Color( 0, 0, 0 ) );
    setVisible( true );
    
    captionL = new Label( caption );
    captionL.setForeground( new Color( 255, 255, 0 ) );
    captionL.setSize( 500, 20 );
    captionL.setLocation( 0, 30 );
    
    input = new TextArea( "", 2, 30, 1 );
    input.setBackground( new Color( 255, 220, 200 ) );
    input.setText( contents );
    input.setLocation( 0, 50 );
    input.setSize( 500, 90 );
       
    clearB = new Button( "CLEAR" );
    clearB.setBackground( new Color( 180, 180, 180 ) );
    clearB.setLocation( 50, 150 );
    clearB.setSize( 100, 30 );
    
    cancelB = new Button( "CANCEL" );
    cancelB.setBackground( new Color( 180, 180, 180 ) );
    cancelB.setLocation( 200, 150 );
    cancelB.setSize( 100, 30 );
    
    okB = new Button( "OK" );
    okB.setBackground( new Color( 180, 180, 180 ) );
    okB.setLocation( 350, 150 );
    okB.setSize( 100, 30 );
    
    clearB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        contents = "";
	input.setText( contents );
      }
    }
    );
    
    cancelB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        dispose();
      }
    }
    );
    
    okB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        referredPt.annotation = input.getText();
	dispose();
      } // end actionPerformed()
    } // end inner class
    ); // end input.addActionListener()
    
    setLayout( null );
    add( captionL );
    add( input );
    add( clearB );
    add( cancelB );
    add( okB );
    
    addWindowListener( new WindowListener() {
    // NOTE: the following windowListener methods must be ALL be implemented
    // or it simply won't run
    //
      public void windowClosing( WindowEvent e ) {
        dispose();  
      }
      
      public void windowIconified( WindowEvent e ) {
        dispose(); 
      }
      
      public void windowActivated( WindowEvent e ) {
         
      }
      
      public void windowDeiconified( WindowEvent e ) {
        setSize( 500, 200 );
      }
      
      public void windowClosed( WindowEvent e ) {
        
      }
      
      public void windowDeactivated( WindowEvent e ) {
        
      }
      
      public void windowOpened( WindowEvent e ) {
        
      }
    }
    );
    
    
  } // end constructor

} // end class PopUpInput
