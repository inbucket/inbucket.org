---
layout: default
title: RedHat Installation
description: How to install Inbucket on RedHat Linux
---

## Install Inbucket on RedHat EL 7 or one of its clones

The commands below should be run as root.


### 1. Extract Distribution

Move or copy your Inbucket distribution to the `/opt` directory.  We recommend
you keep the version number or build date in the name, and create a symbolic
link from `inbucket` to that name to make upgrading/downgrading easier.

Example, assuming you had a binary distribution tarball in root's home
directory:

~~~ sh
cd /opt
tar xzvf ~/inbucket_VER_linux_amd64.tar.gz
ln -s inbucket_VER_linux_amd64/ inbucket
~~~


### 2. Set Capabilities

Allow Inbucket to use privileged ports via [capabilities]:

~~~ sh
setcap 'cap_net_bind_service=+ep' /opt/inbucket/inbucket
~~~


### 3. Setup Directories & Configuration

For convenience this block of text can be pasted directly into your terminal:

~~~ sh
cd /opt/inbucket/etc/redhat
useradd -r -m inbucket
install -o inbucket -g inbucket -m 775 -d /var/opt/inbucket
touch /var/log/inbucket.log
chown inbucket: /var/log/inbucket.log
install -o root -g root -m 644 inbucket.logrotate /etc/logrotate.d/inbucket
install -o root -g root -m 644 inbucket.service /lib/systemd/system/inbucket.service
install -o root -g root -m 644 ../unix-sample.conf /etc/opt/inbucket.conf
~~~

The commands above perform the following steps:

1. Create `inbucket` user account
2. Create work directory `/var/opt/inbucket`
3. Create empty log file writable by inbucket
4. Install log rotate configuration
5. Install systemd service unit
6. Install inbucket.conf into `/etc/opt`


### 4. Configure Inbucket

Confirm the contents of `/etc/opt/inbucket.conf` are to your liking, paying
special attention to the ports Inbucket is configured to serve SMTP, HTTP and
POP3 on.

Another common adjustment is the `retention.minutes` option in the `[datastore]`
section; as shipped all messages are deleted four hours after receipt.


### 5. Enable & Start Inbucket

Start the daemon and check for errors

1. Have the daemon start at boot: <kbd>systemctl enable inbucket.service</kbd>
1. Start the daemon: <kbd>systemctl start inbucket</kbd>
2. Confirm it stayed running: <kbd>systemctl status inbucket</kbd>
3. Check inbucket's startup messages: <kbd>more /var/log/inbucket.log</kbd>

[capabilities]: http://www.kernel.org/doc/man-pages/online/pages/man7/capabilities.7.html
