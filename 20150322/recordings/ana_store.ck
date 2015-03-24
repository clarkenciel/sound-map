// ana_store.ck
// listen to audio and store FFT in external file
// Author: Danny Clarke

me.dir() => string d;
3 => float seconds;
"ana.txt" => string filename;

if( me.args() == 2 ) {
    me.arg(0) => Std.atof => seconds;
    me.arg(1) => filename;
} else if( me.args() == 1 ) {
    me.arg(0) => Std.atof => seconds;
} else {
    <<< "Run with duration:output filename","" >>>;
    me.exit();
}

FileIO f;
adc => FFT fft => blackhole;

second / samp => float srate;
8 => int WIN => fft.size;
Windowing.hann(WIN) => fft.window;

UAnaBlob blob;

now + seconds::second => time later;
int totSamps;
f.open( d + "/" + filename, FileIO.WRITE );
while( now < later ) {
    fft.upchuck() @=> blob;

    for( int i; i < blob.cvals().size(); i++ ) {
        f <= "[" <= blob.cval(i).re <= "," <= blob.cval(i).im <= "]"; // comma delimit
        //f <= blob.cval(i).re <= blob.cval(i).im <= IO.nl();
    }
    f <= "\n"; // end of an FFT
    WIN::samp => now;
    WIN +=> totSamps;
}

f <= ":" <= totSamps;
f.close();
