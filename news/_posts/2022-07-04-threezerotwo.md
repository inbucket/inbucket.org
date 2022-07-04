---
title: Official release of Inbucket 3.0.2
layout: post
---

Release 3.0.2 resolves build and packaging issues we ran into with previous 3.0
releases.  The user experience should be the same as 3.0.1-rc2.

**Changes from 3.0.1:**

- arm Docker builds now rely on amd64 frontend build stage
- Frontend build migrated from npm+webpack to yarn+parcel, node 16

Binaries and Linux packages available [on GitHub](
https://github.com/inbucket/inbucket/releases/tag/v3.0.2)
