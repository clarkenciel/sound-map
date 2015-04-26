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

        dac.chan(id);
    }

    fun void play( OrbUpdater ou, StopEvent e ) {
        ou => now;
        s.read( filename ); 
        s.pos( 0 );
        s.loop( 1 );
        s.rate( 1 );
        
        s.length() => length;
        s.samples() => samples;
        <<< "playing:", filename, "thru channel:",id,"">>>;
        while( e.go ) e => now; 
        s =< dac;
        NULL @=> s;
    }

    fun void play( StopEvent e ) {
        s.read( filename ); 
        s.pos( 0 );
        s.loop( 1 );
        s.rate( 1 );
        
        s.length() => length;
        s.samples() => samples;
        <<< "playing:", filename, "thru channel:",id,"">>>;
        while( e.go ) e => now; 
        s =< dac;
        NULL @=> s;
    }
    fun void destroy() {
        FileIO f;
        f.open( filename, FileIO.WRITE );
        f <= "";
        f.close();
        s =< dac;
    }  

    fun SndBuf getSound() {
        return s;
    }
} 
