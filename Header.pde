// used by both the Live Wave and the Live Spiral viz

class Header {

  // will hold data structure of the "header" received from the database
  // A "header" is basically just a list of Activities
  
  // Fields

  ArrayList <HObject> hobjects;
  ArrayList <School> schools;
  Table t;


 
  
  // Constructor

  Header( String address ) {
    println( "[ CONSTRUCTING HEADER ]" );
    t = new Table( loadStrings( "http://203.116.116.34:80/getAllActivities" ) );
    schools = new ArrayList();
    
    // loop through each row and column of the table
    for( int i = 1; i < t.getRowCount(); i++ ) {
      String schooli = "";
      String teacheri = ""; 
      String classroomi = ""; 
      String gsActivityi = "";
      for( int j = 0; j < t.getColumnCount(); j++ ) {
        String cell = t.getString( i, j );
        if( j == 0 ) { 		   // looking at Schools
          if( getSchool( cell ) == null ) {
            println( "     building school ... " + cell );
      	    schools.add( new School( cell ) );
          }
      	  schooli = cell;
        } else if( j == 1 ) { 	   // looking at Teachers
	  if( getTeacher( schooli, cell ) == null ) {
            println( "     building teacher ... " + cell );
    	    School s = getSchool( schooli );
            s.teachers.add( new Teacher( s, cell ) );
	  }
          teacheri = cell;
	} else if( j == 2 ) { 	   // looking at Classrooms
          if( getClassroom( schooli, teacheri, cell ) == null ) {
            println( "     building classroom ... " + cell );
	    School s = getSchool( schooli );
  	    Teacher t = getTeacher( schooli, teacheri );
	    t.classrooms.add( new Classroom( t, cell ) );
	  }
	  classroomi = cell;
	} else if( j == 4 ) {	   // looking at GSActivities index, skipping j==3, which is GSActivity names
	  Long gsAID = Long.parseLong( cell );                      // convert ActivityID from String to Long
	  if( getGSActivity( schooli, teacheri, classroomi, gsAID ) == null ) {
	    School s = getSchool( schooli );
	    Teacher tc = getTeacher( schooli, teacheri );
	    Classroom cr = getClassroom( schooli, teacheri, classroomi );
	    String cellToDisplayName = t.getString( i, ( j-1 ) );       //process displayname here
            println( "     building GSActivity index# ... " + cell + " name : " + cellToDisplayName );
            cr.gsActivities.add( new GSActivity( cr, cellToDisplayName, cellToDisplayName, gsAID ) );
	  }
	  
	}
      } // end for j
    } // end for i
    println( "[ DONE CONSTRUCTING HEADER ]" );
  } // end constructor
  



  // Methods

  School getSchool( String sn ) {
    if( schools == null )
      return null;
    else {
      School result = null;
      for( School s : schools ) {
        if( s.getName().equals( sn ) )
        result = s;
      } // end for 
      if( result == null )
        return null;
      else
        return result;
    }
  } // end getSchool()



  
  Teacher getTeacher( String sn, String tn ) {
    if( getSchool( sn ).teachers == null )
      return null;
    else {
      Teacher result = null;
      for( Teacher t : getSchool( sn ).teachers ) {
        if( t.getName().equals( tn ) )
          result = t;
      } // end for
      if( result == null )
        return null;
      else
        return result;
    } 
  } // end getTeacher()
  



  Classroom getClassroom( String sn, String tn, String crn ) {
    if( getTeacher( sn, tn ).classrooms == null )
      return null; 
    else {
      Classroom result = null;
      for( Classroom cr : getTeacher( sn, tn ).classrooms ) {
        if( cr.getName().equals( crn ) )
        result = cr;
      } // end for
      if( result == null )
        return null;
       else
        return result;
    }
  } // end getClassroom()
  


  
  GSActivity getGSActivity( String sn, String tn, String crn, Long gsaid ) {
    if( getClassroom( sn, tn, crn ).gsActivities == null )
      return null;
    else {
      GSActivity result = null;
      for( GSActivity gsa : getClassroom( sn, tn, crn ).gsActivities ) {
        if( gsa.getAID() == gsaid )
          result = gsa; 
      } // end for  
      if( result == null )
        return null;
      else
        return result;
    } 
  } // end getGSActivity()




GSActivity getGSActivity( String sn, String tn, String crn, String gsn ) {
    if( getClassroom( sn, tn, crn ).gsActivities == null )
      return null;
    else {
      GSActivity result = null;
      for( GSActivity gsa : getClassroom( sn, tn, crn ).gsActivities ) {
        if( gsa.getName().equals( gsn ) )
          result = gsa; 
      } // end for  
      if( result == null )
        return null;
      else
        return result;
    } 
  } // end getGSActivity()


  
  
  String[] getSchools() {
    String[] result;
    if( schools == null ) {
      result = new String[ 1 ];
      result[ 0 ] = "";  
    } else {
      result = new String[ schools.size() ];
      for( int i = 0; i < schools.size(); i++ ) {
        School s = schools.get( i );
        result[ i ] = s.getDisplayName();
      }
    }
    return result;
  } // end getSchools()




