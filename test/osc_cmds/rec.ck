OscOut out;
out.dest( "localhost", 57120 );
out.start( "/session/record" );
out.add( Math.random2f( 250, 500 ) );
out.add( Math.random2f( 250, 500 ) );
out.add( Math.random2f( -100, 100 ) );
out.send();
