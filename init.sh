#!/bin/bash

init_server(){
    if [[ ! -f "/etc/wireguard/server_private_key" ]] && \
       [[ ! -f "/etc/wireguard/server_public_key" ]] 
    then
        wg genkey | tee server_private_key | wg pubkey > server_public_key
        cp /etc/wireguard/wg0-server.example.conf /etc/wireguard/wg0.conf
    fi

    if [[ ! -f "/etc/wireguard/wg0.conf" ]] 
    then
        cp /etc/wireguard/wg0-server.example.conf /etc/wireguard/wg0.conf
        sed -i "s/:PRIVATE_KEY:/$(cat /etc/wireguard/server_private_key)/g" /etc/wireguard/wg0.conf
        chmod 0600 /etc/wireguard/wg0.conf
    fi
}

if [ "$SERVER" = "false" ]; then
  echo "Client mode"
else
  echo "Server mode"
  init_server
fi

/bin/bash "$@"

wg show

# check if Wireguard is running
if [[ $(wg) ]]
then
    syslogd -n      # keep container alive
else
    echo "stopped"  # else exit container
fi