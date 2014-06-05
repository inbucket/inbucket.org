---
title: Run Inbucket with Docker
layout: post
---

Inbucket now includes a Dockerfile, which allows you to build a 
[Docker](https://www.docker.io/) image.  I’ve setup a
[trusted build](https://index.docker.io/u/jhillyerd/inbucket/) for Inbucket,
so you don’t even have to build your own image.  Try it out:

    docker run -p 9000:10080 -p 2500:10025 jhillyerd/inbucket

Then point your browser at [localhost:9000](http://localhost:9000/)
