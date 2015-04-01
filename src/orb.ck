// orb.ck
// representations of sounds in a particle system
// Author: Danny Clarke

public class Orb {
    float loc[2];
    float vel[2];

    fun void init( float _x, float _y, float _xv, float _yv ) {
        _x @=> loc[0];
        _y @=> loc[1];
        _xv @=> vel[0];
        _yv @=> vel[1]; 
    }

    fun void move() {
        add( loc, vel ); 
    }

    fun void gravitate( Orb other ) {


    }

    fun void add( float a1[], float a2[] ) {
        for( int i; i < a1.size(); i ++ ) {
            a2[i%a2.size()] +=> a1[i];
        }
    }
}
