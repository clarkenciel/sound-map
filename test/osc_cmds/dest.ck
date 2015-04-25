OscOut out;
out.dest( "localhost", 57120 );

if( me.args() )
    out.start("/destroy").add(Std.atoi(me.arg(0))).send();
