#!/bin/sh

ipurl="icanhazip.com"
ttl=300

for key in /etc/ddns/*
do
    host="$(sed 's/key "\([a-z.]*\)".*/\1/' "$key" | head -1)"
    echo "Updating host $host"
    {
	echo "ttl $ttl"
	if curl -6 "$ipurl" > /dev/null
	then
	    echo "del $host AAAA"
	    echo "add $host $ttl AAAA $(curl -6 "$ipurl")"
	fi

	echo "add $host MX 10 $host"

	if ssh-keygen -r "$host" > /dev/null
	then
	    echo "del $host SSHFP"
	    ssh-keygen -r "" | sed "s/.*/add $host $ttl &/"
	fi

	echo "show"
	echo "send"
    } | nsupdate -k "$key"
done
