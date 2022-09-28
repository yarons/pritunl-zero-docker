# Pritunl-Zero-Docker
[![Docker Image CI](https://github.com/yarons/pritunl-zero-docker/actions/workflows/docker-image.yml/badge.svg)](https://github.com/yarons/pritunl-zero-docker/actions/workflows/docker-image.yml)

Dockerfile and docker-compose for Pritunl-Zero

Please notice there are numerous Pritunl-Zero Docker implementations around, the special thing about this implementation is the fact that it can run on different architectures other than x86.

This is a licensed software, you'll have to buy a license to fully unlock its features, this implementation is unlicensed.

Please notice that the bastion is configured by default to the official version which doesn't support ARM, make sure to change the bastion server in the configuration if you plan to use it.
