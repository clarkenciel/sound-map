// session.ck
// handle the user interactions with the manager and the "orbital system"
// Author: Danny Clarke

public class Session {
    OscIn in;
    OscMsg msg;
    Manager man;
    Orb orbs[];
    

    // load up our manager and start playing existing sounds
    fun void init() {
        man.readIndex();
        man.set_orbs( orbs );
    }

    fun void start() {
        man.load_sounds();
        spork ~ input_listen();
    }

    fun void quit() {
        man.quit();
        NULL @=> man;
        NULL @=> in;
        NULL @=> msg;
    }

    fun void record() {
        man.create_sound();
    }
    
    // will figure the specifics of this with Wolfgang
    fun void input_listen() {
        while( true ) {
            in => now;
            while( in.recv( msg ) ) {
            
            }
        }     
    }
}
