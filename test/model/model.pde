import oscP5.*;
import netP5.*;

OscP5 in;
ArrayList<Orb> orbs;
Orb orb;

void setup() {
  size( 500, 500, P3D );
  orbs = new ArrayList<Orb>();
  in = new OscP5( this, 13000 );
  in.plug( this, "move",  "/orb/move" );
  in.plug( this, "create", "/orb/create" );
  in.plug( this, "destroy", "/orb/destroy" );
  //background(0);
  draw_bg();
}

void draw() {}

void move( int id, float m, float x, float y, float z ) {
  orb = find_orb( id );
  for( int i = 0; i < orbs.size(); i++ ) {
    orb = orbs.get(i);
    if( orb.id == id ) {
      orb.draw( x, y, z );
    } else {
      orb.draw();
    }
  }
  draw_bg();
}

void create( int id, float m, float x, float y, float z ) {
  orb = find_orb( id );
  if( orb == null ) {
    println( "create!" );
    orb = new Orb( id, m, x, y, z );
    orb.draw();
    orbs.add( orb );
  }
}

void destroy( int id ) {
  println("destroy!", id);
  orb = find_orb( id );
  orbs.remove(orb);  
}

Orb find_orb( int id ) {
  Orb orb;
  
  for( int i = 0; i < orbs.size(); i ++ ) {
    orb = orbs.get(i);
    if( orb.id == id ) {
      return orb;
    }
  }
  return null;
}

void draw_bg() {
  pushMatrix();
  colorMode( HSB, 360 );
  fill( 10, 5 );
  noStroke();
  rect( 0, 0, width, height );
  popMatrix();
}
