// session.ck
// handle the user interactions with the manager and the "orbital system"
// Author: Danny Clarke

public class Session {
    me.dir(2) + "index.txt" => string index_file;

    FileIO index;
    SoundManager man;
    OrbSystem sys;

    int ids[0]; // connect indexes to ids
    int kill, LIMIT;
    float cur_x, cur_y, cur_z;

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
        lim => LIMIT;

        index.open( index_file, FileIO.READ );

        // parse the file
        if( index.good() ) {
            while( index.more() ) {
                // grow our array of data
                data.size( data.size() + 1 );
                new string[0] @=> data[data.size()-1];

                // actually parse the line
                index.readLine() => line;
                while( line.length() > 0 && line.find(":", start_idx) >= 0 ) {
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
            sys.init( orb_filenames, ids, [0.0,500.0], [0.0,500.0], [-100.0,100.0], LIMIT );
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
        index.open( index_file, FileIO.WRITE );
        man.getFilenames() @=> string snd_fns[];
        sys.getFilenames() @=> string orb_fns[];
        for( int i; i < ids.size(); i ++ ) {
            index <= Std.itoa(ids[i])+":"+snd_fns[i]+":"+orb_fns+":\n";
        }
        index.close(); 
    }

    fun void quit() {
        man.quit();
        sys.quit();
        NULL @=> man;
        NULL @=> sys;
        <<< "session quitting", "" >>>;
        1 => kill;
    }

    fun void create( float x, float y, float z ) {
        <<< "session recording", "" >>>;
        OrbUpdater e;
        generateId() => int id;
        spork ~ man.create(id, e);
        sys.create( id, x, y, z, e);
    }

    fun void combine( int id1, int id2 ) {
        OrbUpdater e;
        getById( id1 ) => int one_idx;
        getById( id2 ) => int two_idx;
        
        if( id1 < id2 ) {
            spork ~ man.combine( id1, id1, id2, e );
            sys.combine( id1, id1, id2, e );
        } else {
            spork ~ man.combine( id2, id1, id2, e );
            sys.combine( id2, id1, id2, e );
        }
    }

    fun void loop() {
        int colls[0][0];
        (second / 60) => dur framerate;

        while( framerate => now ) {
            if( command == "record" )
                create( cur_x, cur_y, cur_z );
            if( command == "quit" )
                quit();         
    
            sys.update() @=> colls;
            resolveCollisions( colls ) @=> colls;
            
            for( int i; i < colls.size(); i++ ) {
                combine( colls[i][0], colls[i][1] );
            }
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
                    msg.getFloat(0) => float cur_x;
                    msg.getFloat(1) => float cur_y;
                    msg.getFloat(2) => float cur_z;
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

    fun int getById( int id ) {
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
        return max + 1;
    }

    fun int[][] resolveCollisions( int colls[][] ) {
        int out[0][0];
        
        for( int i; i < colls.size(); i++ ) {
            for( int j; j < colls.size(); j++ ) {
                if( !isIn( out, colls[i] ) )
                    out << colls[i];
            }
        } 

        return out;
    }

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
