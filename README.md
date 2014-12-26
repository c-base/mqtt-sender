mqtt-sender
===========

small lua daemon that can send system statistics

Uses the lua mqtt library from:
  http://git.eclipse.org/c/paho/org.eclipse.paho.mqtt.lua.git

I added the ability to publish retained topics, the changes 
are in the file "retained_topic.patch".

It only needs lua-5.1, lua-socket and lua-posix.


Usage
=====

Just type make after checkout and it will produce a debian and
openwrt package. 

Configuation is in config.lua 
To add new statistics, create a new module and add it as a topic.

