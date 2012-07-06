import java.awt.Button;
import java.awt.Label;
import java.awt.List;
import java.awt.Frame;
import java.awt.Color;
import java.awt.event.*;



class PopUpLoadState extends Frame {

  // FieldsF

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
    setSize( 500, 350 );
    setLocationRelativeTo( null );
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
        String[] replyDB = loadStrings( "http://" + referredWave.hostip + "/retrieveWaveState?id=" + idToLoad );
        if( replyDB[ 0 ].equals( null ) == false ){
          println( "Load reply from DB is: " + replyDB[ 0 ] );
          String[] rep = fixedSplitToken( replyDB[ 0 ], "\t", 9 );
          println( rep );
          String newSchool = rep[ 0 ];
          String newTeacher = rep[ 1 ];
          String newClassAndYear = rep[ 2 ];
          String newStarttimeFull = rep[ 3 ];
  
          println( rep[ 4 ] );
          String[] pieces = splitTokens( rep[ 4 ], "|" );
          println( "pieces is: " );
          for( int i = 0; i < pieces.length; i++ )
            println( pieces[ i ] );
          ArrayList<String> newSelCodes = turnToSelCodes( rep[ 4 ] );
          
          String newStateName = rep[ 5 ];
          String newActid = rep[ 6 ];
          ArrayList<String> newSelEqs = turnToSelEqs( rep[ 7 ] );
          String newComments = rep[ 8 ];

      
          owner.owner.hostip = owner.owner.hostip; // retain hostip
          owner.owner.school = newSchool;
          owner.owner.teacher = newTeacher;
          owner.owner.cnameandcyear = newClassAndYear;
          String[] cpieces = splitTokens( newClassAndYear, ":" );
          owner.owner.cname = cpieces[ 0 ];
          owner.owner.cyear = cpieces[ 1 ];
          owner.owner.actid = newActid;
          owner.owner.starttimeFull = newStarttimeFull;
          owner.owner.starttimeTrimmed = newStarttimeFull.substring( newStarttimeFull.length()-17, newStarttimeFull.length()-9 );
          owner.owner.functioncall = owner.owner.functioncall; // retain functioncall

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
           
           if( count >= owner.owner.wva.wvaUI.view.xScrollPos2 - 100 )
             count--;
           else
             count ++;
           //println( count );
           stroke( 0, 0, 255 );
           fill( 0, 0, 255 );
           owner.owner.wva.wvaUI.view.clearBackground();
           owner.owner.wva.wvaUI.view.putRect( 20+count, 20, 130+count, 120 ); 
           fill( 255, 255, 0 );
           owner.owner.wva.wvaUI.view.putText( "LOADING ... ", 40+count, 60 );
           
          }
          
          println( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OK NEW DATA IS IN <<<<<<<<<<<<<<<<<<<<<<<<<<<" );
 
          owner.owner.wva.wave.stateName = newStateName; // set wave.stateName
          owner.owner.wva.wave.stateID = idToLoad; // set wave.stateID 
          owner.owner.wva.wave.comments = newComments;
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
