// play_ra.ck
// play a recording given by argument
// Author: Danny Clarke

// file setup
string filename;
int chan;
if( me.args() ) {
    me.arg(0) => filename;
    me.arg(1) => Std.atoi => chan;
} else {
    <<< "Please try again with a wav filename, and a channel number as arguments","" >>>;
    me.exit();
}

// sound chain
SndBuf bf => dac;
dac.chan( chan );
bf.read( filename );
bf.pos( 0 );
bf.loop( 1 );

while( ms => now );
