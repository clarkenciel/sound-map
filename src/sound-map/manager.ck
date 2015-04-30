// manager.ck
// manager class to handle recording, sound creation, and sound destruction
// Author: Danny Clarke

public class SoundManager
{
    Sound players[0];
    StopEvent stops[0];
    Recorder rec;

    // ---------------------CORE FUNCTIONS --------------------
    /*
    * init( filename_array, id_array )
    * create new players using the info stored in the files
    * specified by filenames[] and the ids stored in ids[]
    */
    fun void init( string filenames[], int ids[] ) 
    {
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

    /*
    * quit()
    * destroy all of the players and do a bit of cleanup
    */
    fun void quit()
    {
        <<< "manager quitting", "" >>>;
        destroyAllPlayers();
        NULL @=> rec;
        NULL @=> stops;
    }

    /*
    * create( id, update_event )
    * create a new sound with the specified id
    * after recording, send a message to the OrbSystem's sporked-off
    * updateListen() function to let it know that the corresponding orb
    * is good to go
    */
    fun string create( int id, OrbUpdater e )
    {
        me.dir(2) + "snds/" + Std.itoa( id ) => string fn;
        rec.record( fn, 3::second, e ) => fn; 
    }

    /*
    * addPlayer( filename, channel, updater event )
    * add a new player to the array
    * that player's play thread is made to wait until
    * the recording is finished
    */
    fun void addPlayer( string fn, int chan, OrbUpdater ou )
    {
        <<< "Adding player for:",fn,"on channel",chan,"">>>;

        players.size( players.size() + 1 );
        new Sound @=> players[ players.size() - 1 ];

        <<< "creating new stop", "" >>>;
        stops.size( stops.size() + 1 );
        new StopEvent @=> stops[ stops.size() - 1];

        <<< "initializing new player", "" >>>;
        players[ players.size() - 1 ].init( fn, chan );
        spork ~ players[ players.size() - 1 ].play( ou, stops[ stops.size() - 1 ] );
    }

    // -----------------------SUPPORT--------------------

    /*
    * destroySound( id )
    * destroy a sound specified by the id and return
    * an updated version of the currently-played sound files
    */
    fun string[] destroySound( int id )
    {
        // NULL out the sound file
        getSound( id ) @=> Sound s;
        s.destroy();

        // stop corresponding player
        destroyPlayer(id); 
        
        // give back the filenames
        return getFilenames();
    }
    
    /*
    * destroyAllSounds()
    * destroy all of the sounds themselves
    */
    fun string[] destroyAllSounds() {
        for( int i; i < players.size(); i++ ) {
            destroySound( players[i].id );
        }
        return getFilenames();
    }

    /*
    * destroyPlayer( id )
    * destroy just the player, but not the sound
    * specified by id
    */
    fun void destroyPlayer( int id )
    {
        // remove from player array    
        getSoundIdx( id ) @=> int idx;

        if( idx >= 0 ) {
            for( idx => int i; i < players.size() - 1; i++ ) {
                players[i+1] @=> players[i];
            }
        
            // reduce array size
            players.size( players.size() - 1 );
        }
    }
    
    /*
    * destroyAllPlayers()
    * see above func, but applied to everything
    */
    fun void destroyAllPlayers()
    {
        for( int i; i < players.size(); i ++ ) {
            destroyPlayer( i );
        }
        NULL @=> players;
    }

    /*
    * combine( new_sound_id, old_id1, old_id2, new_filename, update_event
    * record a new sound to the specified filename.
    * this sound is a mix-down of the older sounds.
    * an updater event is included to alert the OrbSystem that the corresponding orb
    * is good to go
    */
    fun string[] combine( int new_id, int id1, int id2, string fn, OrbUpdater e ) 
    {
        <<< "getting sound", id1, "" >>>;
        getSound( id1 ) @=> Sound s1;
        <<< "getting sound", id2, "" >>>;
        getSound( id2 ) @=> Sound s2;

        // pass in a new filename and two soundbufs, get back the new filename
        rec.merge( fn, s1.getSound(), s2.getSound(), e ) => fn;
        <<< "destroying sound:", id1, "" >>>;
        destroySound( id1 );
        <<< "destroying sound:", id2, "" >>>;
        destroySound( id2 ); 
        <<< "!!", "" >>>; 
        return getFilenames();
    }

    /* 
    * getSoundIdx( id )
    * get the index of a sound in the players array using the id
    */
    fun int getSoundIdx( int id )
    {
        for( int i; i < players.size(); i++ ) {
            if( players[i].id == id )
                return i;
        }
        return -1;
    }

    /*
    * getSound( id )
    * get a sound from the players array using an id
    */
    fun Sound getSound( int id ) {
        for( int i; i < players.size(); i++ ) {
            if( players[i].id == id )
                return players[i];
        }
        return NULL;
    }

    /*
    * getFilenames()
    * return the filenames of the currently-active sounds
    */
    fun string[] getFilenames() {
        string out[0];
        for( int i; i < players.size(); i++ ) {
            out << players[i].filename;
        }
        return out; 
    }

    /*
    * getFilenames( id_array )
    * get the filenames of the ids specified in the ids_array if they
    * are currently active
    */
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

