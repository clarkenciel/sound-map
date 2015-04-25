// sound.ck
// class that reads a file and plays an IFFT of the file
// Author: Danny Clarke

public class Sound extends Chubgraph {
    int id;
    string filename;
    float samples;
    dur length;

    SndBuf s => dac;
    
    fun void init( string fn, int _id ) {    
        _id => id;
        fn => filename;
        s.read( fn );
        s.pos( 0 );
        s.loop( 1 );
        s.rate( 1 );
        
        s.length() => length;
        s.samples() => samples;

        dac.chan(id);
    }

    fun void play( StopEvent e ) {
        while( e.go ) e => now; 
        s =< dac;
        NULL @=> s;
    }

    fun void destroy() {
        FileIO f;
        f.open( filename, FileIO.WRITE );
        f <= "";
        s =< dac;
        NULL @=> s;
    }  

    fun SndBuf getSound() {
        return s;
    }
} 
