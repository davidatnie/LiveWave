class CodeItem {

// Fields
String dispName, fullName;
CodeCategory owner;




// Constructor

CodeItem( String cod ) {
  dispName = cod;
  fullName = cod; // may want to change this in future
  owner = null;
} // end constructor




CodeItem( CodeCategory cat, String cod ) {
// Overloaded constructor to facilitate simultaneous assignment of owner on instantiation
//
  dispName = cod;
  fullName = cod;
  owner = cat;
} // end constructor




// Methods

void assignCategory( CodeCategory cat ) {
  owner = cat;
} // end assignCategory()








void revokeCategory() {
  owner = null;
} // end revokeCategory()




void reassignCategory( CodeCategory cat ) {
  revokeCategory();
  assignCategory( cat );
} // end reassignCategory()




  String toString() {
    String ret = "CodeItem: " + dispName + "\t" + fullName + "\n";
    return ret;
  } // end toString()




} // end class CodeItem
