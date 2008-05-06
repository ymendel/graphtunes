graphtunes is for visualization of music playlist data

At the moment, it only makes a line graph of the BPM data for a playlist, and it expects as input an XML-exported iTunes playlist[1]. 

Running it as

    graphtunes playlist.xml

will output a graph to 'playlist.png'. It's as simple as that.

It uses REXML to parse the playlist (stdlib, yay) and gruff for the graphing (enjoy installing RMagick and friends if you haven't already).


[1]: in iTunes, select a playlist, right-click (or ctrl-click, or two-finger tap, or whatever) on the playlist, choose Export Song List..., XML format
