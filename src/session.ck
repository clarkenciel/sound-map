// session.ck
// handle the user interactions with the manager and the "orbital system"
// Author: Danny Clarke

public class Session {
    Manager man;
    Orb orbs[];
    int kill;

    // load up our manager and start playing existing sounds
    fun void init() {
        <<< "initializing and starting session","" >>>;
        man.read_index();
        man.load_sounds();
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
            }
        }     
    }
}
