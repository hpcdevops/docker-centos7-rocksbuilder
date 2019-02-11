#!/bin/sh

function _rb_abspath () { case "$1" in /*)printf "%s\n" "$1";; *)printf "%s\n" "$PWD/$1";; esac; }
function _rb_finish () { echo "I'm done here"; }

