// session.ck
// handle the user interactions with the manager and the "orbital system"
// Author: Danny Clarke

public class Session {
    me.dir(2) + "index.txt" => string index_file;

    FileIO index;
    SoundManager man;
    OrbSystem sys;

    int ids[0]; // connect indexes to ids
    int kill;
    float cur_x, cur_y, cur_z;

    int colls[0][0];
    Orb orbs[0];
        
    (second / 60) => dur framerate;

    me.dir(2) => string home;
    home + "index.txt" => string index_fn;
    home + "snds/" => string sound_dir;
    home + "data/" => string data_dir;
    string command;

    // load up our manager and start playing existing sounds
    // Rewrite to read the index and get information about:
    //      sound files
    //      orb data files
    //      then, store array of object ids
    fun void init( int lim ) {
        <<< "initializing and starting session","" >>>;
        string snd_filenames[0];
        string orb_filenames[0];
        string data[0][0];
        string line, sf, of;
        int id, start_idx, end_idx, len, line_num;
        lim => sys.ORB_LIMIT;
        [0.0,500.0] @=> sys.X_RANGE;
        [0.0,500.0] @=> sys.Y_RANGE;
        [-100.0,100.0] @=> sys.Z_RANGE;

        index.open( index_file, FileIO.READ );

        // parse the file
        if( index.good() ) {
            while( index.more() ) {
                0 => start_idx => end_idx => len;
                // grow our array of data
                data.size( data.size() + 1 );
                new string[0] @=> data[data.size()-1];

                // actually parse the line
                index.readLine() => line;
                while( line.length() > 0 && start_idx < line.length() && line.find(":", start_idx) >= 0 ) {
                    line.find(":", start_idx) => end_idx;
                    end_idx - start_idx => len;
                    data[line_num] << line.substring(start_idx, len);
                    end_idx + 1 => start_idx; 
                    if( start_idx == line.length() ) {
                        0 => start_idx => end_idx => len;
                        break; 
                    }
                }

                line_num++;
            }
            // parse our data array
            for( int i; i < data.size(); i++ ) {
                if( data[i].size() == 3 ) {
                    ids << Std.atoi( data[i][0] );
                    snd_filenames << data[i][1];
                    orb_filenames << data[i][2];
                }
            }
    
            // initialize our other bits
            man.init( snd_filenames, ids );
            sys.init( orb_filenames, ids );
        } else {
            // create a new index file
            index.close();
            index.open( index_file, FileIO.WRITE );
            index.close();
        }
        

        NULL @=> snd_filenames;
        NULL @=> orb_filenames;
    }
    
    fun void writeIndex() {
        string output;
        ids.size() => int len;
        index.open( index_file, FileIO.WRITE );
        <<< "getting sound files", "" >>>;
        man.getFilenames( ids ) @=> string snd_fns[];
        for( int i; i < snd_fns.size(); i++ ) {
            <<< "sound f:", snd_fns[i], "" >>>;
        }
        <<< "getting orb files", "" >>>;
        sys.getFilenames( ids ) @=> string orb_fns[];
        for( int i; i < orb_fns.size(); i++ ) {
            <<< "orb f:", orb_fns[i], "" >>>;
        }
        
        if( orb_fns.size() < len )
            orb_fns.size() => len;
        if( snd_fns.size() < len )
            snd_fns.size() => len;

        <<< "writing",len,"files to index", "" >>>;
        for( int i; i < len; i ++ ) {
            index <= Std.itoa(ids[i])+":"+snd_fns[i]+":"+orb_fns[i]+":\n";
            //<<< "writing",output,"to index.txt","">>>;
        }
        index.close(); 
    }

    fun void quit() {
        writeIndex();
        man.quit();
        sys.quit();
        <<< "session quitting", "" >>>;
        1 => kill;
        "" => command;
    }

    fun void create( float x, float y, float z ) {
        <<< "session recording", "" >>>;
        OrbUpdater e;
        generateId() => int id;
        spork ~ man.create(id, e);
        man.addPlayer( me.dir(2)+"snds/"+Std.itoa( id )+".wav", id, e );
        sys.create( id, x, y, z, e);
        "" => command;
    }

