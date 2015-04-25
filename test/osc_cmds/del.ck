OscOut out;
out.dest( "localhost", 57120 );

if( me.args() ) 
    out.start("/delete").add(Std.atoi(me.arg(0))).send();
