// vector.ck
// port of PVector from Processing
// Author: Danny Clarke

public class Vector {
    private float coords[0];

    fun void init( float _x, float _y, float _z ) {
        coords.size(3);
        [_x, _y, _z] @=> coords;
    }

    fun void init( float _x, float _y ) {
        coords.size(3);
        [_x,_y, 0] @=> coords;
    }
    
    fun float x() {
        return coords[0];
    }

    fun float y() {
        return coords[1];
    }

    fun float z() {
        if( coords.size() == 3 )
            return coords[2];
        else
            return 0;
    }

    fun void setX( float f ) {
        f => coords[0];
    }

    fun void setY( float f ) {
        f => coords[1];
    }

    fun void setZ( float f ) {
        f => coords[2];
    }

    fun void add( Vector v ) {
        v.x() +=> coords[0];
        v.y() +=> coords[1];
        v.z() +=> coords[2];
    }

    fun void sub( Vector v ) {
        coords[0] - v.x() => coords[0];
        coords[1] - v.y() => coords[1];
        coords[2] - v.z() => coords[2];
    }

    fun void mult( float f ) {
        f *=> coords[0];
        f *=> coords[1];
        f *=> coords[2];
    }

    fun void div( float f ) {
        f /=> coords[0];
        f /=> coords[1];
        f /=> coords[2];
    }

    fun float dist( Vector v ) {
        v.x() - coords[0] => float a; 
        v.y() - coords[1] => float b;
        v.z() - coords[2] => float c;
        Math.pow(a, 2) => a;
        Math.pow(b, 2) => b;
        Math.pow(c, 2) => c;
        Math.sqrt( a + b + c ) => c; 
        return c;
    }

    fun float mag() {
        Math.pow(coords[0]) => float out_x;
        Math.pow(coords[1]) => float out_y;
        Math.pow(coords[2]) => float out_z;
        Math.sqrt(out_x + out_y + out_z) => out_z;
        return out_z;
    }

    // hmmmmm.....
    fun void setMag( float f ) {

    }

    fun Vector generate_sum( Vector v ) {
        v.x() + coords[0] => float new_x;
        v.y() + coords[1] => float new_y;
        v.z() + coords[2] => float new_z;
        Vector out_v;
        out_v.init(new_x, new_y, new_z);
        return out_v;
    }

    fun Vector generate_diff( Vector v ) {
        coords[0] - v.x() => float new_x;
        coords[1] - v.y() => float new_y;
        coords[2] - v.z() => float new_z;
        Vector v_out;
        v_out.init(new_x, new_y, new_z);
        return v_out;
    }

    fun Vector generate_div( Vector v, float f ) {
        v.x() / f => new_x;
        v.y() / f => new_y;
        v.z() / f => new_z;
        Vector new_v;
        new_v.init(new_x, new_y, new_z);
        return new_v;
    }
}
