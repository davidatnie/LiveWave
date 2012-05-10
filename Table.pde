// Main data class which holds data in a tabular format. Used by both the Wave and the Spiral viz
// This is a modified version of Fry's Table class.
// Added features are as follows (as@ 27/06/2010):
// 1. Now can get columnCount - added columnCount field
// 2. Now can read TAB delimited file with " as the separation char - added .trim() method to the various "get" methods
// 3. Now can also take in data in the form of an array of rows

class Table {

  // Fields

  String[][] data;
  int rowCount;
  int columnCount;
  


  // Constructor
  
  Table() {
    data = new String[10][10];
  }



  // Overloaded constructor to handle data in an array of String
  Table( String[] dataInRows ) {
    String[] rows = dataInRows;
    data = new String[rows.length] [];
    
    for (int i = 0; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) {
        continue;  // skip comment lines
      }
      
      // split the row on the tabs
      String[] pieces = split(rows[i], "\t");
      columnCount = pieces.length; // number of columns - value starts from 1 and not 0.
      // copy to the table array
      data[rowCount] = pieces;
      rowCount++;
      
      // this could be done in one fell swoop via:
      //data[rowCount++] = split(rows[i], TAB);
    }
    // resize the 'data' array as necessary
    data = (String[][]) subset(data, 0, rowCount);
  } // end overloaded constructor



  
  Table(String filename) {
    String[] rows = loadStrings(filename);
    data = new String[rows.length][];
    
    for (int i = 0; i < rows.length; i++) {
      if (trim(rows[i]).length() == 0) {
        continue; // skip empty rows
      }
      if (rows[i].startsWith("#")) {
        continue;  // skip comment lines
      }
      
      // split the row on the tabs
      String[] pieces = split(rows[i], "\t");
      columnCount = pieces.length; // number of columns - value starts from 1 and not 0.
      // copy to the table array
      data[rowCount] = pieces;
      rowCount++;
      
      // this could be done in one fell swoop via:
      //data[rowCount++] = split(rows[i], TAB);
    }
    // resize the 'data' array as necessary
    data = (String[][]) subset(data, 0, rowCount);
  } // end constructor



  // Methods
  
  int getColumnCount() {
    return columnCount; 
  }




  int getRowCount() {
    return rowCount;
  }
  


  
  // find a row by its name, returns -1 if no row found
  int getRowIndex(String name) {
    for (int i = 0; i < rowCount; i++) {
      if (data[i][0].equals(name)) {
        return i;
      }
    }
    println("No row named '" + name + "' was found");
    return -1;
  }


  
  
  String getRowName(int row) {
    return getString(row, 0).trim();
  }




  String getString(int rowIndex, int column) {
    return data[rowIndex][column].trim();
  }



  
  String getString(String rowName, int column) {
    return getString(getRowIndex(rowName), column);
  }

  
  int getInt(String rowName, int column) {
    return parseInt(getString(rowName, column).trim());
  }



  
  int getInt(int rowIndex, int column) {
    return (int) parseFloat(getString(rowIndex, column).trim());
  }



  
  float getFloat(String rowName, int column) {
    return parseFloat(getString(rowName, column).trim());
  }



  
  float getFloat(int rowIndex, int column) {
    return parseFloat(getString(rowIndex, column).trim());
  }
  
    
  

  void setRowName(int row, String what) {
    data[row][0] = what;
  }




  void setString(int rowIndex, int column, String what) {
    data[rowIndex][column] = what;
  }



  
  void setString(String rowName, int column, String what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = what;
  }



  
  void setInt(int rowIndex, int column, int what) {
    data[rowIndex][column] = str(what);
  }



  
  void setInt(String rowName, int column, int what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = str(what);
  }



  
  void setFloat(int rowIndex, int column, float what) {
    data[rowIndex][column] = str(what);
  }


  void setFloat(String rowName, int column, float what) {
    int rowIndex = getRowIndex(rowName);
    data[rowIndex][column] = str(what);
  }


  
  
  // Write this table as a TSV file
  void write(PrintWriter writer) {
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < data[i].length; j++) {
        if (j != 0) {
          writer.print("\t");
        }
        if (data[i][j] != null) {
          writer.print(data[i][j]);
        }
      }
      writer.println();
    }
    writer.flush();
  } // end write()




} // end class Table