  String[] getTeachers( String sn ) {
    School s = getSchool( sn );
    String[] result;
    if( s.teachers == null ) {
      result = new String[ 1 ];
      result[ 0 ] = "";  
    } else {
      result = new String[ s.teachers.size() ];
      for( int i = 0; i < s.teachers.size(); i++ ) {
        Teacher t = s.teachers.get( i );
        result[ i ] = t.getDisplayName();
      }
    }
    return result;
  } // end getTeachers()




  String[] getClassrooms( String sn, String tn ) {
    Teacher t = getTeacher( sn, tn );
    String[] result;
    if( t.classrooms == null ) {
      result = new String[ 1 ];
      result[ 0 ] = "";  
    } else {
      result = new String[ t.classrooms.size() ];
      for( int i = 0; i < t.classrooms.size(); i++ ) {
        Classroom cr = t.classrooms.get( i );
        result[ i ] = cr.getDisplayName();
      }
    }
    return result;
  } // end getClassrooms()




  String[] getGSActivities( String sn, String tn, String crn ) {
    Classroom cr = getClassroom( sn, tn, crn );
    String[] result;
    if(  cr.gsActivities == null ) {
      result = new String[ 1 ];
      result[ 0 ] = "";  
    } else {
      result = new String[ cr.gsActivities.size() ];
      for( int i = 0; i < cr.gsActivities.size(); i++ ) {
        GSActivity gsa = cr.gsActivities.get( i );
        result[ i ] = gsa.getDisplayName();
      }
    }
    return result;
  } // end getGSActivities()




} // end class Header



// ============================================================================
// TINY CLASSES used by Header class
// ============================================================================

class HObject {

  // Fields

  String name;
  String displayName;
  HObject owner;
  ArrayList <HObject> ownees;  




  // Constructor

  HObject( HObject o, String n ) {
    owner = o;
    name = n;
    displayName = n;
    ownees = new ArrayList();
  } // end constructor




  HObject( String n ) {
    name = n;
    displayName = n;
    ownees = new ArrayList();
  } // end constructor




 HObject( HObject o, String n, String dn ) {
    owner = o;
    name = n;
    displayName = dn;
    ownees = new ArrayList();
  } // end constructor
  



  // Constructor
  HObject( String n, String dn ) {
    name = n;
    displayName = dn;
    ownees = new ArrayList();
  } // end constructor
 



  // Methods

  boolean owns( String n ) {
  // returns true if owns an object with the name n
    // returns false if doesnt have ownees yet, or if can't find an ownee with the name n
    if( ownees != null ) {
      boolean found = false;
      for( HObject ho : ownees )
        if( ho.name.equals( n ) ) {
          found = true;
        }
      if( found )
        return true;
      else
        return false;
    } else {
      return false;
    } // end else
  } // end owns()



 
  HObject getOwner() {
    return owner;
  } // end getOwner() 




  HObject getOwnee( String n ) {
    if( ownees == null )
      return null;
    else {
      int where = -1;
      for( int i = 0; i < ownees.size(); i++ ) {
        HObject ho = ownees.get( i );
        if( ho.name.equals( n ) )
          where = i;        
      }
      if( where == -1 ) 
        return null;
      else
        return ownees.get( where );
    } // end else
  } // end getOwnee() 



  
  String getName() {
   return name; 
  }



  
  String getDisplayName() {
    return displayName; 
  }



  
} // end class HObject


// ==================================================================================

class School extends HObject {

  // Fields

  ArrayList <Teacher> teachers;




  // Constructor

  School( String n ) {
    super( n );
    teachers = new ArrayList();
    //ownees = teachers;
  }
  



  // Methods



  
} // end class School

// ===============================================================================

class Teacher extends HObject {

  // Fields

  School school;
  ArrayList <Classroom> classrooms;
  



  // Constructor

  Teacher( School o, String n ) {
    super( o, n );
    school = o;
    classrooms = new ArrayList();
    //ownees = classrooms;
  } // end constructor




  // Methods
  



} // end class Teacher

class Classroom extends HObject {
  // Fields
  String name;
  School school;
  Teacher teacher;
  ArrayList <GSActivity> gsActivities;

  // Constructor
  Classroom( Teacher o, String n ) {
    super( o, n );
    teacher = o;
    school = (School) teacher.getOwner();
    gsActivities = new ArrayList();
    //ownees = gsActivities;
  } // end constructor

  // Methods

} // end class Classroom

// ===================================================================================

class GSActivity extends HObject {

  // Fields

  String name;
  School school;
  Teacher teacher;
  Classroom classroom;
  String displayName;
  Long aid;                // activity id number



  
  // Constructor

  GSActivity( Classroom o, String n, String dn, Long a ) {
    super( o, n, dn );
    aid = a;
    classroom = o;
    teacher = ( Teacher ) classroom.getOwner();
    school = ( School ) classroom.getOwner().getOwner();    
  } // end constructor
  



  // Methods

  Long getAID() {
    return aid;
  } // end getAID()


} // end class GSActivity 
