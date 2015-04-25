// recorder.ck
// Class that writes a sound's FFT data to file
// Author: Danny Clarke

public class Recorder extends Chubgraph {
    fun string record( string fn, dur len, OrbUpdater e ) {
        string filename;
        if( fn.find( ".wav" ) >= 0 ) 
            fn.substring( 0, fn.length() - 4 ) => filename;
        else
            fn => filename;
 
        adc => WvOut2 wv => blackhole;
        wv => FFT fft => blackhole;
        wv.wavFilename( filename );

        512 => fft.size;
        UAnaBlob blob;
        
        float res[4];
        float avg;

        now + len => time later;

        wv.record(1);
        while( now < later ) {
            fft.upchuck() @=> blob;

            for( int i; i < blob.cvals().size(); i ++ ) {
                if( i < 256 * 0.25 )
                    Math.fabs(blob.cval(i).re) +=> res[0];
                else if( i > 256 * 0.25 && i < 256 * 0.5 )
                    Math.fabs(blob.cval(i).re) +=> res[1];
                else if( i > 256 * 0.5 && i < 256 * 0.75 )
                    Math.fabs(blob.cval(i).re) +=> res[2];
                else if( i > 256 * 0.75 )
                    Math.fabs(blob.cval(i).re) +=> res[3];
            }
            second => now;
        }
        wv.record(0);
        wv.closeFile();

        for( int i; i < res.size(); i++ ) {
            res[i] / (256 * 0.25) +=> avg;
        }
        4 /=> avg;
        
        res @=> e.sig;
        avg => e.mass;
        1 => e.good;
        e.broadcast();        
        
        wv =< blackhole;
        adc =< wv;
        fft =< blackhole;
        wv =< fft;

        NULL @=> wv;
        NULL @=> fft;  
        NULL @=> res;

        return filename + ".wav";
    } 

    fun string merge( string fn, SndBuf s1, SndBuf s2, OrbUpdater e ) {
        string filename;
        dur len;
        if( fn.find( ".wav" ) >= 0 )
            fn.substring( 0, fn.length() - 4 ) => filename;
        else
            fn => filename;
 
        s1 => WvOut2 wv => blackhole;
        s2 => wv;
        wv.wavFilename( filename );
        
        s1.loop( 1 );
        s2.loop( 1 );

        if( s1.length() > s2.length() )
            s1.length() => len;
        else
            s2.length() => len;
        
        now + len => time later;
        wv.record( 1 );
        while( now < later ) second => now;
        wv.record( 0 ); 
        wv.closeFile();

        1 => e.good;
        e.broadcast();

        return filename;
    }
}
