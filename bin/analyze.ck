// ChucK Script to do sound analysis on a recording
// Author: Danny Clarke

// check
string id;
if( me.args() < 1 ) {
    <<< "This file needs arguments!","" >>>; me.exit();
} else {
    me.arg(0) => id;
}

// File setup
me.dir(-1) + "ana/" => string d;
d + id + ".txt" => string filename;
FileIO f; 
f.open( filename, FileIO.WRITE );

// Read in the sound file
SndBuf s => FFT fft => blackhole;

// Do analysis


// Close file
f.close();
