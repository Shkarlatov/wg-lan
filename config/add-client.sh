#!/bin/bash

if [ $# -eq 0 ]
then
	echo "must pass a client name as an arg: add-client.sh new-client"
else
	echo "Creating client config for: $1"
	mkdir -p clients/$1
	wg genkey | tee clients/$1/$1.priv | wg pubkey > clients/$1/$1.pub
	key=$(cat clients/$1/$1.priv) 
	ip=$(./free_ip.sh)
  SERVER_PUB_KEY=$(cat /etc/wireguard/server_public_key)
  cat wg0-client.example.conf | sed -e 's/:CLIENT_IP:/'"$ip"'/' | sed -e 's|:CLIENT_KEY:|'"$key"'|' | sed -e 's|:SERVER_PUB_KEY:|'"$SERVER_PUB_KEY"'|' | sed -e 's|:SERVER_ADDRESS:|'"$FQDN"'|' > clients/$1/$1.conf

	#tar czvf clients/$1.tar.gz clients/$1
	# zip clients/$1.zip clients/$1
	echo "Created config!"
	echo "Adding peer"
	wg set wg0 peer $(cat clients/$1/$1.pub) allowed-ips $ip/32

	wg-quick save wg0
	wg show

fi
