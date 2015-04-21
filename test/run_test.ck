me.dir() => string d;
me.dir(1) => string home;

Machine.add( home + "src/util/load.ck" );
Machine.add( home + "src/sound-map/load.ck" );
10::ms => now;
Machine.add( d + "test.ck" ) => int test_class;
Machine.add( d + "vec_test.ck" ) => int vector_test;
