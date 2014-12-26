mqtt-sender
===========
small lua daemon that can send system statistics

Uses the lua mqtt library from:
  http://git.eclipse.org/c/paho/org.eclipse.paho.mqtt.lua.git

I added the ability to publish retained topics, the changes 
are in the file "retained_topic.patch".

It only needs lua-5.1, lua-socket and lua-posix.

Usage
-----
Type make after checkout and it will produce a debian and openwrt
package. The daemon is installed in /usr/sbin and configuration is
done in /etc/mqtt-sender/config.lua.

An init-script is also provided. The daemon publishes a retained topic
of client/<hostname> which is removed when the connection to the
mqtt-server is lost.

In addition it publishes the configured topics in intervals under
system/<hostname>/module as json strings.

Extending
---------
To add new information, just create a new module which gathers the
wanted information, add it to the Makefile and create a new package. 

To ease development, use the small test.lua which read the config file
test-config.lua and calls the configured modules every second.  If the
configured interval is expired, it prints the modulename and the
output of the module or else ist prints "modulename nil" every second
for every tested module.

