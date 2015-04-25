me.dir(-1) + "src" => string src;
me.dir() => string here;
Machine.add( src + "/util/load.ck" ) => int util;
Machine.add( src + "/sound-map/load.ck" ) => int map;
10::ms => now;
Machine.add( here + "orb_test.ck" ) => int test;
while( ms => now );
