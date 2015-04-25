// manager.ck
// manager class to handle recording, sound creation, and sound destruction
// Author: Danny Clarke

public class SoundManager {
    Sound players[0];
    StopEvent stops[0];
    Recorder rec;

    fun void init( string filenames[], int ids[] ) {
        // loop through the filenames array and read
        //  in soun files
        if( players.size() != filenames.size() )
            players.size( filenames.size() );
        if( stops.size() != filenames.size() )
            stops.size( filenames.size() );

        for( int i; i < filenames.size(); i ++ ) {
            <<< "player",i,"reading", filenames[i], "" >>>;
            new Sound @=> players[i];
            players[i].init( filenames[i], ids[i] );
            
            new StopEvent @=> stops[i];
            ids[i] => stops[i].id;

            spork ~ players[i].play( stops[i] );
        }
    }

    // create sound via recording
    // rewrite of create_sound for refactor
    fun string create( int id, OrbUpdater e ) {
        me.dir(2) + "snds/" + Std.itoa( id ) => string fn;
        rec.record( fn, 3::second, e ) => fn; 
        //addPlayer( fn, id );
    }

    fun void addPlayer( string fn, int chan, OrbUpdater ou ) {
        <<< "Adding player for:",fn,"on channel",chan,"">>>;

        players.size( players.size() + 1 );
        new Sound @=> players[ players.size() - 1 ];

        stops.size( stops.size() + 1 );
        new StopEvent @=> stops[ stops.size() - 1];

        players[ players.size() - 1 ].init( fn, chan );
        spork ~ players[ players.size() - 1 ].play( ou, stops[ stops.size() - 1 ] );
    }

    // delete a sound entirely
    fun string[] destroySound( int id ) {
        // stop corresponding player
        destroyPlayer(id); 

        // NULL out the sound file
        getSound( id ) @=> Sound s;
        s.destroy();
        
        // give back the filenames
        return getFilenames();
    }
    
    // delete a single sound player, but not the sound
    // TODO: rewrite to handle new kill events
    fun void destroyPlayer( int id ) {
        // remove from player array    
        getSoundIdx( id ) @=> int idx;

        if( idx >= 0 ) {
            NULL @=> players[idx];
            for( idx => int i; i < players.size() - 1; i++ ) {
                players[i+1] @=> players[i];
            }
            NULL @=> players[ players.size() - 1 ];
        
            // reduce array size
            players.size( players.size() - 1 );
        }
    }
    
    // delete all of the players, but not the sounds
    fun void destroyAllPlayers() {
        for( int i; i < players.size(); i ++ ) {
            destroyPlayer( i );
        }
        NULL @=> players;
    }

    // destroy all sounds
    fun string[] destroyAllSounds() {
        for( int i; i < players.size(); i++ ) {
            destroySound( players[i].id );
        }
        return getFilenames();
    }
    
    fun string[] combine( int new_id, int id1, int id2, OrbUpdater e ) {
        me.dir(2) + "/snds/" + Std.itoa( new_id ) => string fn;
        getSound( id1 ) @=> Sound s1;
        getSound( id2 ) @=> Sound s2;

        // pass in a new filename and two soundbufs, get back the new filename
        rec.merge( fn, s1.getSound(), s2.getSound(), e ) => fn;
        destroySound( id1 );
        destroySound( id2 ); 
        
        return getFilenames();
    }

    // clean up on quit
    fun void quit() {
        <<< "manager quitting", "" >>>;
        destroyAllPlayers();
        NULL @=> rec;
        NULL @=> stops;
    }

    fun int getSoundIdx( int id ) {
        for( int i; i < players.size(); i++ ) {
            if( players[i].id == id )
                return i;
        }
        return -1;
    }

    fun Sound getSound( int id ) {
        for( int i; i < players.size(); i++ ) {
            if( players[i].id == id )
                return players[i];
        }
        return NULL;
    }

    fun string[] getFilenames() {
        string out[0];
        for( int i; i < players.size(); i++ ) {
            out << players[i].filename;
        }
        return out; 
    }

    fun string[] getFilenames( int ids[] ) {
        string out[0];
        for( int i; i < ids.size(); i++ ) {
            for( int j; j < players.size(); j++ ) {
                if( players[j].id == ids[i] )
                    out << players[j].filename;
            }
        }
        return out; 
    }

}
