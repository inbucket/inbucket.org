---
layout: page
title: "Ubuntu Installation"
description: "How to install Inbucket on Ubuntu Linux"
---
{% include JB/setup %}

## Install Inbucket on Ubuntu 12.04 or similar

### 1. Dependencies
You will need to have the `setcap` binary installed to allow Inbucket access to
privileged ports (ie 25 for SMTP and 80 for HTTP).  You can install it with apt-get:

    apt-get install libcap2-bin

### 2. Copy Distribution
Move or copy your Inbucket distribution to the `/opt` directory.  I recommend you
keep the version number or build date in the name, and create a symbolic link
from `inbucket` to that name to make upgrading/downgrading easier.

Example, assuming you had a binary distribution tarball in root's home directory:

    cd /opt
    tar xjvf ~/inbucket-YYYYMMDD-linux_amd64.tbz2
    ln -s inbucket-YYYYMMDD-linux_amd64/ inbucket
    cd inbucket/etc/ubuntu-12

The steps below should be run as root from the etc/ubuntu-12 directory within your
Inbucket source or binary distribution.

### 3. Create Service Account
Create a service account for the daemon to run under.

*NOTE:* there is a [setcap][1] command in the upstart config that allows inbucket to listen on
privileged ports (such as 25 and 80) without running as root.

    useradd -r -m inbucket

### 4. Create Data Store
Create the directory where mail will be stored and make it writable by inbucket:

    install -o inbucket -g inbucket -m 775 -d /var/opt/inbucket

### 5. Setup Log Rotation
Copy logrotate config into place, it should inherit most of the defaults setup in
/etc/logrotate.conf

    install -o root -g root -m 644 inbucket.logrotate /etc/logrotate.d/inbucket

### 6. Install Upstart Config
Copy upstart config into place:

    install -o root -g root -m 644 inbucket-upstart.conf /etc/init/inbucket

### 7. Configure Inbucket
Copy the sample config into place:

    install -o root -g root -m 644 ../unix-sample.conf /etc/opt/inbucket.conf

Confirm the contents of /etc/opt/inbucket.conf are to your liking.

### 8. Start & Verify Inbucket
Start the daemon:

    start inbucket

Confirm it stayed running:

    status inbucket

Check inbucket's startup messages:

    less /var/log/inbucket.log

[1]: http://www.kernel.org/doc/man-pages/online/pages/man7/capabilities.7.html
