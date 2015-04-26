// orb_sys.ck
// system of orbs: manage collisions and creation/destruction
// test code can be found in the test folder
// Author: Danny Clarke

public class OrbSystem {
    string filenames[0];
    float X_RANGE[2];
    float Y_RANGE[2];
    float Z_RANGE[2];
    int ORB_LIMIT;
    Orb orbs[0];
    int collisions[0][0];

    //
    // Core functions
    //
    fun void init( string fns[], int ids[] ) {
        //<<< "os_init", me.id(), "" >>>;
        fns @=> filenames;

        for( int i; i < filenames.size(); i++ ) {
            parse( ids[i], filenames[i] );
        }
    }
    
    fun int[][] update() {
        //<<< "os_update", me.id(), "" >>>;
        collisions.size(0);

        if( orbs.size() > 0 ) {
            for( int j; j < orbs.size(); j ++ ) {
                gravitate( orbs[j] );
                collChecks( orbs[j] );
                edgeCheck( orbs[j] );
                orbs[j].move();
            }
        }
        return collisions;
    }

    // should probably refactor these for vectors since I have them
    fun int createFromFile( int id, float m, float x, float y, float z, float xvel, float yvel, float zvel ) {
        if( orbs.size() + 1 <= ORB_LIMIT ) {
            orbs.size( orbs.size() + 1 );
            new Orb @=> orbs[ orbs.size() - 1 ];
            orbs[ orbs.size() - 1 ].init( id, m, x, y, z, xvel, yvel, zvel );
            return orbs.size() - 1;
        }
        return -1;
    }

    // same here
    fun void create( int id, float x, float y, float z, OrbUpdater e ) {
        //<<< "os_create", me.id(), "" >>>;
        if( orbs.size() + 1 <= ORB_LIMIT ) {
            orbs.size( orbs.size() + 1 );
            new Orb @=> orbs[ orbs.size() - 1 ];
            orbs[ orbs.size() - 1 ].init( id, 0, x, y, z, 0.0, 0.0, 0.0 );
            spork ~ updateListen( orbs[ orbs.size() - 1 ], e );
        }
    }

    fun void destroyOrbById( int id ) {
        //<<< "os_destroy_id", me.id(), "" >>>;
        getIdx(id) => int idx; 
        destroyOrbByIdx( idx ); 
    }

    fun void destroyOrbByIdx( int idx ) {
        //<<< "os_destroy_idx", me.id(), "" >>>;
        if( idx >= 0 ) {
            orbs[idx].destroy();
            for( idx => int i; i < orbs.size()-1; i++ ) {
                orbs[i+1] @=> orbs[i];
            }
            orbs.size( orbs.size() - 1 );
        }
    }

    fun Orb generateCombo( int new_id, int id1, int id2 ) {
        Orb out;
        float x_mean, y_mean, z_mean, m_tot;
        
        getIdx( id1 ) => int one_idx;
        getIdx( id2 ) => int two_idx;
        //<<< "one_idx:",one_idx,id1,"two_idx:",two_idx,id2,"">>>;

        (orbs[one_idx].loc.x() + orbs[two_idx].loc.x()) / 2.0 => x_mean; 
        (orbs[one_idx].loc.y() + orbs[two_idx].loc.y()) / 2.0 => y_mean; 
        (orbs[one_idx].loc.z() + orbs[two_idx].loc.z()) / 2.0 => z_mean; 
        orbs[one_idx].m + orbs[two_idx].m => m_tot;
        //<<< x_mean, y_mean, z_mean, "" >>>;

        out.init( new_id, m_tot, x_mean, y_mean, z_mean, 0, 0, 0 );
        
        return out;
    }

    fun void combine( int new_id, int id1, int id2, OrbUpdater e) {
        //<<< "combining", id1, "&", id2, "into", new_id, "" >>>;
        generateCombo( new_id, id1, id2 ) @=> Orb new_orb;

        //<<< "destroying orbs", id1, id2, "" >>>;
        destroyOrbById( id1 );
        //<<< "destroying orbs", id1, id2, "" >>>;
        destroyOrbById( id2 );

        //<<< "adding new orb", "" >>>;
        orbs.size( orbs.size() + 1 );
        //<<< "!", "">>>;
        new Orb @=> orbs[orbs.size()-1];
        //<<< "!!", "">>>;
        new_orb @=> orbs[orbs.size()-1];
        //<<< "!!!", "" >>>; 
        spork ~ updateListen( orbs[orbs.size()-1], e );
    }

    fun void quit() {
        for( int i; i < orbs.size();i ++ ) {
            if( orbs[i].good )
                orbs[i].write();
        }
    }

    //
    // MOTION
    //  

    fun void gravitate( Orb orb ) {
        for( int i; i < orbs.size(); i++ ) {
            if( orbs[i].good && orb.id != orbs[i].id ) 
                orb.gravitate( orbs[i] );
        }
    }

