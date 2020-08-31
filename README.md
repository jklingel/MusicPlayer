# MusicPlayer

A simple music (melody) player for the Commodore C64 by Jan Klingel, (C) 2020. I wrote this player as I did not want to mess around with .sid files just to play a simple melody, e.g. on the title screen of a game. The music player is single-voice only. Each music file is an 8-bit data table, so the melody needs to be rather short.

The music player expects a music file with the following structure:

music
   .byte note 1 low byte, note 1 high byte, length of note
   .byte note 2 low byte, note 2 high byte, length of note
   ...
   .byte note n low byte, note n high byte, length of note
   .byte 0
   <carriage return>

A pause can be inserted by adding the line

   255, length of pause

The following length values worked for me for a mid-temp song:

	1/8th note: 10
	1/4th note: 20
	1/2th note: 40
	1/1th note: 60 

"music" is the label the assembler expects. The file must be terminated by a null (0) byte followed by a carriage return.
  
See dopeconnection.net/C64_SID.htm for an overview of notes and their frequency values. 
