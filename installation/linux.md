---
layout: default
title: Linux Installation
description: How to install Inbucket on Linux
---

## Install Inbucket on a systemd equipped Linux

The commands below should be run as root.

### 1. Install Package

For Debian based distributions, run:

~~~ sh
dpkg -i inbucket_VER_linux_amd64.deb
systemctl enable inbucket
~~~

For RedHat based distributions, run:

~~~ sh
rpm -ivh inbucket_VER_linux_amd64.rpm
systemctl enable inbucket
~~~

### 2. Enable & Start Inbucket

Start the daemon and check for errors:

1. Have the daemon start at boot: <kbd>systemctl enable inbucket</kbd>
2. Start the daemon: <kbd>systemctl start inbucket</kbd>
3. Confirm it stayed running: <kbd>systemctl status inbucket</kbd>
4. Check for startup errors: <kbd>journalctl -u inbucket</kbd>

### 3. Access Web Interface

Confirm that Inbucket is listening on the default port:
[localhost:9000](http://localhost:9000/).

### 4. Customize Inbucket Configuration

Inbucket is configured via environment variables, please see [config.md] for
more information.  You need to modify the `Environment=` statements in
`/etc/systemd/system/multi-user.target.wants/inbucket.service` for the
configuration changes to become permanent.

If something goes wrong, you may refer to the default [systemd unit] on GitHub.

[config.md]:    https://github.com/jhillyerd/inbucket/blob/master/doc/config.md
[systemd unit]: https://github.com/jhillyerd/inbucket/blob/master/etc/linux/inbucket.service
