#!/bin/bash

if [ $# -eq 0 ]
then
	echo "must have peer id as arg: remove-peer.sh asdf123="
else
	wg set wg0 peer $1 remove
	wg-quick save wg0
	wg show
fi
