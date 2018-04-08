---
layout: default
title: Installation From Source
description: How to install Inbucket from source
---

## Prerequisites

You will need functioning [Go] and [Git] installations for this to work.

If you are running on Windows, you will need to perform the steps in this
document from within Git Bash shell, otherwise Go will be unable to clone
(download) the Inbucket source code and its dependencies.

If you don't have a `GOPATH` setup, create a directory for holding Go source
code and export the `GOPATH` variable:

~~~ sh
mkdir ~/go
export GOPATH=~/go
~~~


## Building

Grab the Inbucket source code and compile the daemon:

~~~ sh
go get -v github.com/jhillyerd/inbucket/cmd/inbucket
~~~


## Launching

Test launching the daemon on Linux, OS X, and Windows:

~~~ sh
cd $GOPATH/src/github.com/jhillyerd/inbucket
$GOPATH/bin/inbucket
~~~

By default the SMTP server will be listening on localhost port 2500 and the web
interface will be available at [localhost:9000](http://localhost:9000/).


## Next Steps

Inbucket is configured via environment variables, please see [config.md] for
more information.

If you would like to Inbucket run as a daemon, please use the [systemd unit]
used by our Linux packages as a template.

[Go]:           http://golang.org/
[Git]:          http://git-scm.com/
[config.md]:    https://github.com/jhillyerd/inbucket/blob/master/doc/config.md
[systemd unit]: https://github.com/jhillyerd/inbucket/blob/master/etc/linux/inbucket.service
