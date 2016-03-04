---
layout: default
title: Docker Image
tagline: Run Inbucket in a container
---

> Docker containers wrap up a piece of software in a complete filesystem that
> contains everything it needs to run: code, runtime, system tools, system
> libraries – anything you can install on a server. This guarantees that it will
> always run the same, regardless of the environment it is running in.

Inbucket now includes a Dockerfile, which allows you to build a [Docker] image.
I’ve setup an [Automated Build] for Inbucket, so you don’t even have to build
your own image.  Try it out:

    docker run -p 9000:10080 -p 2500:10025 jhillyerd/inbucket

Then point your browser at [localhost:9000](http://localhost:9000/)

[Docker]:          https://www.docker.com/
[Automated Build]: https://hub.docker.com/r/jhillyerd/inbucket/
