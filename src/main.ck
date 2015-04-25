// main.ck
// the core program, equivalent to main() in c/c++
// Author: Danny Clarke

OscOut out;
out.dest( "localhost", 57122 );
Session s;

s.init( 20 );
spork ~ s.listen();
spork ~ s.loop();

while( !s.kill ) ms => now;

out.start( "/quit" );
out.send();
