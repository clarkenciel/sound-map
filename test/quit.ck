OscOut out;

if( me.args() ) {
    out.dest( "localhost", 57120 );
    out.start( "/quit" ).send();
    out.dest( "localhost", 57121 );
    out.start( "/quit" ).send();
}
