// File for recording audio from adc
// Author: Danny Clarke

// check
string id;
if( me.args() < 1 ) {
    <<< "This file needs arguments!","" >>>; me.exit();
} else {
    me.arg(0) => id;
}

// sound chain
adc => WvOut2 out => blackhole;
out => dac;

// sound file set up
me.dir(-1) + "rec/" => string d;

d + id => out.wavFilename; // make wav file destinaion
"data/session" => out.autoPrefix;
out.fileGain( 0.8 );

// start/stop recording
1 => out.record;
<<< "recording to", out.filename(),"">>>;

while( ms => now );

0 => out.record;
out.closeFile();
