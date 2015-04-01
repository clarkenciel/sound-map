OscOut out;

if( me.args() ) {
    out.dest( "localhost", 57120 );
    out.start( "/record" );
    out.send();
    out.dest( "localhost", 57121 );
    out.start( "/record" );
    out.send();
}
