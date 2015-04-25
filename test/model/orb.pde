class Orb {
  int id;
  float size, x, y, z;
  
  Orb ( int _id, float _m, float _x, float _y, float _z ) {
    id = _id;
    size = _m;
    x = _x;
    y = _y;
    z = _z;
  }
  
  Orb( int _id, float _m, float _x, float _y ) {
    id = _id;
    size = _m;
    x = _x;
    y = _y;
    z = 0;
  }
  
  void draw( float _x, float _y, float _z ) {
    x = _x;
    y = _y;
    z = _z;
    println( "draw:",x,y,z);
    pushMatrix();
    //colorMode( HSB, 360 );
    //fill( 250, 100, 150 );
    translate( x, y, z );
    sphere( size );
    popMatrix();
  }
  
  void draw_no() {
    pushMatrix();
    //colorMode( HSB, 360 );
    //fill( 250, 100, 150 );
    translate( x, y, z );
    sphere( size );
    popMatrix();
  }
}
