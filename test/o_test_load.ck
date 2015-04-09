me.dir(-1) + "src/" => string src;
me.dir() => string here;
Machine.add( src + "orb.ck" ) => int orb;
Machine.add( src + "orb_sys.ck" ) => int orbSys;
Machine.add( here + "orb_test.ck" ) => int test;
while( ms => now );
