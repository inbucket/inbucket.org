---
layout: default
title: About Inbucket
group: about
---

## What is it?

Inbucket allows web developers, software engineers and system administrators to
quickly see the emailed output of their applications.  No per-account setup is
required! Mailboxes are created on the fly as mail is received for them, and
no password is required to browse the content of the mailboxes.

Inbucket has built-in SMTP and POP3 servers which store incoming mail as flat
files on disk - no external SMTP or database daemons required.

Inbucket was written in [Google Go][1] and is open source software released
under the MIT License.

## Mail features

 * Receive and store E/SMTP messages
 * Purge messages after a configurable amount of time
 * Enforce a cap on the number of messages per mailbox by deleting older messages
 * Optional load test mode; messages are never written to disk
 * Access mail via embedded POP3 server

## Web-interface features

 * List messages in a mailbox
 * Displays text content of a particular message
 * Displays source of a message (headers + body text)
 * Displays HTML version of a message (in a new window)
 * List MIME attachments with buttons to display or download
 * Delete a message
 * RESTful: [REST API docs](https://github.com/jhillyerd/inbucket/wiki/REST-API)


[1]: http://golang.org/

