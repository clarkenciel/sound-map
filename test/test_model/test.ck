public class Test {
    // Equality
    fun void assert_equal( string msg, float one, float two ) {
        if( one != two ) {
            <<< msg, "" >>>;
            <<< one, "does not equal", two, "" >>>;
            me.exit();
        }
    }

    fun void assert_equal( string msg, int one, int two ) {
        assert_equal( msg, one $ float, two $ float );
    }
    
    fun void assert_equal( string msg, int one, float two ) {
        assert_equal( msg, one $ float, two );
    }
    
    fun void assert_equal( string msg, float one, int two ) {
        assert_equal( msg, one, two $ float );
    }

    fun void assert_equal( string msg, float test[], float arr[] ) {
        assert_equal( "testing array sizes", test.size(), arr.size() );
        for( int i; i < arr.size(); i++ ) {
            assert_equal( msg, test[i], arr[i] );
        }
    }

    fun void assert_equal( string msg, int test[], float arr[] ) {
        assert_equal( "testing array sizes", test.size(), arr.size() );
        for( int i; i < arr.size(); i++ ) {
            assert_equal( msg, test[i], arr[i] );
        }
    }

    fun void assert_equal( string msg, float test[], int arr[] ) {
        assert_equal( "testing array sizes", test.size(), arr.size() );
        for( int i; i < arr.size(); i++ ) {
            assert_equal( msg, test[i], arr[i]);
        }
    }
    fun void assert_equal( string msg, int test[], int arr[] ) {
        assert_equal( "testing array sizes", test.size(), arr.size() );
        for( int i; i < arr.size(); i++ ) {
            assert_equal( msg, test[i], arr[i] );
        }
    }
}

