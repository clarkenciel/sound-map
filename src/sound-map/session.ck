// session.ck
// handle the user interactions with the manager and the "orbital system"
// Author: Danny Clarke

public class Session {
    me.dir(1) + "index.txt" => string index_file;
    FileIO index;
    Manager man;
    OrbSystem sys;
    int ids[0]; // connect indexes to ids
    int kill, LIMIT;
    me.dir(2) => string home;
    home + "index.txt" => string index_fn;
    home + "snds/" => string sound_dir;
    home + "data/" => string data_dir;

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
                data.size(data.size());
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
        } else {
            // create a new index file
            index.close();
            index.open( index_file, FileIO.WRITE );
            index.close();
        }
        
        // parse our data array
        for( int i; i < data.size(); i++ ) {
            if( data[i].size() == 3 ) {
                ids << Std.atoi( data[0] );
                snd_filenames << data[1];
                orb_filenames << data[2];
            }
        }

        // initialize our other bits
        spork ~ man.init( snd_filenames, ids );
        spork ~ sys.init( orb_filenames, ids, [0,500], [0,500], [-100,100], LIMIT );

        NULL @=> snd_filenames;
        NULL @=> orb_filenames;
    }
    
    fun void write_index() {
        index.open( index_file, FileIO.WRITE );
        man.get_filenames() @=> string snd_fns[];
        sys.get_filenames() @=> string orb_fns[];
        for( int i; i < ids.size(); i ++ ) {
            index <= Std.itoa(ids[i])+":"+snd_fns[i]+":"+orb_fns+":\n";
        }
        index.close(); 
    }

    fun void quit() {
        man.quit();
        NULL @=> man;
        <<< "session quitting", "" >>>;
        1 => kill;
    }

    fun void record() {
        <<< "session recording", "" >>>;
        man.create_sound();
    }
    
    // will figure the specifics of this with Wolfgang
    fun void input_listen() {
        OscIn in;
        OscMsg msg;
        in.port( 57120 );
        in.listenAll();
            <<< "session listening","" >>>;
        while( true ) {
            in => now;
            while( in.recv( msg ) ) {
                <<< msg.address, "received","">>>;
                if( msg.address == "/record" )
                    record();
                if( msg.address == "/quit" )
                    quit();
                if( msg.address == "/delete" )
                    man.delete_sound( msg.getInt(0) );
                if( msg.address == "/destroy" )
                    man.destroy_player( msg.getInt(0) );
                if( msg.address == "/merge" )
                    man.merge( msg.getInt(0), msg.getInt(0) );
            }
        }     
    }

    fun void read_index( string snd_fns[], string orb_fns[] ) {
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
}
