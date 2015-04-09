class Orb {
  int id;
  float size, x, y;
  
  Orb ( int _id, float _m, float _x, float _y ) {
    id = _id;
    size = _m;
    x = _x;
    y = _y;
  }
  
  void draw( float _x, float _y ) {
    x = _x;
    y = _y;
    pushMatrix();
    colorMode( HSB, 360 );
    fill( 250, 100, 150 );
    ellipse( x, y, size, size );
    popMatrix();
  }
  
  void draw() {
    pushMatrix();
    colorMode( HSB, 360 );
    fill( 250, 100, 150 );
    ellipse( x, y, size, size );
    popMatrix();
  }
    
}
