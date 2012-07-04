import com.myjavatools.web.*;
import java.awt.Button;
import java.awt.TextField;
import java.awt.TextArea;
import java.awt.Label;
import java.awt.Frame;
import java.awt.Color;
import java.awt.event.*;




class PopUpSaveState extends Frame {

  // Fields
  LVActivity owner;
  Wave referredWave;
  Label label1, label2;
  TextField tField;
  Button saveasB, saveB, cancelB;
  TextArea input;
  String oldComments, curComments;
  
  String oldTField, curTField;
  long sid;



  // Constructor
  PopUpSaveState( LVActivity o, Wave rw, String otf, long id, String oc ) {
    super( "Comment & Save  Wave State" );
    owner = o;
    referredWave = rw;
    oldTField = otf;
    curTField = oldTField;
    sid = id;
    oldComments = oc;
    curComments = oldComments;
    
    setSize( 500, 300 );
    setVisible( true );
    setBackground( new Color( 0, 0, 0 ) );
    setLayout( null );
    
    setTitle( "Enter a name to save" );
    
    label1 = new Label( "Enter a name to save:" );
    label1.setForeground( new Color( 255, 255, 0 ) );
    label1.setBounds( 20, 40, 460, 20 );

    tField = new TextField( oldTField );
    tField.setBackground( new Color( 255, 220, 200 ) );
    tField.setBounds( 0, 60, 500, 20 );
    
    label2 = new Label( "Type comments in the box below" );
    label2.setBounds( 20, 100, 460, 20 );
    label2.setForeground( new Color( 255, 255, 0 ) );

    input = new TextArea(  );input = new TextArea( oldComments, 2, 30, 1 );
    input.setBackground( new Color( 255, 220, 200 ) );
    input.setBounds( 0, 120, 500, 90 ); 

    cancelB = new Button( "CANCEL" );
    cancelB.setBackground( new Color( 180, 180, 180 ) );
    cancelB.setBounds( 50, 250, 100, 30 );

    cancelB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        dispose();
      }
    } );

    saveB = new Button( "SAVE" );
    saveB.setBackground( new Color( 180, 180, 180 ) );
    saveB.setBounds( 200, 250, 100, 30 );
    if( referredWave.stateID == -1 )
      saveB.setEnabled( false );

    saveB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        if( tField.getText().equals( "" ) == true ) {
            PopUpDialog messg = new PopUpDialog( "Please type a name to save." );
        } else {
          if( referredWave.stateID != -1 ) { // make sure there's a valid key 
            HashMap  <String, String> dataMap = new HashMap<String, String>();
        
            dataMap.put( "id", new Long( referredWave.stateID ).toString() );
            dataMap.putAll( prepDataForSaving() );  
        
            String rep = webPost( "http://" + hostip + "/updateWaveState", dataMap );
            println( rep );
            if( rep.indexOf( "Success" ) != -1 ) { // careful of upper/lower case
              String[] pieces = splitTokens( rep, "=" );
              println( pieces );
                 
              // update Visualizer
              referredWave.stateName = curTField;
              referredWave.comments = curComments;
            } else {
              println( "FAILED. State NOT updated." );
            }
          }
          dispose();
        } // end if ( referredWave.stateID != -1 )
      }
    } );
    
    saveasB = new Button( "SAVE AS" );
    saveasB.setBackground( new Color( 180, 180, 180 ) );
    saveasB.setBounds( 350, 250, 100, 30 );
      
    saveasB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        if( tField.getText().equals( "" ) == true ) {
            PopUpDialog messg = new PopUpDialog( "Please type a name to save." );
          } else {    
          HashMap<String, String> dataMap = new HashMap<String, String>();
          dataMap = prepDataForSaving();  
        
          String rep = webPost( "http://" + hostip + "/saveWaveState", dataMap );
          println( rep );
          if( rep.indexOf( "Success" ) != -1 ) { // careful of upper/lower case
            String[] pieces = splitTokens( rep, "=" );
            println( pieces );
            String theid = trim( pieces[ pieces.length -1 ] );
            long theID = Long.parseLong( theid );
   
            // update Visualizer
            referredWave.stateName = curTField;
            referredWave.stateID = theID;
            referredWave.comments = curComments;
          }
          dispose();
        }
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

    add( label1 );
    add( tField );
    add( label2 );
    add( input );
    add( cancelB );
    add( saveB );
    add( saveasB );

  } // end constructor()





  // Methods

  String consolidateToString( ArrayList<String> ss ) {
    String ret = "";
    if( ss.isEmpty() == false ) {
      ret = ss.get( 0 );
      for( int i = 1; i < ss.size(); i++ ){
        ret += "|" + ss.get( i );
      }  
    }
    return ret;
  } // end consolidateToString()  




  String consolidateCodesToString( ArrayList<String> sc ) {
    String ret = "";
    if( sc.isEmpty() == false ) {
      ret += prepCode( sc.get( 0 ) );
      for( int i = 1; i < sc.size(); i++ ) {
        ret += "|" + prepCode( sc.get( i ) );
      }
    }
    return ret;
  } // end consolidateWpCodes()




  String prepCode( String citem ) {
    CodeItem tempCI = referredWave.codeCabinet.codeItemsDictionary.get( citem );
    return( referredWave.codeCabinet.codeBook.get( tempCI ).dispName + ":" + citem  );
  } // end prepCode()




  String webPost( String urlString, Map data ) {
    try {
      ClientHttpRequest req = new ClientHttpRequest( urlString );
      req.setParameters( data);
      InputStream serverInput = req.post();
      InputStreamReader serverInputReader = new InputStreamReader( serverInput );
      String inputLine = "";
      BufferedReader br = new BufferedReader( serverInputReader );
      inputLine = br.readLine();
      //println( inputLine );
      serverInput.close();
      return( inputLine );
    }
    catch( IOException ex ) {
       println( ex );
       return( "FAILED - IOException occurred" );
    }
  } // end webPost()




  HashMap<String, String> prepDataForSaving() {
    curTField = tField.getText();
    curComments = input.getText();
    String hostip = referredWave.hostip;
    String selCodes = consolidateCodesToString( referredWave.selCodes );
    String selEqs = consolidateToString( referredWave.selEqs );

   // debug
    println( "selcodes : " + selCodes );
    println( "name : " + curTField );
    println( "sid : " + new Long( sid ).toString() );
    println( "selstring : " + selEqs );
    println( "comments: " + curComments );
    
    // save to database - remember to send comments too
    HashMap pairs = new HashMap<String, String>();
    pairs.put( "selcodes", selCodes );
    pairs.put( "name", curTField );
    pairs.put( "sid", new Long( sid ).toString() );
    pairs.put( "selstring", selEqs );
    pairs.put( "comments", curComments );

    return pairs;
  } // end prepDataForSaving()




} // end class PopUpSaveState
