// Session controller for app
// Author: Danny Clarke
public class Session {
    // DIRS
    me.dir(-1) => string mainD;
    mainD + "rec/" => string recordings;
    mainD + "ana/" => string analysis;
    mainD + "bin/" => string functions;

    // CURRENT STATE
    float rLast, aLast, rNew, aNew; // ids for last and next recs/anas
    int rcount, acount;

    FileIO rIndex, aIndex, pIndex; // our indexes
    rIndex.open( recordings+"index.txt", FileIO.READ );
    aIndex.open( analysis+"index.txt", FileIO.READ );

    while( !rIndex.eof() ) {
        rIndex.readLine();
        rcount ++ ;
    }
    while( !aIndex.eof() ) { 
        aIndex.readLine();
        acount++;
    }
    rIndex.close(); aIndex.close();

    rcount * 0.00001 => rLast; <<< rLast >>>;
    acount * 0.00001 => aLast; <<< aLast >>>;
    rLast => rNew;
    aLast => aNew;

    // FUNCS
    fun void record() {
        rIndex.open( recordings+"index.txt", FileIO.APPEND );
        Std.ftoa(rNew, 6) => string id;
        Machine.add( functions+"record.ck:"+id ) => int rec;
        rIndex <= id <= IO.nl();
        rIndex.close();
    }

    fun void analyze() {
        aIndex.open( analysis+"index.txt", FileIO.APPEND );
        Std.ftoa(aNew,6) => string id;
        Machine.add( functions+"analyze.ck:"+id) => int ana;
        aIndex <= id <= IO.nl();
        aIndex.close();
    }

    fun void findPos() {


    }
}


// TEST CODE
Session s;
s.record();
