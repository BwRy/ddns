#!/bin/sh

ipurl="icanhazip.com"

for key in /etc/ddns/*
do
    host="$(sed 's/key "\([a-z.]*\)".*/\1/' "$key" | head -1)"
    echo "Updating host $host"
    {
	echo "ttl 300"
	if curl -6 "$ipurl" > /dev/null
	then
	    echo "del $host AAAA"
	    echo "add $host AAAA $(curl -6 "$ipurl")"
	fi

	if ssh-keygen -r "$host" > /dev/null
	then
	    echo "del $host SSHFP"
	    ssh-keygen -r "$host" | sed 's/.*/add &/'
	fi

	echo "show"
	echo "send"
    } | nsupdate -k "$key"
done
