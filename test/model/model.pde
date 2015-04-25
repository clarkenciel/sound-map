import oscP5.*;
import netP5.*;

OscP5 in;
ArrayList<Orb> orbs;
Orb orb;

void setup() {
  size( 500, 500, P3D );
  orbs = new ArrayList<Orb>();
  in = new OscP5( this, 13000 );
  lights();
  //in.plug( this, "move",  "/orb/move" );
  //in.plug( this, "create", "/orb/create" );
  //in.plug( this, "destroy", "/orb/destroy" );
  //background(0);
  //draw_bg();
}

void draw() {}

void oscEvent( OscMessage msg ) {
  int id;
  float m, x, y, z;
  if( msg.checkAddrPattern("/orb/create") == true ) {
    if( msg.checkTypetag( "iffff" ) ) {
      id = msg.get(0).intValue();
      m = msg.get(1).floatValue();
      x = msg.get(2).floatValue();
      y = msg.get(3).floatValue();
      z = msg.get(4).floatValue();

      println( "create: ",id,m,x,y,z );
      orb = find_orb( id );
      if( orb.id == -1) {
        //println( "create!" );
        orb = new Orb( id, m, x, y, z );
        println("drawing:", orb.x,orb.y, orb.z );
        orb.draw_no();
        println("adding:", orb.id);
        orbs.add( orb );
      }
    }
    return;
  }
  if( msg.checkAddrPattern("/orb/move") == true ) {
    if( msg.checkTypetag( "iffff" ) ) {
      id = msg.get(0).intValue();
      m = msg.get(1).floatValue();
      x = msg.get(2).floatValue();
      y = msg.get(3).floatValue();
      z = msg.get(4).floatValue();
      println( "move: ",id,m,x,y,z );
      for( int i = 0; i < orbs.size(); i++ ) {
        orb = orbs.get(i);
        if( orb.id == id ) {
          println("drawing:", x, y, z );
          orb.draw( x, y, z );
        } else {
          println("drawing:", orb.x,orb.y, orb.z );
          orb.draw_no();
        }
      }
      //draw_bg();
    }
    return;
  } 
  if( msg.checkAddrPattern("/orb/destroy") == true ) {
    id = msg.get(0).intValue();
    println( "destroy: ", id );
    orb = find_orb(id);
    orbs.remove(orb);
    return;
  }
  return;
}

/*
void move( int id, float m, float x, float y ) {
  orb = find_orb( id );
  for( int i = 0; i < orbs.size(); i++ ) {
    orb = orbs.get(i);
    if( orb.id == id ) {
      println("drawing:", x, y );
      //orb.draw( x, y, z );
    } else {
      println("drawing:", x, y );
      //orb.draw();
    }
  }
  draw_bg();
  return;
}

void create( int id, float m, float x, float y) {
  orb = find_orb( id );
  if( orb.id > -1) {
    //println( "create!" );
    orb = new Orb( id, m, x, y);
    println("drawing:", x, y );
    //orb.draw();
    println("adding:", orb.id);
    orbs.add( orb );
  }
  return;
}

void destroy( int id ) {
  //println("destroy!", id);
  orb = find_orb( id );
  orbs.remove(orb);  
  return;
}
*/
Orb find_orb( int id ) {
  Orb orb;
  
  for( int i = 0; i < orbs.size(); i ++ ) {
    orb = orbs.get(i);
    if( orb.id == id ) {
      return orb;
    }
  }
  orb = new Orb(-1,0,0,0,0);
  return orb;
}

void draw_bg() {
  background(0);
  /*
  pushMatrix();
  colorMode( HSB, 360 );
  fill( 10, 5 );
  noStroke();
  rect( 0, 0, width, height );
  popMatrix();
  */
}
