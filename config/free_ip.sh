#!/bin/bash

# Генерируем все возможные IP в подсети
all_ips=$(seq 1 254 | awk '{print "10.8.0."$1}')

# Получаем занятые IP из файла
used_ips=$(sed -n -e 's/.*AllowedIPs = \([0-9.]\+\).*/\1/p' -e 's/.*Address = \([0-9.]\+\).*/\1/p' /etc/wireguard/wg0.conf)

# Ищем первый свободный IP
for ip in $all_ips; do
  if ! echo "$used_ips" | grep -q "^$ip$"; then
    echo "$ip"
    exit 0
  fi
done

echo "Все IP адреса в подсети заняты"
exit 1