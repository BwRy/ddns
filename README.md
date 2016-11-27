Dynamic DNS
===========

This is a simple project to automatically set up dynamic dns on a
system.  This uses `nsupdate` to publish updates and a systemd timer
to regularly send the updates.

Dependencies
------------

- Systemd
- Curl
- BIND Tools  (for `nsupdate` and optionally `tsig-keygen`)
