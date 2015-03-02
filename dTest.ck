me.dir() + "bin/" => string d;
FileIO  f, f2;
f.open( d, FileIO.WRITE );
f2.open( d + "record.ck", FileIO.READ );
f <= "hi.txt";
<<< f2.size() >>>;
//while( f.openfile( d + Std