    fun void edgeCheck( Orb orb ) {
        //<<< "os_edge_check", me.id(), "" >>>;
        if( orb.loc.x() <= X_RANGE[0] + orb.m ) {
            orb.vel.setX( orb.vel.x() * -0.9 );
            orb.loc.setX( X_RANGE[0] + orb.m );
        }
        if( orb.loc.x() >= X_RANGE[1] - orb.m ) {
            orb.vel.setX( orb.vel.x() * -0.9 );
            orb.loc.setX( X_RANGE[1] - orb.m );
        }
        if( orb.loc.y() <= Y_RANGE[0] + orb.m ) {
            orb.vel.setY( orb.vel.y() * -0.9 );
            orb.loc.setY( Y_RANGE[0] + orb.m );
        }
        if( orb.loc.y() >= Y_RANGE[1] - orb.m ) {
            orb.vel.setY( orb.vel.y() * -0.9 );
            orb.loc.setY( Y_RANGE[1] - orb.m );
        }
        if( orb.loc.z() <= Z_RANGE[0] + orb.m ) {
            orb.vel.setZ( orb.vel.z() * -0.9 );
            orb.loc.setZ( Z_RANGE[0] + orb.m );
        }
        if( orb.loc.z() >= Z_RANGE[1] - orb.m ) {
            orb.vel.setZ( orb.vel.z() * -0.9 );
            orb.loc.setZ( Z_RANGE[1] - orb.m );
        }
    }

    fun void collChecks( Orb orb ) {
        //<<< "os_coll_checks", me.id(), "" >>>;

        for( int k; k < orbs.size(); k++ ) {
            if( orb.good && orbs[k].good && orb.id != orbs[k].id && orb.collCheck( orbs[k] ) ) {
                if( !inCollisions( [orb.id, orbs[k].id] ) ) {
                    collisions.size( collisions.size() + 1 );
                    [orb.id, orbs[k].id] @=> collisions[ collisions.size() - 1 ];
                }
            }
        }
    }

    //
    // File management
    //
    fun string[] getFilenames( int ids[] ) {
        string out[0];
        Orb o;
        for( int i; i < ids.size(); i++ ) {
            if( getIdx( ids[i] ) >= 0 ) {
                getOrbById( ids[i] ) @=> o;
                if( o.good )
                    out << o.filename;
            }
        }
        return out;
    }

    fun void parse( int id, string filename ) {
        FileIO f;
        f.open( filename, FileIO.READ );
        if( f.good() && f.size() > 0 ) {
            f.readLine() => string line;

            float mass, x, y, z, xvel, yvel, zvel, sig0, sig1, sig2, sig3;
            float parsed[11];

            // get mass, and location from file    
            ":" => string delim;
            int start_idx, end_idx, len, c;
            while( line.length() > 0 && start_idx < line.length() && line.find(delim, start_idx) >= 0 ) {
                line.find( delim, start_idx ) => end_idx;
                end_idx - start_idx => len;
                Std.atof( line.substring( start_idx, len ) ) => parsed[c];
                end_idx + 1 => start_idx;
                c++;
            } 
                
            // pattern matching would sure be nice here
            parsed[0] => mass;
            parsed[1] => x; parsed[2] => y; parsed[3] => z;
            parsed[4] => xvel; parsed[5] => yvel; parsed[6] => zvel;
            parsed[7] => sig0; parsed[8] => sig1; 
            parsed[9] => sig2; parsed[10] => sig3;
        
            // create orb
            createFromFile( id, mass, x, y, z, xvel, yvel, zvel ) => int nu_idx;
            if( nu_idx >= 0 ) {
                1 => orbs[nu_idx].good; 
                sig0 => orbs[nu_idx].sig[0];
                sig1 => orbs[nu_idx].sig[1]; 
                sig2 => orbs[nu_idx].sig[2]; 
                sig3 => orbs[nu_idx].sig[3]; 
            }
        }
        f.close();
    }

    //
    // Orb fetching
    //
    fun int getIdx( int id ) {
        for( int i; i < orbs.size(); i++ ) {
            if( orbs[i].id == id )
                return i;
        }
        return -1;
    }

    fun int getIdx( Orb o ) {
        for( int i; i < orbs.size(); i++ ) {
            if( orbs[i].id == o.id )
                return i;
        }
        return -1;
    }

    fun Orb getOrbById( int id ) {
        for( int i; i < orbs.size(); i++ ) {
            if( orbs[i].id == id )
                return orbs[i];
        }
        return NULL;
    }

    fun Orb getOrbByIdx( int id ) { 
        //<<< "os_get_idx", me.id(), "" >>>;
        for( int i; i < orbs.size(); i ++ ) {
            if( orbs[i].id == id )
                return orbs[i];
        }
        return NULL;
    }

    fun Orb[] getOrbs() {
        Orb out[0];
        for( int i; i < orbs.size(); i++ ) {
            if( orbs[i].good ) {
                out.size( out.size() + 1 );
                orbs[i] @=> out[ out.size() - 1 ];
            }
        } 
        return out;
    }

    //
    // Misc. Support
    //
    fun void updateListen( Orb o, OrbUpdater e ) {
        <<< "waiting for update", "" >>>;
        e => now;
        e.good => o.good;
        <<< "updating...","" >>>;
        if( e.mass > 0 )
            e.mass * 10000 @=> o.m;
        if( e.sig[0] > 0 )
            e.sig[0] @=> o.sig[0];
        if( e.sig[1] > 0 )
            e.sig[1] @=> o.sig[1];
        if( e.sig[2] > 0 )
            e.sig[2] @=> o.sig[2];
        if( e.sig[3] > o.sig[3] )
            e.sig[3] @=> o.sig[3];
        0 => e.good;
        e.response.broadcast();
    }

    fun int inCollisions( int a[] ) {
        int sum;
        for( int i; i < collisions.size(); i++ ) {
            if( a[0] == collisions[i][0] || a[0] == collisions[i][1] )
                sum ++;
            if( a[1] == collisions[i][0] || a[1] == collisions[i][1] )
                sum ++;
            if( sum == 2 )
                return 1;
        }
        return 0;
    }
}
