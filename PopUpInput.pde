import java.awt.Button;
import java.awt.TextArea;
import java.awt.Label;
import java.awt.Checkbox;
import java.awt.Choice;
import java.awt.Frame;
import java.awt.Panel;
import java.awt.Color;
import java.awt.event.*;





class PopUpInput extends Frame{
  // Fields
  // Annotation
  LVActivity owner;
  WavePt referredPt;
  TextArea input;
  Label captionL;
  String title, caption,  contents, oldContents;
  Button okB, cancelB, clearB;
  // Tagger
  Label taggerL;
  Choice categoryChooser;
  int shownIndex;
  ArrayList<Checkbox> chosenCatCBs, displayedCBs;
  Button nextB, prevB;
  ArrayList<String> wpCodes, oldWpCodes;
  CodeCabinet codeCabinet;





  //Constructor

  PopUpInput( LVActivity o, CodeCabinet cc, WavePt ref, String t, String c, String cont ) {
    super( t );
    owner = o;
    codeCabinet = cc;
    referredPt = ref;
    title = t;
    caption = c;
    contents = cont;
    oldContents = contents;
    wpCodes = new ArrayList<String>();
    for( CodeItem ci : referredPt.codes )
      wpCodes.add( ci.dispName );
    oldWpCodes = new ArrayList<String>();
    for( String s : wpCodes ) {
      oldWpCodes.add( new String ( s ) ); 
    }
    float popUpWidth = 500;
    float popUpHeight =550;
    setSize( int( popUpWidth ), int( popUpHeight ) );
    setLocation( int( mouseX ), mouseY );
    setVisible( true );  // these three must be in order : setVisible( true ), setLayout( null ) and setBackground( Color )
    setLayout( null );
    setBackground( new Color( 0, 0, 0 ) );

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
    
    // Annotater M&C below:
  
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
    clearB.setLocation( 50, 500 );
    clearB.setSize( 100, 30 );    
    
    clearB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        contents = "";
	input.setText( contents );
      }
    }
    );
    
    cancelB = new Button( "CANCEL" );
    cancelB.setBackground( new Color( 180, 180, 180 ) );
    cancelB.setLocation( 200, 500 );
    cancelB.setSize( 100, 30 );
    
    cancelB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        dispose();
      }
    }
    );
    
    okB = new Button( "OK" );
    okB.setBackground( new Color( 180, 180, 180 ) );
    okB.setLocation( 350, 500 );
    okB.setSize( 100, 30 );
    
    okB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        contents = input.getText();
        wpCodes = updateWpCodes( getUnchecked( displayedCBs ), getChecked( displayedCBs ) );
        if( contentChanged() )
          sendNewContent();
        if( wpCodesChanged() )
          sendNewWpCodes();
	dispose();
      } // end actionPerformed()
    } // end inner class
    ); // end input.addActionListener()
    
    // Tagger MVC below:

    taggerL = new Label( "To Tag, first select a Category and then check the box of the Code Item(s)" );
    taggerL.setBounds( 20, 170, 500, 20 );
    taggerL.setForeground( new Color( 255, 255, 0 ) );

    nextB = new Button( "NEXT" );
    nextB.setBounds( 330, 400, 100, 40 );
    nextB.setBackground( new Color( 180, 180, 180 ) );

    nextB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {

        wpCodes = updateWpCodes( getUnchecked( displayedCBs ), getChecked( displayedCBs ) );

        if( shownIndex < chosenCatCBs.size() - 10 ) {
          clearDisplayedCBs();
          shownIndex += 10;
          displayedCBs = setDisplayedCBs( chosenCatCBs, shownIndex, 10 );
          addDisplayedCBsListeners();
          paintDisplayedCBs();
        }
        if( shownIndex < 10 )
          prevB.setVisible( false );  // no more PREVIOUS
        else
          prevB.setVisible( true );
        if( shownIndex < chosenCatCBs.size() - 10 )
          nextB.setVisible( true );
        else
          nextB.setVisible( false );
      }    
    } );
    
    prevB = new Button( "PREVIOUS" );
    prevB.setBounds( 330, 350, 100, 40 );
    prevB.setBackground( new Color( 180, 180, 180 ) );

    prevB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        
        wpCodes = updateWpCodes( getUnchecked( displayedCBs ), getChecked( displayedCBs ) );

        if( shownIndex >= 10 ) {
          clearDisplayedCBs();
          shownIndex -= 10;
          displayedCBs = setDisplayedCBs( chosenCatCBs, shownIndex, 10 );
          addDisplayedCBsListeners();
          paintDisplayedCBs();
        }
        if( shownIndex > chosenCatCBs.size()-10 )
          nextB.setVisible( false ); // no more NEXT
        else
          nextB.setVisible( true );
        if( shownIndex >= 10 )
          prevB.setVisible( true );
        else
          prevB.setVisible( false );
      }
    } );

    categoryChooser = new Choice();
    Set<String> ks = codeCabinet.codeCategoriesDictionary.keySet();
    String[] catKeys = new String[ ks.size() ];
    int pos = 0;
    Iterator it = ks.iterator();
    while( it.hasNext() ) {
       catKeys[ pos ] = (String) it.next();
       println( pos + " " + catKeys[ pos ] );
       pos++;
    }
    
    for( String ck : catKeys )
      categoryChooser.addItem( ck );
    categoryChooser.setBounds( 100, 200, 230, 25 );
    categoryChooser.setBackground( new Color( 255, 220, 200 ) );
    categoryChooser.select( catKeys[ 0 ] );
    processChosenCat( catKeys[ 0 ] );
    
    categoryChooser.addItemListener( new ItemListener() {
      public void itemStateChanged( ItemEvent e ) { 
        processChosenCat( categoryChooser.getSelectedItem() );
      }
    } );

    // Annotater and Tagger View:

    add( captionL );
    add( input );
    add( clearB );
    add( cancelB );
    add( okB );

    add( taggerL );
    add( categoryChooser );
    add( nextB );
    add( prevB );
    paintDisplayedCBs();

  } // end constructor


  // Methods

  void processChosenCat( String chosenCat ) {  
    println( "processing chosen Category : " + chosenCat ); 
    shownIndex = 0;
    chosenCatCBs = new ArrayList<Checkbox>();
    println( "chosenCatCBs is: " );
    for( CodeItem ci : codeCabinet.codeCategoriesDictionary.get( chosenCat ).codeItems ) {
      if( wpCodes.contains( ci.dispName ) )
        chosenCatCBs.add( new Checkbox( ci.dispName, true ) );
      else
        chosenCatCBs.add( new Checkbox( ci.dispName, false ) );
      println( "\t" + ci.dispName );
    }
    println( "chosenCatCBs.size is: " + chosenCatCBs.size() ); 
    
    if( displayedCBs != null )
      wpCodes = updateWpCodes( getUnchecked( displayedCBs ), getChecked( displayedCBs ) );

    clearDisplayedCBs();
    
    displayedCBs = setDisplayedCBs( chosenCatCBs, shownIndex, 10 );
    addDisplayedCBsListeners();
    paintDisplayedCBs();

    if( chosenCatCBs.size() > 10 ) {
      if( shownIndex > chosenCatCBs.size()-10 )
        nextB.setVisible( false ); // no more NEXT
      else
        nextB.setVisible( true );
    } else {
      nextB.setVisible( false );
    }
    
    if( chosenCatCBs.size() > 10 ) {
      if( shownIndex < 10 )
        prevB.setVisible( false ); // no more PREVIOUS
      else
        prevB.setVisible( true );
    } else {
      prevB.setVisible( false ); 
    }
  } // end processChosenCat()




  ArrayList<Checkbox> setDisplayedCBs( ArrayList<Checkbox> inputCBs, int indexStart, int numberToDisp ) {

    println( "Hiding the following Checkboxes :" );
    for( Checkbox cb : inputCBs ) {
      println( "\t" + cb.getLabel() );
      cb.setVisible( false );
      //remove( cb );
    }

    ArrayList<Checkbox> ret = new ArrayList<Checkbox>();
    int startPos = indexStart;
    int endPos = indexStart + numberToDisp;
    if( inputCBs.size() < endPos )
      endPos = inputCBs.size(); 
    int x1Reg = 130;
    int y1Reg = 230;
    //int x2Reg = 255;
    //int y2Reg - 300;
    int cbWidth = 120;
    int cbHeight = 20;

    println( "Showing the following Checkboxes :" );
    for( int i = startPos; i < endPos; i++ ) {
      inputCBs.get( i ).setBounds( x1Reg, ( (i%10) * cbHeight )+y1Reg + ((i%10)*5), cbWidth, cbHeight );
      inputCBs.get( i ).setBackground( new Color( 255, 220, 200 ) );
      println( "\t" + inputCBs.get( i ).getLabel() );
      inputCBs.get( i ).setVisible( true );
      ret.add( inputCBs.get( i ) );
    }
    return ret;
  } // end setDisplayedCBs()




  void addDisplayedCBsListeners() {
  // call this EVERYTIME a new displayedCBs is created
  // and call this ONLY AFTER displayedCBs is created
  //
    for( int i = 0; i < displayedCBs.size(); i++ ) {
      Checkbox cb = displayedCBs.get( i );
      /*
      String cbLabel = cb.getLabel();
      boolean cbState = cb.getState(); */
      cb.addItemListener( new ItemListener() {
        public void itemStateChanged( ItemEvent e ) {
          /*
          if( cb.getState() ) {
            if( wpCodes.contains( cbLabel ) == false )
              wpCodes.add( cbLabel );
          } else {
            if( sel.Codes.contains( cbLabel ) == true )
              wpCodes.remove( cbLabel );
          }
          */
        }
      } );
    }
  } // end adddisplayedCBsListeners()




  void clearDisplayedCBs() {
    if( displayedCBs != null )
      for( Checkbox cb : displayedCBs ) {
        remove( cb );
    }
  } // end clearDisplayedCBs()




  void paintDisplayedCBs() {
    println( "displayedCBs size is: " + displayedCBs.size() );
    for( Checkbox cb : displayedCBs ) {
      add( cb );
      println( cb.getLabel() + " added" );
      //cb.setVisible( true );
    }
  } // end paintdisplayedCBs()




  ArrayList<String> getUnchecked( ArrayList<Checkbox> inputCBs ) {
    ArrayList<String> ret = new ArrayList<String>();
    for( Checkbox cb : inputCBs )
      if( cb.getState() == false )
        ret.add( cb.getLabel() );
    return ret;
  } // end getUncheckedd()

  


  ArrayList<String> getChecked( ArrayList<Checkbox> inputCBs ) {
    ArrayList<String> ret = new ArrayList<String>();
    for( Checkbox cb : inputCBs )  
      if( cb.getState() )
        ret.add( cb.getLabel() );
    return ret;
  } // end getChecked()




  ArrayList<String> updateWpCodes( ArrayList<String> unchecked, ArrayList<String> checked ) {
    ArrayList<String> ret = wpCodes;
    // Go through unchecked list and remove from wpCodes
    for( String s : unchecked )
      if( ret.contains( s ) )
        ret.remove( s );

    // then go through the checked list and add to wpCodes
    for( String s : checked )
      if( ret.contains( s ) == false )
        ret.add( s );
    return ret;
  } // end updateWpCodes()




  boolean contentChanged() {
    if( oldContents.equals( contents ) == false ) 
      return true;
    else
      return false;
  } // end contentChanged()




  boolean wpCodesChanged() {
    boolean ret = false;
    int countHit = 0;
    for( String s : wpCodes ) {
      if( oldWpCodes.contains( s ) )
        countHit++;
    }
    if( countHit == wpCodes.size() && wpCodes.size() == oldWpCodes.size() )
      return false;  // if all Hit, theres no change
    else
      return true;
  } // end wpCodesChanged()




  void sendNewContent() {
    String toSend = consolidateContent();
    // sendToDatabase( annotationURL, toSend );
    referredPt.annotation = contents; // update Visualizer
  } // end sendNewContent()




  void sendNewWpCodes() {
    String toSend = consolidateWpCodes();
    // sendToDatabase( codeItemsURL, toSend );
    ArrayList<CodeItem> newWpCodes = new ArrayList<CodeItem>();
    for( String s : wpCodes )
      newWpCodes.add( new CodeItem( s ) );
    referredPt.codes = newWpCodes;
  } // end sendNewWpCodes()



  String consolidateContent() {
    String ret = "";
    String[] newContentspieces = splitTokens( contents, "\n" );
    for( String s : newContentspieces )
      ret += s + "|";
    return ret;
  } // consolidatedContent()
  
  
  
  
  String consolidateWpCodes() {
    String ret = "";
    for( String s : wpCodes )
      ret += s + "|";
    return ret;
  } // end consolidateWpCodes()
  
  
  
  
} // end class PopUpInput
