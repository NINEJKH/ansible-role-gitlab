#!/usr/bin/env bash

set -e

systemctl stop docker-registry
docker exec registry docker-distribution-pruner -config=/etc/docker/registry/config.yml -delete -soft-delete=false -verbose=false
docker exec registry /bin/registry garbage-collect /etc/docker/registry/config.yml
systemctl start docker-registry
