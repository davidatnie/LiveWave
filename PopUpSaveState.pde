import java.awt.Button;
import java.awt.TextField;
import java.awt.Label;
import java.awt.Frame;
import java.awt.Color;
import java.awt.event.*;



class PopUpSaveState extends Frame {

  // Fields
  LVActivity owner;
  Wave referredWave;
  Label label;
  TextField tField;
  Button saveB, cancelB;
  
  String oldTField, curTField;




  // Constructor
  PopUpSaveState( LVActivity o, Wave rw, String otf ) {
    super();
    owner = o;
    referredWave = rw;
    oldTField = otf;
    curTField = oTField;
    
    setSize( 500, 200 );
    setVisible( true );
    setBackground( new Color( 0, 0, 0 ) );
    setLayout( null );
    
    setTitle( "Enter a name to save" );
    
    label = new Label( "Enter a name to save:" );
    label.setForeground( new Color( 255, 255, 0 ) );
    label.setBounds( 20, 20, 460, 20 );

    tField = new TextField( oldTField );
    tField.setBackground( new Color( 255, 220, 200 ) );
    tField.setBounds( 0, 50, 500, 20 );

    cancelB = new Button( "CANCEL" );
    cancelB.setForeground( new Color( 180, 180, 180 ) );
    cancelB.setBounds( 200, 100, 100, 30 );

    cancelB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        dispose();
      }
    } );

    saveB = new Button( "SAVE" );
    saveB.setForeground( new Color( 180, 180, 180 ) );
    saveB.setBounds( 350, 100, 100, 30 );

    saveB.addActionListener( new ActionEListener() {
      public void actionPerformed() {
        curTField = tField.getText();
        String comments = referredWave.comments;
        // save to database - remember to send comments too

        // update Visualizer
        referredWave.stateName = curTField;
        dispose();
      }
    } );


    // Window Controller:    
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

    add( label );
    add( tField );
    add( cancelB );
    add( saveB );

  } // end constructor()

  // Methods


} // end class PopUpSaveState