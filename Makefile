#!/usr/bin/make

VERSION=0.2
REV=2

all: deb ipk

deb:
	@fakeroot -- /bin/bash -ec " \
	mkdir -p deb/data/usr/sbin ; \
	install -o root -g root -m 770 mqtt-sender deb/data/usr/sbin ; \
	mkdir -p deb/data/usr/share/mqtt-sender ; \
	install -o root -g root -m 644 {mqtt,utility,daemon}.lua deb/data/usr/share/mqtt-sender ; \
	mkdir -p deb/data/etc/mqtt-sender/modules ; \
	install -o root -g root -m 644 mod_*.lua deb/data/etc/mqtt-sender/modules ; \
	install -o root -g root -m 644 config.lua deb/data/etc/mqtt-sender ; \
	mkdir -p deb/data/etc/init.d ; \
	install -o root -g root -m 755 -T debian/init deb/data/etc/init.d/mqtt-sender ; \
	mkdir -p deb/control ; \
	find deb/data/usr/ deb/data/etc/mqtt-sender/modules/ -type f -exec md5sum {} \; > deb/control/md5sums ; \
	install -o root -g root -m 644 debian/control debian/conffiles deb/control ; \
	install -o root -g root -m 644 debian/postinst debian/postrm debian/prerm deb/control ; \
	SIZE=\$$(du -s deb/data | awk '{print \$$1}') ; \
	sed -i -e 's/^\(Version: \).*/\1${VERSION}-${REV}/' deb/control/control ; \
	sed -i -e \"s/^\(Installed-Size: \).*/\1\$${SIZE}/\" deb/control/control ; \
	echo '2.0' > deb/debian-binary ; \
	tar -C deb/data -czf deb/data.tar.gz . ; \
	tar -C deb/control -czf deb/control.tar.gz . ; \
	rm -rf deb/control deb/data ; \
	rm -f mqtt-sender_${VERSION}-${REV}_all.deb ; \
	ar qc mqtt-sender_${VERSION}-${REV}_all.deb deb/debian-binary deb/control.tar.gz deb/data.tar.gz ; \
	rm -rf deb"

ipk:
	@fakeroot -- /bin/bash -ec " \
	mkdir -p ipk/data/usr/sbin ; \
	install -o root -g root -m 770 mqtt-sender ipk/data/usr/sbin ; \
	mkdir -p ipk/data/usr/share/mqtt-sender ; \
	install -o root -g root -m 644 {mqtt,utility,daemon}.lua ipk/data/usr/share/mqtt-sender ; \
	mkdir -p ipk/data/etc/mqtt-sender/modules ; \
	install -o root -g root -m 644 mod_*.lua ipk/data/etc/mqtt-sender/modules ; \
	install -o root -g root -m 644 config.lua ipk/data/etc/mqtt-sender ; \
	mkdir -p ipk/data/etc/init.d ; \
	install -o root -g root -m 755 -T openwrt/init ipk/data/etc/init.d/mqtt-sender ; \
	mkdir -p ipk/control ; \
	install -o root -g root -m 644 openwrt/control ipk/control ; \
	install -o root -g root -m 644 openwrt/postinst ipk/control ; \
	SIZE=\$$(du -sb ipk/data | awk '{print \$$1}') ; \
	sed -i -e 's/^\(Version: \).*/\1${VERSION}-${REV}/' ipk/control/control ; \
	sed -i -e \"s/^\(Installed-Size: \).*/\1\$${SIZE}/\" ipk/control/control ; \
	echo '2.0' > ipk/debian-binary ; \
	tar -C ipk/data -czf ipk/data.tar.gz . ; \
	tar -C ipk/control -czf ipk/control.tar.gz . ; \
	rm -rf ipk/control ipk/data ; \
	rm -f mqtt-sender_${VERSION}-${REV}_all.ipk ; \
	tar -C ipk -czf mqtt-sender_${VERSION}-${REV}_all.ipk debian-binary control.tar.gz data.tar.gz ; \
	rm -rf ipk"
	
