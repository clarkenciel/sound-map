OscIn in;
OscMsg m;
in.port( 57121 );
in.addAddress( "/orb/update" );

while( true ) {
    in => now;
    while( in.recv( m ) ) {
        <<< "Receiving orb info!", "" >>>;
        <<< "Orb id:", m.getInt(0), "" >>>;
        <<< "Orb mass:", m.getFloat(1), "" >>>;
        <<< "Orb location:", m.getFloat(2), m.getFloat(3), m.getFloat(4), "" >>>;
    }
} 
