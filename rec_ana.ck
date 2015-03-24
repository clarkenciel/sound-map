// rec_ana.ck
// record audio and analyze it. output wav file and analysis file
// Author: Danny Clarke

// file setup
me.dir() => string d;
".ana" => string ana_end;
d + "0.000" => string wav_name;
wav_name + ana_end => string ana_name;
d + "index.txt" => string idxFile;
3 => float secs;

// TODO: Get args working

// Sound Chain
FileIO f, index;
adc => WvOut2 wv => FFT fft => blackhole;
512 => int WIN => fft.size;
UAnaBlob blob;
wv.wavFilename( wav_name );
f.open( ana_name, FileIO.WRITE );
index.open( idxFile, FileIO.APPEND );

// Recording/Analysis
secs::second + now => time later;
wv.record(1);
while( now < later ) {
    fft.upchuck() @=> blob;
    for( int i; i < blob.fvals().size(); i++ ) {
        f <= blob.fval(i) <= ",";
    }
    f <= "\n";
    WIN::samp => now;
}
index <= wav_name + ".wav" <= ":" <= ana_name <= "\n";

// cleanup
wv.record(0);
wv.closeFile();
f.close();
index.close();