    fun void combine( int id1, int id2 ) {
        OrbUpdater e;
        getIdxById( id1 ) => int one_idx;
        getIdxById( id2 ) => int two_idx;
        if( one_idx >= 0 && two_idx >= 0 ) {
            generateId() => int new_id;
            me.dir(2) + "snds/" + Std.itoa( new_id ) + ".wav" => string fn;
            
            <<< "combining", id1, id2, "" >>>;
            if( id1 < id2 ) {
                spork ~ man.combine( new_id, id1, id2, fn, e );
                man.addPlayer( fn, new_id, e );
                sys.combine( new_id, id1, id2, e );
            } else {
                spork ~ man.combine( new_id, id1, id2, fn, e );
                man.addPlayer( fn, new_id, e );
                sys.combine( new_id, id1, id2, e );
            }
            removeId( one_idx );
            removeId( two_idx );
        }
    }

    fun void loop() {
        while( framerate => now ) {
            writeIndex();
            if( command == "record" )
                create( cur_x, cur_y, cur_z );
            if( command == "quit" )
                quit();         
    
            sys.update() @=> colls;
            //<<< "resolving collisions", "" >>>;
            //resolveCollisions( colls ) @=> colls;
            
            for( int i; i < colls.size(); i++ ) {
                combine( colls[i][0], colls[i][1] );
            }

            sys.getOrbs() @=> orbs;
            send( orbs );
        }
    }          

    // will figure the specifics of this with Wolfgang
    fun void listen() {
        OscIn in;
        OscMsg msg;
        in.port( 57120 );
        in.listenAll();
        <<< "session listening","" >>>;
        while( true ) {
            in => now;
            while( in.recv( msg ) ) {
                <<< msg.address, "received","">>>;
                if( msg.address == "/session/record" ) {
                    "record" => command;
                    msg.getFloat(0) => cur_x;
                    msg.getFloat(1) => cur_y;
                    msg.getFloat(2) => cur_z;
                }
                if( msg.address == "/session/quit" )
                    "quit" => command;
            }
        }     
    }

    fun void readIndex( string snd_fns[], string orb_fns[] ) {
        string line, fn;
        int comma_idx, colon_idx, start_idx;
        index.open( index_fn, FileIO.READ );

        if( index.good() ) {
            // parse the file
            while( index.more() ) {
                index.readLine() => line;
                while( start_idx < line.length() ) {
                    line.find( ",", start_idx ) => comma_idx;
                    line.substring( start_idx, comma_idx - start_idx ) => fn;
                    <<< "initializing sound:",fn,"">>>;
                    comma_idx + 1 => start_idx;
                }
            }
            index.close();
        } else {
            index.close();
        }
    }

    fun void send( Orb orbs[] ) {
        OscOut out;
        out.dest( "localhost", 57121 );

        for( int i; i < orbs.size(); i++ ) {
            out.start( "/orb/update" );
            out.add( orbs[i].id );
            out.add( orbs[i].m );
            out.add( orbs[i].loc.x() ).add( orbs[i].loc.y() ).add( orbs[i].loc.z() );
            out.send();
        }
    }

    fun int getIdxById( int id ) {
        for( int i; i < ids.size(); i++ ) {
            if( ids[i] == id )
                return i;
        }
        return -1;
    }

    fun int generateId() {
        int max;
        for( int i; i < ids.size(); i++ ) {
            if( ids[i] > max )
                ids[i] => max;
        }
        ids.size( ids.size() + 1 );
        max + 1 => ids[ ids.size() - 1 ];
        return max + 1;
    }

    fun void removeId( int id ) {
        getIdxById( id ) => int idx;
        if( idx >= 0 ) {
            for( idx => int i; i < ids.size() - 1; i++ ) {
                ids[i+1] => ids[i];
            }
            ids.size( ids.size() - 1 );
        }
    } 

    /* 
    fun int[][] resolveCollisions( int colls[][] ) {
        int out[0][0];
        
        for( int i; i < colls.size(); i++ ) {
            if( colls.size() > 0 ) {
                for( int j; j < colls[i].size(); j++ ) {
                    <<< colls[i][j], "" >>>;
                    if( !isIn( out, [i,colls[i][j]] ) ) {
                        out.size( out.size() + 1 );
                        new int[0] @=> out[out.size()-1];
                        [i, colls[i][j]] @=> out[out.size()-1];
                    }
                }
            }
        } 

        return out;
    }*/

    fun int isIn( int target[][], int check[] ) {
        int sum;
        for( int i; i < target.size(); i++ ) {
            if( target[i][0] == check[0] || target[i][1] == check[0] )
                sum++;
            if( target[i][1] == check[1] || target[i][1] == check[1] )
                sum++;
            if( sum == 2 )
                return 1;
        }
        return 0;
    }
}
