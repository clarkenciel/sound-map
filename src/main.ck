// main.ck
// the core program, equivalent to main() in c/c++
// Author: Danny Clarke

Session s;

s.init();
spork ~ s.input_listen();

while( s.kill ) ms => now;
