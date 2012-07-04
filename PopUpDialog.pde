import java.awt.Button;
import java.awt.Label;
import java.awt.Frame;
import java.awt.Color;
import java.awt.event.*;

class PopUpDialog extends Frame{
  // Fields
  Label msg;
  Button okB;

  // Constructor
  PopUpDialog( String message ) {
    setSize( 200, 200 );
    setBackground( new Color( 0, 0, 0 ) );  
    setTitle( "Notification" );
    setLayout( null );
    setVisible( true );

    msg = new Label( message );
    msg.setForeground( new Color( 255, 255, 0 ) );
    msg.setBounds( 10, 100, 180, 20 );

    okB = new Button( "OK" );
    okB.setBackground( new Color( 180, 180, 180 ) );
    okB.setBounds( 50, 150, 100, 30 );

    okB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        dispose();
      }
    } );

    add( msg );
    add( okB );
    
  } // end constructor  

  // Methods


} // end class Frame
