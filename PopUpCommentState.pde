import java.awt.Button;
import java.awt.TextArea;
import java.awt.Label;
import java.awt.Frame;
import java.awt.Color;
import java.awt.event.*;




class PopUpCommentState extends Frame {
  // Fields
  LVActivity owner;
  Wave referredWave;
  Label label;
  TextArea input;
  Button okB, cancelB;

  String oldComments, curComments;
  
  


  // Constructor
  PopUpCommentState( LVActivity o, Wave rw, String oc ) { 
    super( "Attach comments on this session" );
    owner = o;
    referredWave = rw;
    oldComments = oc;
    curComments = oldComments;
    setSize( 500, 300 );
    setBackground( new Color( 0, 0, 0 ) );
    setVisible( true );
    setLayout( null );

    label = new Label( "Type in comments in the box below:" );
    label.setForeground( new Color( 255, 255, 0 ) );
    label.setBounds( 20, 30, 460, 20 );
    
    input = new TextArea( oldComments, 2, 30, 1 );
    input.setBackground( new Color( 255, 220, 200 ) );
    input.setBounds( 0, 50, 500, 90 );

    cancelB = new Button( "CANCEL" );
    cancelB.setBackground( new Color( 180, 180, 180 ) );
    cancelB.setBounds( 200, 200, 100, 30 );

    cancelB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        dispose();
      }
    } );

    okB = new Button( "OK" );
    okB.setBackground( new Color( 180, 180, 180 ) );
    okB.setBounds( 350, 200, 100, 30 );

    okB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        curComments = input.getText();
        if( curComments.equals( oldComments ) == false ) {
          // NOTE: comments will be sent to database only when the session is saved - this may need to change if sendComments is implemented
          // update visualizer
          referredWave.comments = curComments;
        }
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
    add( input );
    add( cancelB );
    add( okB );

  } // end constructor()

  

 


  // Methods




} // end class PopUpCommentState
