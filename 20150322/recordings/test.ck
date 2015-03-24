// test.ck
// test the ana_store/read/comb scripts
// Author: Danny Clarke

int id, len, store, read, comb;
3 => len;
me.dir() => string d;
"ana" => string name;
".txt" => string stem;

if( me.args() == 1 ) {
    me.arg(0) => Std.atoi => len;
}

dac => WvOut2 wv => blackhole;
wv.wavFilename( "test" );

wv.record(1);
for( int i; i < 100; i++ ) {
    i => id;
    if( i % 3 == 2 ) {
        Machine.add( d + "ana_comb:"+name+(id-2)+stem+":"+name+(id-1)+stem+":"+name+id+stem ) => comb;
        (len+1)::second => now;
        Machine.add( d + "ana_read:"+name+id+stem ) => read;
        (len+1)::second => now;
    } else {
        Machine.add( d + "ana_store:"+len+":"+name+id+stem ) => store;
        (len+1)::second => now;
    }
}
wv.record(0);
wv.closeFile();
