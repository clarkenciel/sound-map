// manager.ck
// manager class to handle recording, sound creation, and sound destruction
// Author: Danny Clarke

public class Manager {
    me.dir(1) => string home;
    home + "index.txt" => string index_fn;
    home + "snds/" => string sound_dir;
    home + "data/" => string data_dir;
    string filenames[0];
    FileIO index;
    Sound players[0];
    Recorder rec;
    float orb_locs[0];

    // read index file and load
    fun void read_index() {
        string line, fn;
        int comma_idx, start_idx;
        index.open( index_fn, FileIO.READ );

        if( index.good() ) {
            // parse the file
            while( index.more() ) {
                index.readLine() => line;
                while( start_idx < line.length() ) {
                    <<< start_idx, line.length(), "" >>>;
                    line.find( ",", start_idx ) => comma_idx;
                    line.substring( start_idx, comma_idx - start_idx ) => fn;
                    <<< fn,"" >>>;
                    if( !is_in( fn, filenames ) ) {
                        filenames << fn;
                        <<< "initializing sound:",fn,"">>>;
                    }
                    comma_idx + 1 => start_idx;
                }
            }
            index.close();
        } else {
            index.close();
        }
    }
    
    // TODO: Need to find way to sustain this
    //      Right now, these shreds will die at the end of this func
    fun void load_sounds() {
        // loop through the filenames array and read
        //  in soun files
        if( players.size() != filenames.size() )
            players.size( filenames.size() );

        for( int i; i < filenames.size(); i ++ ) {
            players[i].read( filenames[i] );
            spork ~ players[i].play(i);
        }
    }

    // create sound via recording
    fun void create_sound() {
        string old_fn;
        if( filenames.size() - 1 > 0 )
            filenames[ filenames.size() - 1 ] => old_fn;
        else
            "0.000" => old_fn;

        make_fn( old_fn ) => string fn;
        rec.record( fn, 3::second ); 
        add_sound( fn, filenames.size() );
    }

    // create sound via merge, or other non-recording way
    fun void add_sound( string fn, int idx ) {
        filenames.size( filenames.size() + 1 );
        if( idx < filenames.size() - 1 ) {
            // insert
            for( filenames.size() - 1 => int i; i > idx; i -- )
                filenames[i-1] @=> filenames[i];
            fn @=> filenames[idx];
        } else fn @=> filenames[ idx ]; // "push"
        
        update_index();
        read_index();
    }

    // delete a sound entirely
    fun void delete_sound( int idx ) {
        // stop corresponding player
        destroy_player(idx); 
        // remove filenames from index
        for( idx => int i; i < filenames.size() - 1; i++ ) {
            filenames[i+1] @=> filenames[i];
        }
        
        // resize filenames array
        filenames.size( filenames.size() - 1 );
        
        // update index file
        update_index();
    }
    
    // delete a single sound player, but not the sound
    fun void destroy_player( int idx ) {
        // stop player
        1 => players[idx].kill;
        players[idx].rate => now;

        // remove from player array    
        NULL @=> players[idx];
        for( idx => int i; i < players.size() - 1; i++ ) {
            players[i+1] @=> players[i];
        }
        NULL @=> players[ players.size() - 1 ];
    
        // reduce array size
        players.size( players.size() - 1 );
    }
    
    // delete all of the players, but not the sounds
    fun void destroy_all() {
        for( int i; i < players.size(); i ++ ) {
            destroy_player( i );
        }
        NULL @=> players;
    }
    
    // TODO: Make this reuse files
    fun void merge( int idx_one, int idx_two ) {
        make_fn( filenames[filenames.size() - 1] ) => string fn; 
        string f1_line, f2_line, f3_line;
        int coin;

        FileIO file1, file2, dest;
        file1.open( filenames[idx_one], FileIO.READ );
        file2.open( filenames[idx_two], FileIO.READ );
        dest.open( fn, FileIO.WRITE );
        
        while( file1.more() && file2.more() ) {
            file1.readLine() => f1_line;
            file2.readLine() => f2_line;
            if( coin )
                dest <= f1_line;
            else
                dest <= f2_line;
            (coin + 1) % 2 => coin;
        }

        file1.close();
        file2.close();
        dest.close();
        delete_sound( idx_one );
        delete_sound( idx_two );
        add_sound( fn, filenames.size() );
    }

    // TODO: fix this to correctly parse/generate file names
    fun string make_fn( string prv_fn ) {
        if( prv_fn.length() > 4 ) 
            prv_fn.substring( prv_fn.length() - 4 ) => prv_fn;
        <<< "Old filename:", prv_fn, "" >>>;
        prv_fn => Std.atof => float id;
        0.001 +=> id;
        sound_dir + Std.ftoa(id, 3) => string fn;
        <<< "New filename:", fn,"">>>;
        return fn;
    } 

    fun void update_index() {
        index.open( index_fn, FileIO.WRITE );
        for( int i; i < filenames.size(); i ++ ) {
            index <= filenames[i] + ",";
        }
        index.close();
    } 

    // clean up on quit
    fun void quit() {
        destroy_all();
        NULL @=> rec;
        NULL @=> index;    
        NULL @=> filenames;
    }

    // check if string is in array
    fun int is_in( string fn, string fns[] ) {
        for( int i; i < fns.size(); i ++ ) {
            if( fn == fns[i] )
                return 1;
        }
        return 0;
    } 
}
