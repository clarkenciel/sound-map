OscIn in;
OscMsg m;
in.port( 57121 );
in.listenAll();

while( true ) {
    in => now;
    while( in.recv( m ) ) {
            <<< "Receiving orb info!", "" >>>;
            <<< "Orb id:", m.getInt(0), "" >>>;
            <<< "Orb mass:", m.getFloat(1), "" >>>;
            <<< "Orb location:", m.getFloat(2), m.getFloat(3), m.getFloat(4), "" >>>;
        if(m.address.find("dest") > 0)
            <<< "\n\nDESTROY\n\n", "" >>>;
    }
} 
