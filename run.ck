me.dir() => string d;
d + "src/" => string src;
1 => int run;

Machine.add( src + "util/load.ck" ) => int util;
Machine.add( src + "sound-map/load.ck" ) => int classes;
second => now;
Machine.add( src + "main.ck" ) => int main;

spork ~ quit_listen();

while( run ) ms => now;

fun void quit_listen() {
    OscIn in;
    OscMsg msg;
    in.port( 57122 );
    in.addAddress( "/quit" );
    
    while( true ) {
        in => now;
        while( in.recv( msg ) ) {
            <<< "run.ck quitting","">>>;
            0 => run;
        }
    }
}

