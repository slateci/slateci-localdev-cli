# Containerized SLATE Remote Client

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](http://unlicense.org/)

> **_IMPORTANT:_** This repository requires a read-through of [CLI Access](https://portal.slateci.io/cli) beforehand and if you have questions reach out to the team via SLACK, in an email, or during the working-sessions.

This repository contains a configurable container with the latest SLATE Remote Client.

## Requirements

### Install Docker

Install [Docker](https://docs.docker.com/get-docker/) for developing, managing, and running OCI containers on your host.

#### Podman Support

For those using Podman, either set up a shell alias or replace `docker` with `podman` in your copy of the `Makefile` and example commands below.

### Create `envs.yml`

1. This fill will be ignored by version control.
2. Copy `secrets/envs.yml.tmpl` to the following place in this repository: `secrets/envs.yml`. 
3. Replace the placeholder text with actual values.
4. The quickest way to gather the API Tokens for each of the API servers is via their Portals.
   * Find the `dev` API token at [https://portal.dev.slateci.io/cli](https://portal.dev.slateci.io/cli).
   * Find the `staging` API token at [https://portal.staging.slateci.io/cli](https://portal.staging.slateci.io/cli).
   * And so forth.

## Run the SLATE Remote Client

> **_NOTE:_** If a new SLATE Remote Client is released on GitHub, refer to the image cleanup information below to force a fresh client download.

Start the SLATE Remote Client for `dev`, `staging`, or `prod`.
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

### Specify a SLATE Client Version

Use different versions of the SLATE Remote Client by locally modifying the ``VERSION`` variable in ``./Makefile``. E.g.

```makefile
VERSION = "1.0.24"
```

## Image Clean Up

Remove the `slate-remote-client:local` Docker image from your system:

```shell
[your@localmachine]$ make clean
docker image rm slate-remote-client:local -f
Untagged: localhost/slate-remote-client:local
Deleted: 8367a39efdecc3f56eabc68c3392e69f5c54ca012e4420d5d5cf0c872d2d4321
...
...
```

If followed up by `make <env>`, a fresh copy of the SLATE Remote Client will be downloaded. This will catch any new releases that occurred since the image was created when `VERSION = "latest"` remains set in the `Makefile`.

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
