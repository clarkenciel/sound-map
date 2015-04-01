// recorder.ck
// Class that writes a sound's FFT data to file
// Author: Danny Clarke

public class Recorder {
    adc => FFT fft => blackhole;
    UAnaBlob blob;
    FileIO file;
    
    fun void record( string fn, dur length ) {
        <<< "Creating sound @:", fn,"">>>;
        int samp_count;
        // open file
        file.open( fn, FileIO.WRITE );
        
        // set up FFT
        8 => int WIN => fft.size;
        length + now => time later;

        // record
        while( now < later ) {
            fft.upchuck() @=> blob;
            write_sample( file, blob.cvals() ); 
            WIN::samp => now;
            samp_count++;
        } 
        file <= ":"+samp_count;

        file.close();
        // clean up
        //destroy();
    }

    // record an array of complex numbers to a filename, fn
    fun void write_sample( FileIO file, complex a[] ) {
        int samp_size;

        for( int i; i < a.size(); i++ ) {
            file <= "[" + a[i].re <= "," + a[i].im <= "]";
        }
        file <= "\n";
        NULL @=> a;
    }
    
    fun void destroy() {
        fft =< blackhole;
        NULL @=> file;
        NULL @=> fft;
        NULL @=> blob;
    }
}
