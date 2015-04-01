OscOut out;
out.dest( "localhost", 57120 );
out.start( "/quit" ).send();
