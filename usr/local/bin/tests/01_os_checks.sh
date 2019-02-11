#!/bin/sh

ret=0

test -f /etc/redhat-release
ret=$?

exit $ret
