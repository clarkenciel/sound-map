// ana_comb.ck
// combine to analysis files
// Author: Danny Clarke

me.dir() => string d;
string filename1, filename2, filename3;
if( me.args() == 3 ) {
    me.arg(0) => filename1;
    me.arg(1) => filename2;
    me.arg(2) => filename3;
} else {
    <<< "Please specify which two files to combine, and a destination", "" >>>;
    me.exit();
}

FileIO f1, f2, f3;
f1.open( filename1, FileIO.READ );
f2.open( filename2, FileIO.READ );
f3.open( filename3, FileIO.WRITE );

":" => string samp_delim;
"[" => string start_comp;
"]" => string end_comp;
"," => string comp_delim;
string line1, line2;
string num, samps;
float val1, val2, val3;
int s1_idx, s2_idx, e1_idx, e2_idx, len, lineNum;

// combine
while( f1.more() && f2.more() ) {
    f1.readLine() => line1;
    f2.readLine() => line2;
    lineNum++;
    if( line1.find( samp_delim ) > -1 ) {
        line1.find( samp_delim ) + 1 => s1_idx;
        line1.substring( s1_idx ) => samps;
        break;
    } else if( line2.find( samp_delim ) > -1 ) {
        line2.find( samp_delim ) + 1 => s2_idx;
        line2.substring( s2_idx ) => samps;
        break;
    } else {
        0 => s1_idx => s2_idx => e1_idx => e2_idx; 
        while( line1.find( end_comp, s1_idx ) < line1.length() - 1 
            && line2.find( end_comp, s2_idx ) < line2.length() - 1 ) {
            // get the real value from file one
            line1.find( start_comp, e1_idx ) + 1 => s1_idx;
            line1.find( comp_delim, s1_idx ) => e1_idx;
            e1_idx - s1_idx => len;
            line1.substring( s1_idx, len ) => Std.atof => val1;
    
            // get the real value from file two
            line2.find( start_comp, e2_idx ) + 1 => s2_idx;
            line2.find( comp_delim, s2_idx ) => e2_idx;
            e2_idx - s2_idx => len;
            line2.substring( s2_idx, len ) => Std.atof => val2;
    
            // compare values
            if( val1 < val2 )
                val1 => val3;
            else
                val2 => val3;
            while( val3 > 0.01 )
                0.01 -=> val3;
            while( val3 < -0.01 )
                0.01 +=> val3;

            // store larger in file 3
            f3 <= start_comp <= val3 <= comp_delim;
    
            // get imaginary val from file one
            e1_idx + 1 => s1_idx;
            line1.find( end_comp, s1_idx ) => e1_idx;
            e1_idx - s1_idx => len;
            line1.substring( s1_idx, len ) => Std.atof => val1;
    
            // get imaginary val from file two
            e2_idx + 1 => s2_idx;
            line2.find( end_comp, s2_idx ) => e2_idx;
            e2_idx - s2_idx => len;
            line2.substring( s2_idx, len ) => Std.atof => val2;
    
            // compare vals
            if( val1 < val2 )
                val1 => val3;
            else
                val2 => val3;
            while( val3 > 0.01 )
                0.01 -=> val3;
            while( val3 < -0.01 )
                0.01 +=> val3;
    
            // store bigger
            f3 <= val3 <= end_comp;
        }
        f3 <= "\n";
    }
}

// put total sample size in new file
f3 <= "\n:" <= samps;

// close
f1.close();
f2.close();
f3.close();
