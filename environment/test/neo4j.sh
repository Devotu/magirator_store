#!/bin/bash
docker run \
    -d \
    --publish=7400:7474 --publish=7401:7687 \
    --mount source=data_400,target=/data \
    --mount source=log_400,target=/logs \
    neo4j:3.0
