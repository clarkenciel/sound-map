Sound Map
=========

This program will allow users to create a field recording. The recording will be stored both as a .wav file, and an abstraction. Abstractions will be mapped into a physical space by Wolfgang's code and users will be able to relocate them, thus remixing the field recordings of an environment in the environment itself. Left alone, the abstractions will be compared to one another to determine which abstractions are most similar to one another. Similar abstractions will "move" through the space toward one another to form clusters of similar recordings which users can stumble upon and disassemble freely.

Messages INTO app
-----------------
1. "/session/rec, fff" - triggers the recording of a three second sound file and creation of corresponding orb object according to the x, y, and z coordinates passed in
2. "/session/quit" - triggers the writing to file of currently active objects and sound files, then quits the program

Messages OUT OF app
-------------------
1. "/orb/update, iffff" - sends orb id and mass, followed by x position, y position, and z position
