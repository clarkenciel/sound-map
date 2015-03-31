// sound.ck
// class that reads a file and plays an IFFT of the file
// Author: Danny Clarke

public class Sound {
    IFFT ifft;
    complex sound[][];
    int samps;
    int kill;
    dur rate;

    fun void read( string fn ) {
        FileIO f;
        string line;
        f.open( fn, FileIO.READ );
        
        while( f.more() ) {
            f.readLine() =>  line;
            if( line.length() > 0 && line.find( ":" ) ) {
                i_parse( line ) => samps;
                break;
            } else if( line.length() > 0 ) {
                sound.size( sound.size() + 1 );
                c_parse(line) @=> sound[ sound.size()-1 ];
            }
        }
        f.close();
        NULL @=> f;
        (samps / sound.size() )::samp => rate;
    }

    fun void play( int channel ) {
        ifft => dac;
        dac.chan(channel);
        complex smple[];
        int s;

        while( !kill ) {
            sound[s] @=> smple;
            ifft.transform( smple );
            (s+1) % sound.size() => s;
            rate => now;
        }

        destroy();
    }
    
    fun void destroy() {
        ifft =< dac;
        NULL @=> ifft;
        NULL @=> sound;
    }

    // parse a line of a file/sample of sound
    fun complex[] c_parse( string line ) {
        "[" => string c_start;
        "," => string c_mid;
        "]" => string c_end;
        int start_idx, end_idx, samps, len, lineNum;
        float re, im;
        complex out[];

        while( line.find( c_end, start_idx ) < line.length() - 1 ) {
            // get the real component
            line.find( c_start, end_idx ) + 1 => start_idx;
            line.find( c_mid, start_idx ) => end_idx;
            end_idx - start_idx => len;
            line.substring( start_idx, len ) => Std.atof => re;
            
            // get the imaginary component
            end_idx + 1 => start_idx;
            line.find( c_end, start_idx ) => end_idx;
            end_idx - start_idx => len;
            line.substring( start_idx, len ) => Std.atof => im;

            out.size( out.size() + 1 );
            #(re, im) @=> out[ out.size() -1 ];
        } 
        
        return out;            
    }

    // parse the length of the sound
    fun int i_parse( string line ) {
        ":" => string samp_delim;
        line.find( samp_delim ) + 1 => int delim_idx;

        line.substring( delim_idx ) => Std.atoi => int out;
        return out;
    }
        
}
