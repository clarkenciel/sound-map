OscOut out;
out.dest( "localhost", 57120 );
out.start( "/session/quit" ).send();
