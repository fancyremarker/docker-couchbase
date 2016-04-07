# ![](https://gravatar.com/avatar/11d3bc4c3163e3d238d558d5c9d98efe?s=64) aptible/couchbase

[![Build Status](https://travis-ci.org/aptible/docker-couchbase.svg?branch=master)](https://travis-ci.org/aptible/docker-couchbase)

Couchbase on Docker

## Installation and Usage

    docker pull quay.io/aptible/couchbase

This is an image conforming to the [Aptible database specification](https://support.aptible.com/topics/paas/deploy-custom-database/). To run a server for development purposes, execute

    docker create --name data quay.io/aptible/couchbase
    docker run --volumes-from data -e PASSPHRASE=pass quay.io/aptible/couchbase --initialize
    docker run --volumes-from data -P quay.io/aptible/couchbase

The first command sets up a data container named `data` which will hold the configuration and data for the database. The second command creates a Couchbase cluster with the passphrase of your choice. The third command starts the database server.

## Available Tags

* `latest`: Currently Couchbase 4.1.0 Enterprise
* `4.1`: Couchbase 4.1.0 Enterprise

## Deployment

To push the Docker image to Quay, run the following command:

    make release

## Copyright and License

MIT License, see [LICENSE](LICENSE.md) for details.

Copyright (c) 2016 [Aptible](https://www.aptible.com) and contributors.

[<img src="https://s.gravatar.com/avatar/f7790b867ae619ae0496460aa28c5861?s=60" style="border-radius: 50%;" alt="@fancyremarker" />](https://github.com/fancyremarker)
