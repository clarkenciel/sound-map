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

    fun void init( string fns[], int ids[], float xr[], float yr[], float zr[], int ol ) {
        //<<< "os_init", me.id(), "" >>>;
        xr[0] => X_RANGE[0];
        xr[1] => X_RANGE[1];
        yr[0] => Y_RANGE[0];
        yr[1] => Y_RANGE[1];
        zr[0] => Z_RANGE[0];
        zr[1] => Z_RANGE[1];
        ol => ORB_LIMIT;
    
        fns @=> filenames;

        for( int i; i < filenames.size(); i++ ) {
            parse( ids[i], filenames[i] );
        }
    }
    
    fun string[] get_fns() {
        return filenames;
    }

    fun void parse( int id, string filename ) {
        string line;
        float mass, x, y, z;

        // get mass, and location form file    
        
        // create orb
        create_orb( id, mass, x, y, z );
    }

    fun void write( Orb o ) {
        o.write();
    }

    fun void update() {
        //<<< "os_update", me.id(), "" >>>;
        if( orbs.size() > 0 ) {
            for( int j; j < orbs.size(); j ++ ) {
                gravitate( orbs[j] );
                coll_checks( orbs[j] );
                edge_check( orbs[j] );
                orbs[j].move();
            }
        }
    }

    fun void create_orb( int id, float m, float x, float y, float z ) {
        //<<< "os_create", me.id(), "" >>>;
        if( orbs.size() + 1 <= ORB_LIMIT ) {
            orbs.size( orbs.size() + 1 );
            new Orb @=> orbs[ orbs.size() - 1 ];
            orbs[ orbs.size() - 1 ].init( id, m, x, y, z, 0.0, 0.0, 0.0 );
        }
    }

    fun void destroy_orb_id( int id ) {
        //<<< "os_destroy_id", me.id(), "" >>>;
        get_orb_idx(id) => int idx; 
        destroy_orb_idx( idx ); 
    }

    fun void destroy_orb_idx( int idx ) {
        //<<< "os_destroy_idx", me.id(), "" >>>;
        if( idx >= 0 ) {
            orbs[idx].destroy();
            for( idx => int i; i < orbs.size()-1; i++ ) {
                orbs[i+1] @=> orbs[i];
            }
            orbs.size( orbs.size() - 1 );
        }
    }

    fun int get_orb_idx( int id ) { 
        //<<< "os_get_idx", me.id(), "" >>>;
        for( int i; i < orbs.size(); i ++ ) {
            if( orbs[i].id == id )
                return i;
        }
        return -1;
    }

    fun void edge_check( Orb orb ) {
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

    // todo: find way to get this info back to the manager class
    //          maybe pass out an array of ids that collided?
    fun void coll_checks( Orb orb ) {
        //<<< "os_coll_checks", me.id(), "" >>>;
        for( int k; k < orbs.size(); k++ ) {
            if( orb.id != orbs[k].id && orb.coll_check( orbs[k].loc ) ) {
                //orb.change_dir();
                replace( [orb, orbs[k]] );
            }
        }
    }

    fun void gravitate( Orb orb ) {
        for( int i; i < orbs.size(); i++ ) {
            if( orb.id != orbs[i].id ) 
                orb.gravitate( orbs[i] );
        }
    }

    fun Orb combine( Orb r_orbs[] ) {
        float x_mean, y_mean, z_mean, m_tot;
        int new_id;
        for( int i; i < r_orbs.size(); i++ ) {
            r_orbs[i].loc.x() +=> x_mean;
            r_orbs[i].loc.y() +=> y_mean;
            r_orbs[i].loc.z() +=> z_mean;
            r_orbs[i].m +=> m_tot;
        }
        r_orbs.size() /=> x_mean;
        r_orbs.size() /=> y_mean;
        r_orbs.size() /=> z_mean;
        orbs.size() => new_id; 

        Orb out;
        out.init( new_id, m_tot, x_mean, y_mean, z_mean, 0, 0, 0 );
        return out;
    }

    fun void replace( Orb r_orbs[] ) {
        combine( r_orbs ) @=> Orb new_orb;
        for( int i; i < r_orbs.size(); i++ ) {
            chout <= r_orbs[i].id + ", ";
            destroy_orb_id( r_orbs[i].id );
        }

        orbs.size( orbs.size() + 1 );
        new Orb @=> orbs[orbs.size()-1];
        new_orb @=> orbs[orbs.size()-1];
    }

    fun void destroy() {
        for( int i; i < orbs.size();i ++ ) {
            write( orb[i] );
            destroy_orb_idx( i );
        }
    }
}
