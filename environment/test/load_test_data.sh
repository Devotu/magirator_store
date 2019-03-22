#!/bin/bash
cypher-shell \
 -a bolt://localhost:7401 \
 -u neo4j \
 -p neo4j400 \
 --format plain < test_data.cypher
