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

Inbucket has built-in SMTP and POP3 servers which store incoming mail as flat
files on disk - no external SMTP or database daemons required.

Inbucket in action: [Screenshots]({{ BASE_PATH }}/screenshots.html)

Download the latest release here: [bintray quick links]({{ BASE_PATH}}/bintray.html)

Features
--------

Mail features:

 * Receive and store E/SMTP messages
 * Purge messages after a configurable amount of time
 * Enforce a cap on the number of messages per mailbox by deleting older messages
 * Optional load test mode; messages are never written to disk
 * Access mail via embedded POP3 server

Web interface features:

 * List messages in a mailbox
 * Displays text content of a particular message
 * Displays source of a message (headers + body text)
 * Displays HTML version of a message (in a new window)
 * List MIME attachments with buttons to display or download
 * Delete a message
 * RESTful: [REST API docs](https://github.com/jhillyerd/inbucket/wiki/REST-API)

Development Status [![Build Status](https://travis-ci.org/jhillyerd/inbucket.png?branch=master)](https://travis-ci.org/jhillyerd/inbucket)
------------------

Inbucket is currently release-candidate quality: it is being used for real work.

Please check the [issues list](https://github.com/jhillyerd/inbucket/issues?state=open)
for more details.

The source code can be found on [github](https://github.com/jhillyerd/inbucket).

Installation
------------

Precompiled binaries are available for download on our
[bintray repository](https://bintray.com/jhillyerd/golang/inbucket).

Guides:

 * [Installation from Source]({{ BASE_PATH }}/installation/from-source.html)
 * [RedHat Installation]({{ BASE_PATH }}/installation/redhat.html)
 * [Ubuntu Installation]({{ BASE_PATH }}/installation/ubuntu.html)

About
-----
Inbucket is written in [Google Go][1].

Inbucket is open source software released under the MIT License.  The latest
version can be found at [github](https://github.com/jhillyerd/inbucket).

[1]: http://golang.org/

