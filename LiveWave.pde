// This is the main class for the Live Wave visualizer

// Fields

WaveActivity wva;

color hitColor, noHitColor, hitColorScatter, noHitColorScatter;
color popUpBkgrd, popUpTxt, butOv, butPress;
PFont waveFont;
Divider[] dividers;

  String[] aDetails = new String[ 3 ];

  // applet params
  String hostip, school, teacher, cnameandcyear, cname, cyear, actid, starttimeFull, starttimeTrimmed, functioncall;




void setup() {
  setupDisplayElements(); 
  /*
  readParams(); // comment to debug, uncomment before deploying
  
  // use these for deployment 
  aDetails[ 0 ] = "http://" + hostip + "/" + functioncall + "?aid=" + actid + "&ind=0";
  aDetails[ 1 ] = starttimeTrimmed;  
  aDetails[ 2 ] = actid + " " + cnameandcyear + " " + school + " " + teacher; 
  */
  //use these for debugging
  hostip = "localhost:9000";
  school = "SST";
  teacher = "Johari";
  cnameandcyear = "test2012"; // << NOTE: need to check the value
  cname = "test";
  cyear = "2012";
  actid = "1";
  starttimeFull = "00:00:00"; 
  starttimeTrimmed = "00:00:00"; 
  functioncall = "getAllContributionsAfterVerbose";
 
  //aDetails[ 0 ] = "http://203.116.116.34:80/getAllContributionsAfter?aid=8&ind=0";
  aDetails[ 0 ] = "http://localhost:9000/getAllContributionsAfterVerbose?aid=1&ind=0";
  aDetails[ 1 ] = "15:00:00";
  aDetails[ 2 ]  = "Testing";
  
  wva = new WaveActivity( this );
  wva.startWave( aDetails, Long.parseLong( actid ), hostip );
  
} // end setup()




void draw() {

  wva.display();

} // end draw()




void mousePressed() {
  wva.aUI.executeMousePressed(); 
} // end mousePressed()




void mouseDragged() {
  wva.aUI.executeMouseDragged();
} // end mouseDragged()




void mouseReleased() {
  wva.aUI.executeMouseReleased();
} // end mouseReleased()




void setupDisplayElements() {
  size( 1180, 1000 );
  smooth();
  waveFont = loadFont( "SansSerif.plain-12.vlw" ); // set as global to make changing easier
  textFont( waveFont );
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




void readParams() {
// Reads applet param tags from HTML file
//
  hostip = param( "hostip" );
  school = param( "school" );
  teacher = param( "teacher" );
  cnameandcyear = param( "cnameandcyear" );
  String[] cpieces = splitTokens( cnameandcyear, ":" );
  cname = cpieces[ 0 ];
  cyear = cpieces[ 1 ];
  actid = param( "actid" );
  starttimeFull = param( "starttime" );
  starttimeTrimmed = starttimeFull.substring( starttimeFull.length()-17, starttimeFull.length()-9 );
  functioncall = param( "functioncall" );
} // end readParams() 




float myRound( float val, int dp ) {
  return int( val * pow( 10, dp ) ) / pow( 10, dp );
} // end myRound()




void netEvent( HTMLRequest ml ) {
  wva.dataWholeChunk = ml.readRawSource();
  println( "done passing html input to dataWholeChunk" );
}
