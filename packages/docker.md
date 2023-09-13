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
We’ve setup an [Automated Build] for Inbucket, so you don’t have to build
your own image.  Try it out:

    docker run -d --name inbucket -p 9000:9000 -p 2500:2500 -p 1100:1100 inbucket/inbucket

Then point your browser at [localhost:9000](http://localhost:9000/)


## Image Tags

* `latest` tracks tagged Inbucket releases
* `edge` tracks the potentially unstable `main` branch


## Volumes

* `/config` will contain the default `greeting.html` file (after first start,)
  which may be customized for your users
* `/storage` holds emails received by Inbucket


## Default Configuration

The initial configuration is set by the `ENV` statements in the Configuration
section of our [Dockerfile].  You may use Docker environment variables to
override or further customize Inbucket.


[Docker]:          https://www.docker.com/
[Dockerfile]:      https://github.com/inbucket/inbucket/blob/main/Dockerfile
[Automated Build]: https://hub.docker.com/r/inbucket/inbucket/
