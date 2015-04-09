// orb.ck
// representations of sounds in a particle system
// test code can be found in the test folder
// Author: Danny Clarke

public class Orb {
    OscOut out;
    out.dest( "localhost", 13000 );
    int id;
    float loc[2];
    float vel[2];
    float m;
    6.018 * Math.pow( 10, -5 ) => float g_const;

    fun void init( int _id,
                   float _m, float _x, float _y, float _xv, float _yv ) {
        //<<< "orb_init", me.id(), "" >>>;
        _id => id; 
        _m => m;
        _x @=> loc[0];
        _y @=> loc[1];
        _xv @=> vel[0];
        _yv @=> vel[1]; 
        send( "/orb/create" );
    }

    fun void move() {
        //<<< "orb_move", me.id(), "" >>>;
        add( loc, vel ); 
        send("/orb/move");
        0.5 *=> vel[0]; 
        0.5 *=> vel[1];
    }

    // TODO: figure this out!
    fun void gravitate( Orb other ) {
        //<<< "orb_grav", me.id(), "" >>>;
        //<<< id+" loc: ", loc[0], loc[1], other.id+" loc: ", other.loc[0], other.loc[1], "" >>>;
        dist_vec( other.loc ) @=> float distance[];
        dist( other.loc ) => float d_mag;
        other.m / d_mag => float attraction;
        g_const *=> attraction;
        attraction *=> distance[0];
        attraction *=> distance[1];
        distance[0] +=> vel[0];
        distance[1] +=> vel[1];
    }

    fun void change_dir() {
        //<<< "orb_change", me.id(), "" >>>;
        -1.0 *=> vel[0];
        -1.0 *=> vel[1];
    }

    // return true or false if the distance from a vector < mass 
    fun int coll_check( float vec[] ) {
        //<<< "orb_coll_check", me.id(), "" >>>;
        if( dist(vec) <= m ) 
            return 1;
        else
            return 0;         
    }

    fun float dist( float vec[] ) {
        //<<< "orb_get_dist", me.id(), "" >>>;
        float a, b, c;
        vec[0] - loc[0] => a;
        vec[1] - loc[1] => b;
        Math.sqrt( Math.pow(a,2) + Math.pow(b,2) ) => c;
        return c;
    }

    fun float[] dist_vec( float vec[] ) {
        float a, b;
        vec[0] - loc[0] => a;
        vec[1] - loc[1] => b;
        return [a, b];
    }

    fun void add( float a1[], float a2[] ) {
        //<<< "orb_vec_add", me.id(), "" >>>;
        for( int i; i < a1.size(); i ++ ) {
            a2[i%a2.size()] +=> a1[i];
        }
    }

    fun void send( string addr ) {
        //<<< "orb_send", me.id(), "" >>>;
        out.start( addr ).add( id ).add( m ).add( loc[0] ).add( loc[1] ).send();
    }

    fun void destroy() {
        //<<< "orb_destroy", me.id(), "" >>>;
        out.start( "/orb/destroy" ).add( id ).send();
        NULL @=> out;
    } 
}
