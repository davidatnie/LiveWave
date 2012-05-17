// This is the main class for the Live visualizations - Wave and Spiral

import processing.pdf.*;
import processing.serial.*;


// Fields
PImage bk;

Activity currentActivity;
SpiralActivity spa;
WaveActivity wva;
MenuActivity menu;

// From Spiral v1.6
Section[] sections;
String[] datasets;
int activeDataset = 0;

int exNumOpPlus, exNumOpMinus, exNumOpTimes, exNumOpDivides, exNumBonSquare, exNumBonNegative;
int exNumOpPlusHit, exNumOpMinusHit, exNumOpTimesHit, exNumOpDividesHit, exNumBonSquareHit, exNumBonNegativeHit;

color hitColor, noHitColor, hitColorScatter, noHitColorScatter;
color popUpBkgrd, popUpTxt, butOv, butPress;
PFont spiralFont;
PFont pdfFont;
Divider[] dividers;

boolean savePDF;

Serial arduinoPort;
MPanel mPanel;
JPointer[] myJays;
// end from Spiral v1.6




void setup() {
  setupDisplayElements(); 
  menu = new MenuActivity( this );
  currentActivity = menu;
  bk = loadImage( "SST_logo.png" );

  // temporary block 
  if( arduinoPort == null ) {
    myJays = new JPointer[ 2 ];
    myJays[0] = new JPointer( 0, 0, color(0,0,0), color(0,0,0) );
    myJays[1] = new JPointer( 0, 0, color(0,0,0), color(0,0,0) );
  }

  savePDF = false;
} // end setup()




void draw() {
  if( savePDF )
    startSaveToPDF();

  int i = 0;
  while ( i < width ) {
    int j = 0;
    while ( j < height ) {
      image( bk, i, j );
      j += bk.height;
    } 
    i += bk.width;
  }
  currentActivity.display();
  
  if( savePDF )
    endSaveToPDF();
 
} // end draw()




void mousePressed() {
  currentActivity.aUI.executeMousePressed(); 
  if ( mouseButton == RIGHT ) {
    background( 180 );
    if ( currentActivity == menu & spa != null )
      currentActivity = spa;
    else if( currentActivity == spa ) {
      initWave( menu.mUI.aDetails );
      currentActivity = wva;
    }
    else { 
      menu = new MenuActivity( this );
      currentActivity = menu;
    }
  } // end if mouseButton == RIGHT
} // end mousePressed()




void mouseDragged() {
  currentActivity.aUI.executeMouseDragged();
} // end mouseDragged()




void mouseReleased() {
  currentActivity.aUI.executeMouseReleased();
} // end mouseReleased()




void initSpiral( String[] aDetails ) {
  spa = new SpiralActivity( this );
  currentActivity = spa;
  spa.startSpiral( aDetails );
} // end initSpiral()



void initWave( String[] aDetails ) {
  wva = new WaveActivity( this );
  wva.startWave( aDetails );
} // end initWave




void setupDisplayElements() {
  size( 1280, 700 );
  smooth();
  spiralFont = loadFont( "SansSerif.plain-12.vlw" ); // set as global to make changing easier
  textFont( spiralFont );
  hitColor = color( 0, 200, 0 );
  noHitColor = color( 200, 0, 0 );
  hitColorScatter = hitColor;
  noHitColorScatter = noHitColor;
  popUpBkgrd = color ( 0, 0, 0, 180 );
  popUpTxt = color( 255, 255, 0 );
  butOv = color( 0, 0, 0, 100 );
  butPress = color ( 10, 250, 10, 255 ); 

  dividers = new Divider[ 2 ];
  dividers[ 0 ] = new Divider( true, 0, 300, 350, 300, 90 );
  dividers[ 1 ] = new Divider( false, 350, 0, 350, height, 90 );
} // end setupDisplayElements()



float myRound( float val, int dp ) {
  return int( val * pow( 10, dp ) ) / pow( 10, dp );
} // end myRound()




void netEvent( HTMLRequest ml ) {
  if( currentActivity == spa )
  {
    spa.dataWholeChunk = ml.readRawSource();
    println( "done passing html input to dataWholeChunk" ); 
  }
}




void startSaveToPDF() {
  beginRecord( PDF, spa.spiral.pdfName ); // start saving to PDF file
  pdfFont = createFont( "Verdana Bold", 6 );
  textFont( pdfFont );
} // end startSaveToPDF()




void endSaveToPDF() {
  endRecord();      // end saving to PDF
  savePDF = false;
} // end endSaveToPDF()
