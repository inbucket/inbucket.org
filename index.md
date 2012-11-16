---
layout: page
title: Inbucket
tagline: Simple disposable webmail system
---
{% include JB/setup %}

Inbucket is an email testing service; it will accept messages for any email
address and make them available to view via a web interface.

It allows web developers, software engineers and system administrators to
quickly see the emailed output of ther applications.  No per-account setup is
required! Mailboxes are created on the fly as mail is received for them, and
no password is required to browse the content of the mailboxes.

Inbucket has a built-in SMTP server and stores incoming mail as flat files on
disk - no external SMTP or database daemons required.

Inbucket in action: [Screenshots]({{ BASE_PATH }}/screenshots.html)

Features
--------

SMTP features:

 * Receive and store E/SMTP messages
 * Purge messages after a configurable amount of time
 * Optional load test mode; messages are never written to disk

Web interface features:

 * List messages in a mailbox
 * Displays text content of a particular message
 * Displays source of a message (headers + body text)
 * Displays HTML version of a message (in a new window)
 * List MIME attachments with buttons to display or download
 * Delete a message

Not implemented yet:

 * Display inline attachments within HTML email

Development Status
------------------

Inbucket is currently beta quality: it works but is not well tested.

Please check the [issues list](https://github.com/jhillyerd/inbucket/issues?state=open)
for more details.

The source code can be found on [github](https://github.com/jhillyerd/inbucket).

Installation
------------

Precompiled binaries are available on the github
[downloads page](https://github.com/jhillyerd/inbucket/downloads).  I don't compile new
binaries each time I commit a change, so you'll want to compile from source to get the
latest version.

Guides:

 * [Installation from Source]({{ BASE_PATH }}/installation/from-source.html)

About
-----
Inbucket is written in [Google Go][1].

Inbucket is open source software released under the MIT License.  The latest
version can be found at [github](https://github.com/jhillyerd/inbucket).

[1]: http://golang.org/

