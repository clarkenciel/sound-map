// read_ana.ck
// parse an analysis file
// Author: Danny Clarke

string filename;
if( me.args() ) {
    me.arg(0) => filename;
} else {
    <<< "Please try again with a wav filename","" >>>;
    me.exit();
}

// File setup
FileIO f;
float vals[0];
float val;
int line_count, idx_one, idx_two, len;
string line;
"," => string delim;

// Parse file
f.open( filename, FileIO.READ );
while( f.more() ) {
    f.readLine() => line;
    line_count++;
    <<< "\n\tLINE COUNT:",line_count,"\n","" >>>;
    0 => idx_one => idx_two; // reset indexes
    while( line.find( delim, idx_one ) < line.length()-1 ) {
        <<< idx_one >>>;
        // get idx_two
        line.find( delim, idx_one+1 ) => idx_two;
        <<< idx_two >>>;
        1 +=> idx_one;
        idx_two - idx_one => len;
        line.substring( idx_one, len ) => Std.atof => val;
        vals << val;
        <<< "\tNew Val:", vals[vals.size()-1], "" >>>;
        line.find( delim, idx_two+1 ) => idx_one;
    }
}
f.close();
