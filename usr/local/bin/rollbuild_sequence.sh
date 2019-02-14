#!/bin/bash

set -e
set -x

ROLL_TO_BUILD=$1

echo "=-=-=- Build of ${ROLL_TO_BUILD} started at $(date) -=-=-="

mkdir -p /tmp/$(pwd)

if [ -d ${ROLL_TO_BUILD} ] ; then
    tar -cf - ./${ROLL_TO_BUILD} | ( cd /tmp/$(pwd) ; tar -xf - )
    cd /tmp/$(pwd)
else
    cd /tmp/$(pwd)
    git clone https://github.com/sdsc/${ROLL_TO_BUILD}.git
fi

pushd ${ROLL_TO_BUILD}

if [ -f ./bootstrap.sh ] ; then
    grep -q yum ./bootstrap.sh && \
        sed -i 's/sudo yum/yum/g;s/yum/sudo yum -y/g;' ./bootstrap.sh
    chmod +x ./bootstrap.sh
    ./bootstrap.sh
    sudo make clean && \
        sudo rm ${PWD}/_arch
fi

make default

for f in $(find . -name "*.iso") ; do
    echo -e "=-=-=- Roll ISO $f Details =-=-=-\n"
    ls -l $f
    echo ""
    isoinfo -R -f -i $f
done

popd

echo "=-=-=- Build of ${ROLL_TO_BUILD} required "\
    $(du -s --block-size=1k ${ROLL_TO_BUILD} | awk '{printf "%'\''d KB\n", $1}')" -=-=-="

pushd ${ROLL_TO_BUILD}

for f in $(find . -name "*.iso"); do
    mv -v $f ../
done

popd

rm -rf ${ROLL_TO_BUILD}

echo "=-=-=- Build of ${ROLL_TO_BUILD} finished at $(date) -=-=-="
