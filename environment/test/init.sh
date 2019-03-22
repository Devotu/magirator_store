#!/bin/bash
echo "Starting neo4j"
sh ./neo4j.sh
echo "Waiting 5s"
sleep 5s
echo "Loading data"
sh ./load_test_data.sh
#echo "Setting config"
#cp db.conf ../../conf/db.conf
echo "Done"
