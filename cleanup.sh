#!/bin/bash
# Remove things that are not necessary
find /usr/share/doc -depth -type f ! -name copyright | xargs rm || true
find /usr/share/doc -empty | xargs rmdir || true
rm -rf /usr/share/man /usr/share/groff /usr/share/info /usr/share/lintian /usr/share/linda /var/cache/man
find /usr/share/locale -mindepth 1 -maxdepth 1 ! -name 'en' ! -name 'alias' | xargs rm -r
