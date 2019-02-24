---
title: Release candidate for 2.0.0
layout: post
---

The first release candidate for Inbucket 2.0.0 is out!

**What's New:**

A *lot* has changed, but a few of the highlights:

- In-memory storage option, best for small installations and desktops.  Will be
  used by default.
- Message seen flag in REST and Web UI so you can see which messages have
  already been read.
- Configurable support for identifying a mailbox by full email address instead
  of just the local part (username).

This release also includes changes to how Inbucket is configured, default ports
in Docker, and the format of log output.

[Full
Changelog](https://github.com/inbucket/inbucket/blob/v2.0.0-rc1/CHANGELOG.md)
