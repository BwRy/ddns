#!/bin/sh

if [ "$#" = 0 ]
then
    set -- "run"
fi

state=command
config_file=/etc/ddns.conf
for cmd
do
    case "$state" in
	command)
	    case "$cmd" in
		-h|--help|help)
		    cat <<EOF
Usage: $0 [subcommand [arguments]]

Updates DNS entries via nsupdate using configured credentials.  Most
options are configured in $config_file

	help		show this help message
	run		update entries in DNS servers (default)
	addzone		include the specified zone to update this host

EOF
		    exit 0
		    ;;
		addzone)
		    state=addzone
		    ;;
		run)
		    state=run
		    for key in *.key
		    do
			# ignore non-files
			if ! [ -f "$key" ]
			then
			    continue
			fi

			# there are two possible key types, symetric
			# TSIG and asymetric SIG(0).  Kerberos tickets
			# are unnecessary to consider since those
			# setups ususally involve already having this
			# kind of host name resolution setup.
			if [ "$(wc -l < "$key")" = 1 ]
			then
			    chmod 644 "$key"
			    chmod 600 "$(basename "$key" .key).private"
			    host="$(cut -d ' ' -f 1 "$key")"
			else
			    chmod 600 "$key"
			    host="$(sed 's/key "\([a-z.]*\)".*/\1/' "$key" | head -1)"
			fi
			
			# now we update the host
			{
			    echo "ttl $ttl"

			    # IPv4 is usually masked behind NAT or
			    # something else, so we'll usually ignore
			    # it
			    echo "delete $host A"
			    if "$useipv4" && curl -4 "$ipurl" > /dev/null
			    then
				echo "add $host $ttl A $(curl -4 "$ipurl")"
			    fi

			    # IPv6 entries are what we want to publish
			    echo "delete $host AAAA"
			    if curl -6 "$ipurl" > /dev/null
			    then
				echo "add $host $ttl AAAA $(curl -6 "$ipurl")"
			    fi

			    # email provisioning
			    echo "delete $host MX"
			    echo "delete $host TXT \"v=spf1 mx -all\""
			    if systemctl is-active postfix.service > /dev/null
			    then
				echo "add $host $ttl MX 10 $host"
				echo "add $host $ttl TXT \"v=spf1 mx -all\""
			    fi

			    # ssh keys
			    echo "delete $host SSHFP"
			    if ssh-keygen -r "" > /dev/null
			    then
				ssh-keygen -r "$host" | sed "s/.*/add &/"
			    fi

			    # log the update
			    if "$logupdates"
			    then
				echo "show"
			    fi
			    
			    echo "send"
			} | nsupdate -k "$key"
		    done
		    ;;
	    esac
	    ;;
	addzone)
	    # generate SIG(0) keys by default, this avoids juggling
	    # permissions for us
	    dnssec-keygen -K "$keydirectory" -T KEY -n HOST "$(hostname --short).$cmd"
	    ;;
    esac
done
