me.dir() => string d;
string filename;
if( me.args() )
    me.arg(0) => filename;
else 
    me.exit();

FileIO f;
f.open( filename, FileIO.READ );
<<< f.size() ,"" >>>;
f.close()
