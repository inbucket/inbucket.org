---
title: Inbucket 3.2.0 released
layout: post
---

Inbucket 3.2.0 is out.  The headline feature is automatic TLS certificate
reloading: when your certificate or key files change on disk, Inbucket picks
up the new ones without a restart.
Other improvements:

- TLS+POP3 related bug fixes
- Header decoding failures are now logged, making misbehaving mail easier to
  diagnose
- Routine dependency and build updates

More details in the
[CHANGELOG](https://github.com/inbucket/inbucket/blob/v3.2.0/CHANGELOG.md)

Binaries and Linux packages available [on GitHub](
https://github.com/inbucket/inbucket/releases/tag/v3.2.0)
