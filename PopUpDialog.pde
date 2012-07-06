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
    msg = new Label( message );
    msg.setForeground( new Color( 255, 255, 0 ) );
    msg.setBounds( 10, 60, message.length() * 7, 20 )  ;
    
    setSize( msg.getWidth() + 20, msg.getHeight() + 140 );
    setLocationRelativeTo( null );
    setBackground( new Color( 0, 0, 0 ) );  
    setTitle( "Notification" );
    setLayout( null );
    setVisible( true );

    

    okB = new Button( "OK" );
    okB.setBackground( new Color( 180, 180, 180 ) );
    okB.setSize( 100, 30 );
    okB.setBounds( 60, 100, 100, 30 );

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
