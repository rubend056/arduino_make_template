The brains of this operation, at least the user configurable part is in that makefile, and the bash script arduino-builder
So far I think it the compiler only works in Linux.... we'll see what happens later

PLEASE, PLEASE read and understand what's happening in the Makefile to use this template.

The Makefile is set up to work with the Arduino UNO through the USB connection, just plug the USB, then "make flash", this will compile your program, which should be in folder src, then flash it on the arduino, if you want to add libraries just add them in the lib folder. Goes like this:   lib/library_folder/*.cpp_files
HAVE FUN CODING :)


If you wanna do something more complicated, changing fuses, etc... then you have to Google, Youtube, idk just make sure you understand the basics of how a Makefile works.

There's a bunch of useful documentation in the docs directory if you feel the need to explore :) 

Good luck on your electrical jouney
