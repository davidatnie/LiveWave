import java.awt.Frame;
import java.awt.Panel;
import java.awt.Button;
import java.awt.Label;
import java.awt.Checkbox;
import java.awt.Choice;
import java.awt.Color;
import java.awt.Event.*;




class PopUpCodeChooser extends Frame{
  // Fields
  LVActivity owner;
  Label label1, label2;
  Choice categoryChooser;
  int shownIndex;
  ArrayList<Checkbox> chosenCatCBs, displayedCBs;
  Button selAllCB, deselAllCB, selAllGB, deselAllGB;
  ArrayList<String> selCodes;
  Button okB, cancelB, nextB, prevB;  
  CodeCabinet codeCabinet;




  // Constructor

  PopUpCodeChooser( LVActivity o, CodeCabinet cc, ArrayList<String> prevSelection ) {
    super( "Select Codes To Display" );
    setSize( 450, 450 );
    setLocationRelativeTo( null );
    setBackground( new Color( 255, 255, 255 ) );
    setVisible( true );
    setLayout( null );
    owner = o;
    codeCabinet = cc;
    selCodes = prevSelection;
    setBackground( new Color( 0, 0, 0 ) );
    
    // make static elements

    selAllGB = new Button( "Select ALL Codes, All Categories" );
    selAllGB.setBounds( 200, 30, 230, 25 );
    selAllGB.setBackground( new Color( 180, 180, 180 ) );

    deselAllGB = new Button( "De-select ALL Codes, All Categories" );
    deselAllGB.setBounds( 200, 60, 230, 25 );
    deselAllGB.setBackground( new Color( 180, 180, 180 ) );
   
    label1 = new Label( "SELECT GLOBALLY:" );
    label1.setBounds( 40, 30, 130, 20 );
    label1.setForeground( new Color( 255, 255, 0 ) );

    label2 = new Label( "SELECT BY CATEGORY:" );
    label2.setBounds( 40, 120, 150, 20 );
    label2.setForeground( new Color( 255, 255, 0 ) );

    okB = new Button( "OK" );
    okB.setBounds( 330, 400, 100, 30 );
    okB.setBackground( new Color( 180, 180, 180 ) );

    cancelB = new Button( "CANCEL" );
    cancelB.setBounds( 200, 400, 100, 30 );
    cancelB.setBackground( new Color( 180, 180, 180 ) );

    nextB = new Button( "NEXT" );
    nextB.setBounds( 330, 300, 100, 40 );
    nextB.setBackground( new Color( 180, 180, 180 ) );

    prevB = new Button( "PREVIOUS" );
    prevB.setBounds( 330, 250, 100, 40 );
    prevB.setBackground( new Color( 180, 180, 180 ) );

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
    categoryChooser.setBounds( 200, 120, 230, 25 );
    categoryChooser.setBackground( new Color( 255, 220, 200 ) );
    categoryChooser.select( catKeys[ 0 ] );
    processChosenCat( catKeys[ 0 ] );
    
    selAllCB = new Button( "Select All Codes In This Category" );
    selAllCB.setBounds( 230, 150, 200, 25 );
    selAllCB.setBackground( new Color( 180, 180, 180 ) );
    
    deselAllCB = new Button( "De-select All Codes In This Category" ); 
    deselAllCB.setBounds( 230, 180, 200, 25 );
    deselAllCB.setBackground( new Color( 180, 180, 180 ) );

    add( okB );
    add( cancelB );
    add( label1 );
    add( label2 );
    add( selAllGB );
    add( deselAllGB );
    add( categoryChooser );
    add( selAllCB );
    add( deselAllCB );
    add( prevB );
    add( nextB );
    paintDisplayedCBs();

    // controllers

    selAllGB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        ArrayList<String> selCodesTemp = new ArrayList<String>();
        for( String ciString : codeCabinet.codeItemsDictionary.keySet()  )
          selCodesTemp.add( ciString );
        selCodes = selCodesTemp;
        for( Checkbox cb : displayedCBs ) {
          cb.setState( true );
        }
        for( Checkbox cb : chosenCatCBs ) {
          cb.setState( true ); 
        }
      }
    } );

    deselAllGB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        selCodes = new ArrayList<String>(); // empty ArrayList
        for( Checkbox cb : displayedCBs )
          cb.setState( false );
        for( Checkbox cb : chosenCatCBs )
          cb.setState( false );
      }
    } );

    selAllCB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        String chosenCat = categoryChooser.getSelectedItem();
        if( chosenCat.equals( null ) == false ) {
          println( "Selecting ALL Codes for Category : " + chosenCat );
          for( CodeItem ci : codeCabinet.codeCategoriesDictionary.get( chosenCat ).codeItems ) {
            if(selCodes.contains( ci.dispName ) == false ) {
              println( "\tselecting " + ci.dispName );
                selCodes.add( ci.dispName );
                
                for( Checkbox cb : chosenCatCBs )
                  if( cb.getLabel().equals( ci.dispName ) )
                    cb.setState( true );
                
                for( Checkbox cb : displayedCBs )
                  if( cb.getLabel().equals( ci.dispName ) )
                    cb.setState( true );
            } // end if
          }
        }
      }
    } );

    deselAllCB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        String chosenCat = categoryChooser.getSelectedItem();
        if( chosenCat.equals( null ) == false ) {
          println( "Deselecting ALL Codes for Cateogry : " + chosenCat );
         for( CodeItem ci : codeCabinet.codeCategoriesDictionary.get( chosenCat ).codeItems ) {
            if( selCodes.contains( ci.dispName ) ) {
              println( "\tdeselecting " + ci.dispName );
              selCodes.remove( ci.dispName );
              
              for( Checkbox cb : chosenCatCBs )
                if( cb.getLabel().equals( ci.dispName ) )
                  cb.setState( false );
                  
              for( Checkbox cb : displayedCBs )
                if( cb.getLabel().equals( ci.dispName ) )
                  cb.setState( false );
            } // end if
          }
        }
      }
    } );


    okB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        selCodes = updateSelCodes( getUnchecked( displayedCBs ), getChecked( displayedCBs ) );
        WaveActivity downcasted = ( WaveActivity ) owner;
        downcasted.wave.selCodes = selCodes;
        println( selCodes );
        downcasted.wave.markForDisplay( downcasted.wave.selCodes );
        downcasted.wave.sortBy( downcasted.wave.selEqs );
        dispose();
      }
    } );

    cancelB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        dispose();
      }
    } );

    categoryChooser.addItemListener( new ItemListener() {
      public void itemStateChanged( ItemEvent e ) { 
        processChosenCat( categoryChooser.getSelectedItem() );
      }
    } );

    nextB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {

        selCodes = updateSelCodes( getUnchecked( displayedCBs ), getChecked( displayedCBs ) );

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

    prevB.addActionListener( new ActionListener() {
      public void actionPerformed( ActionEvent e ) {
        
        selCodes = updateSelCodes( getUnchecked( displayedCBs ), getChecked( displayedCBs ) );

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
  



  // Methods

  void processChosenCat( String chosenCat ) {  
    println( "processing chosen Category : " + chosenCat ); 
    shownIndex = 0;
    chosenCatCBs = new ArrayList<Checkbox>();
    println( "chosenCatCBs is: " );
    for( CodeItem ci : codeCabinet.codeCategoriesDictionary.get( chosenCat ).codeItems ) {
      if( selCodes.contains( ci.dispName ) )
        chosenCatCBs.add( new Checkbox( ci.dispName, true ) );
      else
        chosenCatCBs.add( new Checkbox( ci.dispName, false ) );
      println( "\t" + ci.dispName );
    }
    println( "chosenCatCBs.size is: " + chosenCatCBs.size() ); 
    
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
    int x1Reg = 50;
    int y1Reg = 150;
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
            if( selCodes.contains( cbLabel ) == false )
              selCodes.add( cbLabel );
          } else {
            if( sel.Codes.contains( cbLabel ) == true )
              selCodes.remove( cbLabel );
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




  ArrayList<String> updateSelCodes( ArrayList<String> unchecked, ArrayList<String> checked ) {
    ArrayList<String> ret = selCodes;
    // Go through unchecked list and remove from selCodes
    for( String s : unchecked )
      if( ret.contains( s ) )
        ret.remove( s );

    // then go through the checked list and add to selCodes
    for( String s : checked )
      if( ret.contains( s ) == false )
        ret.add( s );
    return ret;
  } // end updateSel()
} // end class PopUpCodeChooser
