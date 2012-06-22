class CodeCabinet {
// this is just a wrapper class so we can more conveniently pass 
// around all those lists and hashmaps on codes
// The constructor will take no argument. Initiation will create
// an object with no data (just a shell)
// data will be fed in via methods 
//
  // Fields
  
  ArrayList<CodeItem> codeItemsList;
  ArrayList<CodeCategory> codeCategoriesList;
  Map<String, CodeItem> codeItemsDictionary;
  Map<String, CodeCategory> codeCategoriesDictionary;
  Map<CodeItem, CodeCategory> codeBook;




  // Constructor
  CodeCabinet() {
    codeItemsList = new ArrayList<CodeItem>();
    codeCategoriesList = new ArrayList<CodeCategory>();
    codeItemsDictionary = new HashMap<String, CodeItem>();
    codeCategoriesDictionary = new HashMap<String, CodeCategory>();
    codeBook = new HashMap<CodeItem, CodeCategory>();
  } // end constructor




  // Methods

} // end class CodeCabinet
