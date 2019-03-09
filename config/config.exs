# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Configures Neo4j driver
config :bolt_sips, Bolt,
  hostname: 'localhost',
  basic_auth: [username: "neo4j", password: "neo4j400"],
  port: 7401,
  pool_size: 5,
  max_overflow: 1
