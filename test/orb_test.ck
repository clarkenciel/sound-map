<<< "orb_test.ck", me.id(), "" >>>;
OrbSystem os;
os.init( [0.0, 500.0], [0.0, 500.0], 20 );
now + 2::second => time later;

while( 0.016::second => now ) {
    if( now > later ) {
        os.create_orb( Math.random2f( 10, 30 ), 
                       Math.random2f(0, 500), 
                       Math.random2(0, 500) );
        now + 2::second => later;
    }
    os.update();
}
