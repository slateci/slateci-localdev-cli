# Containerized SLATE Remote Client

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](http://unlicense.org/)

> **_IMPORTANT:_** This repository requires a read-through of [CLI Access](https://portal.slateci.io/cli) beforehand and if you have questions reach out to the team via SLACK, in an email, or during the working-sessions.

This repository contains a configurable container with the SLATE Remote Client.

## Requirements

### Install Docker

Install [Docker](https://docs.docker.com/get-docker/) for developing, managing, and running OCI containers on your host.

### Create `envs.yml`

1. This fill will be ignored by version control.
2. Copy `secrets/envs.yml.tmpl` to the following place in this repository: `secrets/envs.yml`. 
3. Replace the placeholder text with actual values.
4. The quickest way to gather the API Tokens for each of the API servers is via their Portals.
   * Find the `dev` API token at [https://portal.dev.slateci.io/cli](https://portal.dev.slateci.io/cli).
   * Find the `staging` API token at [https://portal.staging.slateci.io/cli](https://portal.staging.slateci.io/cli).
   * And so forth.

## Run the SLATE Remote Client

Start the SLATE Remote Client for `dev`, `staging`, `prod`, or `prod2`.
* The `work` directory in this repository will be mounted to the container at `/work` for convenience. All content in this directory will be ignored by version control.
* Windows hosts will not be able to use the `-s` option below as `make.bat` is taking the place of `Makefile`.

```shell
[your@localmachine]$ make -s dev
Sending build context to Docker daemon  16.38kB
Step 1/18 : FROM rockylinux/rockylinux:8
 ---> a1e37a3cce8f
...
...
====================================================================================
= Connection Information                                                           =
====================================================================================
Endpoint: https://api.dev.slateci.io:443

Name ID Email Phone
JOHN DOE user_K-ABCDefxyz john.doe@test.com 888 888 8888

Client Version Server Version
0.0.6          1.0.0         
Server supported API versions: v1alpha3




[root@ef75bd49ca39 work]#
```

Run the `slate` commands normally.

```shell
[root@ef75bd49ca39 work]# slate cluster list
Name         Admin         ID                 
river-dev-fp doe-test cluster_ABCDEFG000H
```

When you are finished exit the container.

```shell
[root@ef75bd49ca39 work]# exit
exit
[your@localmachine]$
```

## Persistent Bash History

The `bash` history is saved to `work/.bash_history_docker` in this repository and will persist for all containers unless the file is manually deleted.

```shell
[root@ef75bd49ca39 work]# history
    1  echo 'hello world'
    2  ls -al
    3  exit
    4  history
    5  exit
    6  history
```

## Update this Code-base

Periodically it will become necessary to update the `VERSION` variable used by `make` when a new SLATE CLI version is released. Create a new commit on *master* and tag it with the corresponding version of the SLATE CLI.

For example:

```shell
VERSION = "1.0.23"
```

warrants a Git tag of `v1.0.23`.
