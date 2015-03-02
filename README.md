Sound Map
=========

This program will allow users to create a field recording. The recording will be stored both as a .wav file, and an abstraction. Abstractions will be mapped into a physical space by Wolfgang's code and users will be able to relocate them, thus remixing the field recordings of an environment in the environment itself. Left alone, the abstractions will be compared to one another to determine which abstractions are most similar to one another. Similar abstractions will "move" through the space toward one another to form clusters of similar recordings which users can stumble upon and disassemble freely.

Components:
-----------
- recorder.ck: record sound files
- ana.ck: analyze a recording
- store.ck: store the results of an analysis
- compare.ck: compare analysis results
- map.ck: store comparisons and "positions" of recordings.

Proposed Workflow:
------------------
1. User opens app and begins recording
2. User stops recording. Recording is stored on server.
3. Recording is analyzed by program and analysis is stored on server.
4. While app is open, analysis is used, in conjunction with recording, to render sound objects in app.

NB: When the app is opened, the analyses and recordings are used to render any already-existing sound objects
