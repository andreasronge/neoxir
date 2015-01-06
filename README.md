# Neoxir
[![Build Status](https://travis-ci.org/andreasronge/neoxir.svg?branch=master)](https://travis-ci.org/andreasronge/neoxir)

An Elixir driver for the Neo4j Graph Database, see www.neo4j.org

## Create a session

```elixir
{:ok, session} = Neoxir.create_session("http://localhost:7474") 
```

Or

```elixir
session = Neoxir.create_session! # http://localhost:7474 is default
```

## Transactions

All cypher operations are executed in transactions.

Commit a single cypher query

```elixir
{:ok, response} = Neoxir.commit(session, statement: "CREATE (n) RETURN ID(n)") 

# or, which might raise an exception:
response = Neoxir.commit!(session, statement: "CREATE (n) RETURN ID(n)") 
```

Commit multiple cypher queries:

```elixir
{:ok, response} = Neoxir.commit(session, [statement: "CREATE (n) RETURN ID(n)", statement: "..."]) 
```

## Reuse transaction

TODO

```elixir
transaction = Neoxir.begin_tx!(session, \\ [statements: "..."])
response = Neoxir.execute!(transaction, statement: "CREATE (n) RETURN ID(n)")
Neoxir.commit!(transaction, \\ [statements: "..."])
```

## Cypher Response

Single statement

```elixir
{:ok, response} = Neoxir.commit(session, statement: "MATCH (n) RETURN ID(n) as X LIMIT 3") 
# => [%{x: 0}, %{x: 1}, %{x: 2}]
```

REST response

```elixir
{:ok, response} = commit(session, statement: "CREATE (n {name: 'andreas'}) RETURN n", resultDataContents: [ "REST" ])
# => [%{n: %{"all_relationships" => "http://localhost:7474/db/data/node/886/relationships/all",
#    "all_typed_relationships" => "http://localhost:7474/db/data/node/886/relationships/all/{-list|&|types}",
# ...
```

Multiple statements

```
{:ok, response} = Neoxir.commit(session, [statement: "MATCH (n) RETURN ID(n) as X LIMIT 3"]) 
# => [[%{x: 0}, %{x: 1}, %{x: 2}]]
```



