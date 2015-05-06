// orb.ck
// representations of sounds in a particle system
// test code can be found in the test folder
// Author: Danny Clarke

public class Orb {
    me.dir(2) + "orbs/" => string dir;

    int id, good;
    string filename;
    float m;
    float sig[4];
    Vector loc, vel, accel;
    6.018 * Math.pow( 10, 2 ) => float g_const;

    fun void init( int _id, float _m, 
                    float _x, float _y, float _z, 
                    float _xv, float _yv, float _zv ) {
        //<<< "orb_init", me.id(), "" >>>;
        _id => id; 
        _m => m;
        loc.init( _x, _y, _z );
        vel.init( _xv, _yv, _zv );
        accel.init( 0.0, 0.0, 0.0 );
        dir + id + ".orb" => filename;
        <<< "orb",id,"mass:",m,"initialized at:",loc.x(),loc.y(),loc.z(),vel.x(),vel.y(),vel.z(),"" >>>;
    }

    fun void write() {
        FileIO f;
        f.open( filename, FileIO.WRITE );
        f <= m+":"+loc.x()+":"+loc.y()+":"+loc.z()+":"+vel.x()+":"+vel.y()+":"+vel.z()+":"+sig[0]+":"+sig[1]+":"+sig[2]+":"+sig[3];
        f.close();
    }

    fun void move() {
        //<<< "orb_move", me.id(), "" >>>;
        vel.add( accel );
        loc.add( vel );

        accel.mult( 0 );
        vel.mult( 0.5 );
    }

    // Taken from Daniel Shiffman's gravity example
    fun void gravitate( Orb other ) {
        //<<< "orb_grav", me.id(), "" >>>;
        loc.generateDiff( other.loc ) @=> Vector force; 
        force.mag() => float dist;
        (g_const * m * other.m) / (dist * dist) => float strength;
        force.setMag( strength );
        
        other.applyForce( force );
    }
    
    fun void applyForce( Vector v ) {
        v.generateDiv( m ) @=> Vector f;
        accel.add( f );
    }

    fun void changeDir() {
        //<<< "orb_change", me.id(), "" >>>;
        vel.mult( -1.0 );
    }

    // return true or false if the distance from a vector < mass 
    fun int collCheck( Orb o ) {
        //<<< "orb_coll_check", me.id(), "" >>>;
        if( loc.dist( o.loc ) < o.m + m )
            return 1;
        else
            return 0;         
    }

    fun int destroy() {
        NULL @=> loc;  
        NULL @=> vel;
        NULL @=> accel;
        NULL @=> sig;
    }
}
