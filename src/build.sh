#!/bin/sh -e

chmod +x [0-9]*.sh

for s in [0-9]*.sh; do
    if [ -x $s ]; then
	echo "sh $s"
	sh $s
    fi
done
