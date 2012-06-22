class CodeCategory {

// Fields
String dispName, fullName;
ArrayList<CodeItem> codeItems;




// Constructor

CodeCategory( String cat ) {
  dispName = cat;
  fullName = cat; // just leave this here for now but may change in future
  codeItems = new ArrayList<CodeItem>(); // create empty arraylist, to be populated later
} // end constructor




CodeCategory( String cat, String cod ) {
// Overloaded constructor to facilitate instantiation with one code item
//
  dispName = cat;
  fullName = cat;
  codeItems = new ArrayList<CodeItem>();
  codeItems.add( new CodeItem( this, cod ) );
} // end overloaded constructor




// Methods

void addCodeItem( String cod ) {
  if( codeItems == null )
    codeItems = new ArrayList<CodeItem>();
  codeItems.add( new CodeItem( this, cod ) );
} // end addCodeItem()




void addCodeItem( CodeItem citem ) {
  if( codeItems == null )
    codeItems = new ArrayList<CodeItem>();
  codeItems.add( citem );
} // end addCodeItem() CodeItem flavor



void removeCodeItem( String cod ) {
  for( CodeItem citem : codeItems ) {
    if( citem.dispName.equals( cod ) ) {
      codeItems.remove( citem );
      break;
    }
  }
} // end removeCodeItem()




void removeCodeItem( CodeItem citem ) {
  if( codeItems.contains( citem ) )
    codeItems.remove( citem );
} // end removeCodeItem() CodeItem flavor




  ArrayList<CodeItem> getCodeItems() {
    return( codeItems );
  } // end getCodeItems()



  String toString() {
    String ret = "CodeCategory: " + dispName + "\t" + fullName + "\n";
    ret += "CodeItems: \t";
    for( CodeItem citem : codeItems ) {
      ret += citem.dispName + "\t" ;
    }
    ret += "\n";
    return ret;
  } // end toString()




} // end class CodeCategory
