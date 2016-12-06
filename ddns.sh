#!/bin/sh

ipurl="icanhazip.com"
ttl=300

for key in /etc/ddns/*
do
    host="$(sed 's/key "\([a-z.]*\)".*/\1/' "$key" | head -1)"
    echo "Updating host $host"
    {
	echo "ttl $ttl"
	echo "delete $host"
	if curl -6 "$ipurl" > /dev/null
	then
	    echo "add $host $ttl AAAA $(curl -6 "$ipurl")"
	fi

	if systemctl is-active postfix.service
	then
	    echo "add $host MX 10 $host"
	    echo "add $host TXT \"v=spf1 mx -all\""
	fi
	
	if ssh-keygen -r "$host" > /dev/null
	then
	    ssh-keygen -r "" | sed "s/.*/add $host $ttl &/"
	fi

	echo "show"
	echo "send"
    } | nsupdate -k "$key"
done
