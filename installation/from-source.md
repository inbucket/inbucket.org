---
layout: page
title: "Installation From Source"
description: "How to install Inbucket from source"
---
{% include JB/setup %}

Linux & OS X
------------

You will need functioning [Go][1] and [Git][2] installations for this to work. 

If you don't have a GOPATH setup, create a directory for holding Go source code
and export the GOPATH variable:

    mkdir ~/gocode
    export GOPATH=~/gocode

Grab the Inbucket source code and compile the daemon:

    go get -v github.com/jhillyerd/inbucket

Edit etc/inbucket.conf and tailor to your environment.  It should work on most
Unix and OS X machines as is.  Launch the daemon:

    $GOPATH/bin/inbucket $GOPATH/src/github.com/jhillyerd/inbucket/etc/inbucket.conf

By default the SMTP server will be listening on localhost port 2500 and
the web interface will be available at [localhost:9000](http://localhost:9000/).

There are RedHat EL6 init, logrotate and httpd proxy configs provided in the etc directory.

[1]: http://golang.org/
[2]: http://git-scm.com/
