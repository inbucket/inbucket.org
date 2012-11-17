---
layout: page
title: "RedHat Installation"
description: "How to install Inbucket on RedHat Linux"
---
{% include JB/setup %}

## Install Inbucket on RedHat EL 6 or one of its clones

The steps below should be run as root from the etc/redhat-el6 directory within your
Inbucket source or binary distribution.

### 1. Service Account
Create a service account for the daemon to run under.

*NOTE:* there is a [cap][1] command in the init script that allows inbucket to listen on
privileged ports (such as 25 and 80) without running as root.

    useradd -r -m inbucket

### 2. Data Store
Create the directory where mail will be stored and make it writable by inbucket:

    mkdir /var/opt/inbucket
    chown inbucket: /var/opt/inbucket

### 3. Log Rotation
Copy logrotate config into place, it should inherit most of the defaults setup in
/etc/logrotate.conf

    cp inbucket.logrotate /etc/logrotate.d/logrotate
    chown root: /etc/logrotate.d/logrotate

### 4. Init Script
Copy init script into place and activate:

    cp inbucket-init.sh /etc/init.d
    chown root: /etc/init.d/inbucket
    chmod 755 /etc/init.d/inbucket
    chkconfig --add inbucket

### 5. Configure
Copy the sample config into place:

    cp ../unix-sample.conf /etc/opt/inbucket.conf
    chown root: /etc/opt/inbucket.conf

Confirm the contents of /etc/opt/inbucket.conf are to your liking.

### 6. Start & Verify
Start the daemon:

    service inbucket start

Confirm it stayed running:

    service inbucket status

Check inbucket's startup messages:

    less /var/log/inbucket.log

[1]: http://www.kernel.org/doc/man-pages/online/pages/man7/capabilities.7.html
