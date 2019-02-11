#!/bin/sh

ret=0

which rocks | grep -q /opt/rocks/bin/rocks
ret=$?

exit $ret
