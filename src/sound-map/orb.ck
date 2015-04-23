// orb.ck
// representations of sounds in a particle system
// test code can be found in the test folder
// Author: Danny Clarke

public class Orb {
    OscOut out;
    out.dest( "localhost", 13000 );
    me.dir(2) + "/orbs/" => string dir;

    int id;
    float m;
    Vector loc, vel, accel;
    6.018 * Math.pow( 10, -5 ) => float g_const;

    fun void init( int _id, float _m, 
                    float _x, float _y, float _z, 
                    float _xv, float _yv, float _zv ) {
        //<<< "orb_init", me.id(), "" >>>;
        _id => id; 
        _m => m;
        loc.init( _x, _y, _z );
        vel.init( _xv, _yv, _zv );
        accel.init( 0.0, 0.0, 0.0 );
        send( "/orb/create" );
    }

    fun void write() {
        FileIO f;
        f.open( dir + id + ".orb", FileIO.WRITE );
        f <= loc.x()+":"+loc.y()+":"+loc.z()+":"+vel.x()+":"+vel.y()+":"+vel.z()+":";
        f.close();
    }

    fun void move() {
        //<<< "orb_move", me.id(), "" >>>;
        vel.add( accel );
        loc.add( vel );
        send("/orb/move");

        accel.mult( 0 );
        vel.mult( 0.5 );
    }

    // Taken from Daniel Shiffman's gravity example
    fun void gravitate( Orb other ) {
        //<<< "orb_grav", me.id(), "" >>>;
        //<<< id+" loc: ", loc[0], loc[1], other.id+" loc: ", other.loc[0], other.loc[1], "" >>>;
        loc.generate_diff( other.loc ) @=> Vector force; 
        force.mag() => float dist;
        (g_const * m * other.m) / (dist * dist) => float strength;
        force.setMag( strength );
        
        other.apply_force( force );
    }
    
    fun void apply_force( Vector v ) {
        v.generate_div( m ) @=> Vector f;
        accel.add( f );
    }

    fun void change_dir() {
        //<<< "orb_change", me.id(), "" >>>;
        vel.mult( -1.0 );
    }

    // return true or false if the distance from a vector < mass 
    fun int coll_check( Vector v ) {
        //<<< "orb_coll_check", me.id(), "" >>>;
        if( loc.dist( v ) <= m ) 
            return 1;
        else
            return 0;         
    }

    fun void send( string addr ) {
        //<<< "orb_send", me.id(), "" >>>;
        <<< addr,id, "" >>>;
        out.start( addr ).add( id ).add( m ).add( loc.x() ).add( loc.y() ).add( loc.z() ).send();
    }

    fun void destroy() {
        //<<< "orb_destroy", me.id(), "" >>>;
        out.start( "/orb/destroy" ).add( id ).send();
        NULL @=> out;
    } 
}
