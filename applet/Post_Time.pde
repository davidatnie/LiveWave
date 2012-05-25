// a utility class to convert time ( when a contribution was posted ) from String input
// into Post_Time format. Used by both the Wave and the Spiral viz

class Post_Time {
  // Holds posting time data in hh:mm:ss format
  // Constructed by passing the post time of a function and the starting time of that exercise
  
  // Fields
  int postH,postM,postS;
  int startH, startM, startS;
  int h, m, s;

// Constructor for Post_Time  
Post_Time (int tempPostTime, String startTime) {
  postM= floor(tempPostTime/60);
  postH = floor(postM/60);
  postS = tempPostTime%60;
  if ( (startTime.charAt(2) == ':') && (startTime.length() == 8)) {
    startH = int(startTime.charAt(0)-'0')*10 + int(+startTime.charAt(1)-'0');
    startM = int(startTime.charAt(3)-'0')*10 + int(+startTime.charAt(4)-'0');
    startS = int(startTime.charAt(6)-'0')*10 + int(+startTime.charAt(7)-'0');
  } else {
    startH = 0;
    startM = 0;
    startS = 0;
  }
  
  // for positive timing
  s = postS + startS;
  m = postM + startM;
  h = postH + startH;
  
  // for negative timing
  if (s <0) {
    s = 60+s;
    m--;
  }
  if (m<0) {
    m = 60+m;
    h--;
  }
  
  // convert to 24h 60m 60s format
  if (s >=60) {
    m+=floor(s/60); 
    s %= 60;
    
  } 
  
  if (m >= 60) {
    h+=floor(m/60);
    m %= 60;
    
  }
  
} // end Post_Time constructor 

String getPost_Time() {
  return (nf(h,2)+":"+nf(m,2)+":"+nf(s,2));
}

String getPost_Time_Mins() {
  return (nf(m,2)+":"+nf(s,2));
}




  String toString() {
    return( getPost_Time() );    
  } // end toString()

} // end of Post_Time class

