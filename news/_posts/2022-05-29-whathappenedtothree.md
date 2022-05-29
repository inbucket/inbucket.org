---
title: What happened to 3.0?
layout: post
---

We released Inbucket 3.0.0 back in October 2021, but I forgot to write a post
about it.  Mea culpa.

There were some problems with the initial release, the RedHat and Debian
packages were incomplete.  I began work on a 3.0.1 release to resolve that and
upgrade some of our dependencies, but some aspects of the front end build were
not cooperating.

I've since migrated the front end to build with Yarn and Parcel, which
simplifies things a great deal, and will hopefully reduce maintenance effort for
myself.  I feel this is too much of a change to keep the 3.0.1 label, so this
will become 3.0.2.  There will not be a final 3.0.1 release.

What does this mean for you?  If you want a stable docker release, you should be
OK to use 3.0.0.  If you want a stable RedHat or Debian package, you should use
3.0.1-rc2.

**What's New:**

Change highlights from 3.0.0-rc1 to 3.0.1-rc2:

- Many bug fixes, build & test improvements
- Support for SMTP AUTH LOGIN command
- Dark mode support; follows OS setting
- Reduced chance of click-jacking
- Docker images also available on GitHub container registry
- Docker image tags now use modern naming:
  - `stable` has been renamed to `latest`
  - `latest` (unstable) has been renamed to `edge`
  - Version number tags are now available, ie `3.0.1-rc1`
- Docker images for arm7, arm64 (for Raspberry Pi, etc)

I also updated the screenshots on this site to reflect the 3.0 user interface.

[Full
Changelog](https://github.com/inbucket/inbucket/blob/v3.0.1-rc2/CHANGELOG.md)
