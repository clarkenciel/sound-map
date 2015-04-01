// main.ck
// the core program, equivalent to main() in c/c++
// Author: Danny Clarke

OscOut out;
out.dest( "localhost", 57121 );
Session s;

s.init();
spork ~ s.input_listen();

while( !s.kill ) ms => now;

out.start( "/quit" );
out.send();
