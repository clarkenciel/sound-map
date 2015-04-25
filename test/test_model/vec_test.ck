Vector v;
Test t;

fun void test_init() {
    v.init(1,2);
    t.assert_equal( "two-arg init", 1, v.x() );
    t.assert_equal( "two-arg init", 2, v.y() );

    v.init(2, 3, 4);
    t.assert_equal( "three-arg init", 2, v.x() );
    t.assert_equal( "three-arg init", 3, v.y() );
    t.assert_equal( "three-arg init", 4, v.z() );
}

fun void test_set() {
    1 => int i_one;
    1.0 => float f_one;

    v.setX( i_one );
    v.setY( i_one );
    v.setZ( i_one );
    t.assert_equal( "integer set", i_one, v.x() );
    t.assert_equal( "integer set", i_one, v.y() );
    t.assert_equal( "integer set", i_one, v.z() );

    v.setX( f_one );
    v.setY( f_one );
    v.setZ( f_one );
    t.assert_equal( "float set", f_one, v.x() );
    t.assert_equal( "float set", f_one, v.y() );
    t.assert_equal( "float set", f_one, v.z() );
}

fun void test_add() {
    Vector v2;
    v2.init( 2, -2, 0 );
    v.init( 0, 0, 0 );
    v.add( v2 );

    t.assert_equal( "add vector", 2, v.x() );
    t.assert_equal( "add vector", -2, v.y() );
    t.assert_equal( "add vector", 0, v.z() );
    
    NULL @=> v2;
}

fun void test_sub() {
    Vector v2;
    v2.init( 1, -2, 0 );
    v.init( 0, 1, -2 );
    v.sub( v2 );
    
    t.assert_equal( "sub vec", -1, v.x() );
    t.assert_equal( "sub vec", 3, v.y() );
    t.assert_equal( "sub vec", -1, v.z() );

    NULL @=> v2;
}

fun void test_mult() {
    2.0 => float two;
    -2.0 => float neg_two;
    0.0 => float zero;

    v.init( 0, 1, -2 );
    v.mult( two );

    t.assert_equal( "mult scalar", 0, v.x() );
    t.assert_equal( "mult scalar", 2.0, v.y() );
    t.assert_equal( "mult scalar", -4.0, v.z() );

    v.mult( neg_two );

    t.assert_equal( "mult scalar", 0, v.x() );
    t.assert_equal( "mult scalar", -4.0, v.y() );
    t.assert_equal( "mult scalar", 8.0, v.z() );
    
    v.mult( zero );

    t.assert_equal( "mult scalar", 0, v.x() );
    t.assert_equal( "mult scalar", 0, v.y() );
    t.assert_equal( "mult scalar", 0, v.z() );
}

fun void test_dist() {
    Vector v2;
    v2.init( 0, 1, -1 );
    v.init( 1, 2, 3 );
    v.dist( v2 ) => float dist;
    Math.sqrt(
        Math.pow( v2.x() - v.x(), 2 ) +
        Math.pow( v2.y() - v.y(), 2 ) +
        Math.pow( v2.z() - v.z(), 2 )
    ) => float test;
    
    t.assert_equal( "distance", test, dist );
}

fun void test_mag() {
    v.init(1, 1, 1);
    v.setMag( 0 );
    t.assert_equal( "set mag", 0, v.mag() );
    v.setMag(100);
    t.assert_equal( "set mag", 100, v.mag() );
}

fun void test_generate() {
    Vector v2;
    v2.init( 1, 1, 1 );
    v.init( 1, 1, 1 );

    v.generate_sum( v2 ) @=> Vector v3;
    v.generate_diff( v2 ) @=> Vector v4;
    v.generate_div( 2 ) @=> Vector v5;
    
    t.assert_equal( "generate sum", [2, 2, 2], [v3.x(), v3.y(), v3.z()] );
    t.assert_equal( "generate diff", [0,0,0], [v3.x(), v3.y(), v3.z()] );
    t.assert_equal( "generate div", [1, 1, 1], [v3.x(), v3.y(), v3.z()] );
}
