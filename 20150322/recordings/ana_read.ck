// ana_read.ck
// read an analysis file
// Author: Danny Clarke

me.dir() => string d;
"ana.txt" => string filename;
if( me.args() ) me.arg(0) => filename;

// file data
FileIO f;
":" => string samp_delim;
"[" => string start_comp;
"]" => string end_comp;
"," => string comp_delim;
string line;
string num;
int delim_one_idx, delim_two_idx, samps, len, lineNum;
float re, im;
complex snd[0][0];

f.open( filename, FileIO.READ ); // open file

while( f.more() ) { // loop through every line in the file
    // 1. read a line
    f.readLine() => line;
    lineNum++;
    //<<< "\n\tLINE NUMBER:",lineNum,"">>>;
    while( !f.good() )
        samp => now;

    // 2. check for sample number
    if( line.length() > 0 && line.find( samp_delim ) > -1 ) {
        line.find( samp_delim ) + 1 => delim_one_idx;
        //<<< "\tSamp # delimiter at index:", delim_one_idx, "" >>>;

        // since this will always be at the end of the file, 
        //  read to end of line
        line.substring( delim_one_idx ) => Std.atoi => samps;
        <<< "\tNumber of samples:", samps, "">>>;
        break; // break as at end of file
    } else if( line.length() > 0 ) {
        //<<< "\n\n\t\t LINE LENGTH:", line.length(),"\n\n","">>>;
        0 => delim_one_idx => delim_two_idx;
        snd.size( snd.size() + 1 );
        new complex[0] @=> snd[snd.size()-1];
        while( line.find( end_comp, delim_one_idx ) < line.length() - 1 ) {
            // 3. go through each complex number
            // 3a. get real component
            line.find( start_comp, delim_two_idx ) + 1 => delim_one_idx;
            line.find( comp_delim, delim_one_idx ) => delim_two_idx;
            delim_two_idx - delim_one_idx => len;
            line.substring( delim_one_idx, len ) => Std.atof => re;

            // 3b. get imaginary component
            delim_two_idx + 1 => delim_one_idx; // start from prior end
            line.find( end_comp, delim_one_idx ) => delim_two_idx;
            delim_two_idx - delim_one_idx => len;
            line.substring( delim_one_idx, len ) => Std.atof => im;

            // 3c. add new complex number
            snd[snd.size()-1].size( snd[snd.size()-1].size()+1 );
            #(re, im) @=> snd[snd.size()-1][snd[snd.size()-1].size()-1];
            //<<< "\tNew Complex:", snd[ snd.size()-1 ],"" >>>;
        }
    }
}

f.close();

// Sound chain
IFFT ifft => dac;
samps::samp => dur pulse;
int s;
complex cs[];
while( true ) {
    snd[s] @=> cs;
    ifft.transform( cs );
    (s+1)%snd.size() => s;
    (samps/snd.size())::samp => now;
}
