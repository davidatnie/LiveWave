import java.awt.Button;
import java.awt.Label;
import java.awt.List;
import java.awt.Frame;
import java.awt.Color;
import java.awt.event.*;



class PopUpLoadState extends Frame {

  // Fields

  ArrayList<String> savedStates;
  ArrayList<Long> savedStateIDs;
  HashMap<String, Long> savedStatesDictionary;
  LVActivity owner;
  Wave referredWave;
  Label label;
  Button cancelB, loadB;
  List list;
  


  // Constructor

  PopUpLoadState( LVActivity o, Wave rw  ) {
    super( "Load A Saved State" );
    owner = o;
    referredWave = rw;
    savedStates = new ArrayList<String>();
    savedStateIDs = new ArrayList<Long>();
    savedStatesDictionary = new HashMap<String, Long>();
    buildSavedStates();
    
    setBackground( new Color( 0, 0, 0 ) );
    setLayout( null );
    setSize( 500, 500 );
    setVisible( true );

    label = new Label( "Select a state to load: " );
    label.setForeground( new Color( 255, 255, 0 ) );
    label.setBounds( 20, 50, 460, 20 );

    list = new List();
    list.add( "ONE" );
    list.add( "TWO" );
    list.add( "THREE" );
    list.add( "FOUR" );
    list.add( "FIVE" );
    for( String s : savedStates )
      list.add( s );
    list.setBounds( 50, 80, 400, 200 );  
  
    cancelB = new Button( "CANCEL" );
    cancelB.setBackground( new Color( 180, 180, 180 ) );
    cancelB.setBounds ( 100, 300, 100, 30 );

    cancelB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        dispose();
      }
    } );

    loadB = new Button( "LOAD" );
    loadB.setBackground( new Color( 180, 180, 180 ) );
    loadB.setBounds( 300, 300, 100, 30 );

    loadB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        println( "LOADING :" );
        println( "name : " + list.getSelectedItem() );
        println( "id : " + savedStatesDictionary.get( list.getSelectedItem() ) );
        long idToLoad = savedStatesDictionary.get( list.getSelectedItem() );
        String[] rep = loadStrings( "http://" + referredWave.hostip + "/retrieveWaveState?id=" + idToLoad );
        if( rep[ 0 ].equals( null ) == false ){
          println( rep[ 0 ] );
          String[] pieces = fixedSplitToken( rep[ 0 ], "\t", 4 );
          println( "pieces is: " );
          for( int i = 0; i < pieces.length; i++ )
            println( pieces[ i ] );
          ArrayList<String> newSelCodes = turnToSelCodes( pieces[ 0 ] );
          String newStateName = pieces[ 1 ];
          String newActid = pieces[ 2 ];
          ArrayList<String> newSelEqs = turnToSelEqs( pieces[ 3 ] );
      
          owner.owner.hostip = owner.owner.hostip; // <<< MISSING
          owner.owner.school = owner.owner.school; // <<< MISSING
          owner.owner.teacher = owner.owner.teacher; // <<< MISSING
          owner.owner.cnameandcyear = owner.owner.cnameandcyear; // <<< MISSING
          String[] cpieces = splitTokens( owner.owner.cnameandcyear, ":" );
          owner.owner.cname = owner.owner.cname; // <<< MISSING
          owner.owner.cyear = owner.owner.cyear; // <<< MISSING
          //owner.owner.actid = newActid; // set actid; // OOPS -- problem in looking up Activtity with id:0
          owner.owner.actid = "1"; // this is dummy data
          owner.owner.starttimeFull = owner.owner.starttimeFull; // <<< MISSING
          //owner.owner.starttimeTrimmed = owner.owner.starttimeFull.substring( starttimeFull.length()-17, starttimeFull.length()-9 );
          owner.owner.functioncall = owner.owner.functioncall; // <<< MISSING

          owner.owner.buildADetails();
          println( "aDetails after re-building is: " ); 
          println( owner.owner.aDetails[ 0 ] );
          println( owner.owner.aDetails[ 1 ] );
          println( owner.owner.aDetails[ 2 ] );
          
          // re-create everything
          owner.owner.wva = new WaveActivity( owner.owner );
          owner.owner.wva.startWave( owner.owner.aDetails, Long.parseLong( owner.owner.actid ), owner.owner.hostip );
          owner.owner.wva.display();
          
          int count=0;
          fill( 0, 0, 255 );
          while( owner.owner.wva.dataWholeChunk.contains( "MATCHING" ) == false ) {
           // do nothing, wait for data to come in and loaded
           //if( count >= owner.owner.wva.wvaUI.view.xScrollPos2 - 100 )
             //count--;
           //else
             //count ++;
           //println( count );
           stroke( 0, 0, 255 );
           fill( 0, 0, 255 );
           owner.owner.wva.wvaUI.view.putRect( 20+count, 20, 130+count, 120 ); 
          }
          println( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OK NEW DATA IS IN <<<<<<<<<<<<<<<<<<<<<<<<<<<" );
 
          owner.owner.wva.wave.stateName = newStateName; // set wave.stateName
          owner.owner.wva.wave.stateID = idToLoad; // set wave.stateID 
          owner.owner.wva.wave.comments = ""; // set wave.comments <<< MISSING
          owner.owner.wva.wave.selCodes = newSelCodes; // set wave.selCodes
          owner.owner.wva.wave.selEqs = newSelEqs; // set wave.selEqs
          println( "new selEqs is: " + owner.owner.wva.wave.selEqs );
           
           println( "lastIndexReceived in new WaveActivity is: " + owner.owner.wva.lastIndexReceived );
           println( "baseURLAddress in new WaveActivity is: " + owner.owner.wva.baseURLAddress );
           println( "size of students and wavePoints is: " + owner.owner.wva.wave.students.size() + " " + owner.owner.wva.wave.wavePoints.size()  );
           println( "running markForDisplay()..." );
          owner.owner.wva.wave.markForDisplay( owner.owner.wva.wave.selCodes ); // markForDisplay
          println( "running loadSelectedEqs().." );
          owner.owner.wva.wave.loadSelectedEqs( owner.owner.wva.wave.selEqs ); // loadSelectedEqs
          println( "running sortBy()..." );
          owner.owner.wva.wave.sortBy( owner.owner.wva.wave.selEqs ); // sortBy
        }
        dispose(); 
      }
    } );

    add( label );
    add( list );
    add( cancelB );
    add( loadB );

  } // end constructor




  // Methods

  void buildSavedStates() {
    String[] temp = loadStrings( "http://" + hostip + "/getWaveStates" );
    for( String s : temp ) {
      savedStates.add( s );
      String[] pieces = splitTokens( s, "\t" );
      long l = Long.parseLong( pieces[ 0 ] );
      savedStateIDs.add( l );
      println( "added: " + s + " to savedStates, and " + l + " to savedStateIDs"  );
      savedStatesDictionary.put( s, l );
    }
  } // end buildSavedStates()
     



  ArrayList<String> turnToSelCodes( String s ) {
    ArrayList<String> ret = new ArrayList<String>();
    if( s.contains( "|" ) ) {
      String[] pieces = splitTokens( s, "|" );
      for( int i = 0; i < pieces.length; i++ ) {
        String[] smallPieces = splitTokens( pieces[ i ], ":" );
        ret.add( smallPieces[ 1 ] );
      }
    }
    return ret; 
  } // end turnToSelCodes()




  String[] fixedSplitToken( String row, String tkn, int targetCol ) {
      String input = row;
      String token = tkn;
      int colCount = targetCol;
      String[] ret = new String[ colCount ];
  
      int i = 0;
      int j = input.indexOf( token, i+1 );

      for( int index = 0; index < colCount - 1; index++ ) {
        String nextpiece = input.substring( i, j );
        ret[ index ] = nextpiece;
        i = j+1;
        j = input.indexOf( token, i );
      }
      ret[ colCount-1 ] = input.substring( i );
    return ret;
  } // end fixedSplitToken()



  ArrayList<String> turnToSelEqs( String s ) {
    ArrayList<String> ret = new ArrayList<String>();
    if( s.contains( "|" ) ) {
      String[] sels = splitTokens( s, "|" );
      for( int i = 0; i < sels.length; i++ ) {
        ret.add( sels[ i ] ); 
      }
    }
    return ret;
  } // end turnToSelEqs()




} // end class PopUpLoadstate
