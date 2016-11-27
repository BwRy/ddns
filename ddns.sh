#!/bin/sh

ip="$(curl -6 icanhazip.com)"
echo "Your IPv6 address is $ip"

for key
do
    host="$(sed 's/key "\([a-z.]*\)".*/\1/' "$key" | head -1)"
    echo "Updating host $host"
    nsupdate -k "$key" <<EOF
update delete $host AAAA
update add $host 300 AAAA $ip
send

EOF
done

