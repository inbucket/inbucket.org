---
layout: default
title: RedHat Installation
description: How to install Inbucket on RedHat Linux
---

## Install Inbucket on RedHat EL 6 or one of its clones

### 1. Copy Distribution
Move or copy your Inbucket distribution to the `/opt` directory.  I recommend you
keep the version number or build date in the name, and create a symbolic link
from `inbucket` to that name to make upgrading/downgrading easier.

Example assuming you had a binary distribution tarball in root's home directory:

    cd /opt
    tar xjvf ~/inbucket_X.Y_linux_amd64.tar.gz
    ln -s inbucket_X.Y_linux_amd64/ inbucket
    cd inbucket/etc/redhat-el6

The steps below should be run as root from the `etc/redhat-el6` directory within your
Inbucket source or binary distribution.

### 2. Create Service Account
Create a service account for the daemon to run under.

*NOTE:* there is a [setcap][1] command in the init script that allows inbucket to listen on
privileged ports (such as 25 and 80) without running as root.

    useradd -r -m inbucket

### 3. Create Data Store
Create the directory where mail will be stored and make it writable by inbucket:

    mkdir /var/opt/inbucket
    chown inbucket: /var/opt/inbucket

### 4. Setup Log Rotation
Copy logrotate config into place, it should inherit most of the defaults setup in
`/etc/logrotate.conf`

    cp inbucket.logrotate /etc/logrotate.d/inbucket
    chown root: /etc/logrotate.d/logrotate

### 5. Install Init Script
Copy init script into place and activate:

    cp inbucket-init.sh /etc/init.d
    chown root: /etc/init.d/inbucket
    chmod 755 /etc/init.d/inbucket
    chkconfig --add inbucket

### 6. Configure Inbucket
Copy the sample config into place:

    cp ../unix-sample.conf /etc/opt/inbucket.conf
    chown root: /etc/opt/inbucket.conf

Confirm the contents of `/etc/opt/inbucket.conf` are to your liking.

### 7. Start Inbucket
Start the daemon and check for errors

1. Start the daemon: <kbd>service inbucket start</kbd>
2. Confirm it stayed running: <kbd>service inbucket status</kbd> 
3. Check inbucket's startup messages: <kbd>less /var/log/inbucket.log</kbd>

[1]: http://www.kernel.org/doc/man-pages/online/pages/man7/capabilities.7.html
