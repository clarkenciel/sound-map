// recorder.ck
// Class that writes a sound's FFT data to file
// Author: Danny Clarke

public class Recorder {
    adc => FFT fft => dac;
    UAnaBlob blob;
    FileIO file;
    
    fun void record( string fn, dur length ) {
        // open file
        file.open( fn, FileIO.WRITE );
        
        // set up FFT
        8 => int WIN => fft.size;
        dur + now => time later;

        // record
        while( now < later ) {
            fft.upchuck() @=> blob;
            write_sample( file, blobl.cvals() ); 
            WIN::samp => now;
        } 

        // clean up
        destroy()
    }

    // record an array of complex numbers to a filename, fn
    fun void write_sample( FileIO file, complex a[] ) {
        int samp_size;

        for( int i; i < a.size(); i++ ) {
            for( int j; j < a[i].size(); j++ ) {
                file <= "[" + a[i].re <= "," + a[i].im <= "]";
            }
            file <= "\n";
            NULL @=> a;
        }
    }
    
    fun void destroy() {
        fft =< dac;
        file.close();
        NULL @=> file;
        NULL @=> fft;
        NULL @=> blob;
    }
}
