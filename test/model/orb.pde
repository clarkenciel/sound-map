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
  
  void draw( float _x, float _y, float _z ) {
    x = _x;
    y = _y;
    z = _z;
    pushMatrix();
    colorMode( HSB, 360 );
    fill( 250, 100, 150 );
    translate( x, y, z );
    sphere( size );
    popMatrix();
  }
  
  void draw() {
    pushMatrix();
    colorMode( HSB, 360 );
    fill( 250, 100, 150 );
    translate( x, y, z );
    sphere( size );
    popMatrix();
  }
}
