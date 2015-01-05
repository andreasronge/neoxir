Neoxir
======

# What ?

An Elixir driver for the Neo4j Graph Database, see www.neo4j.org

# How ?

## Create a session

```elixir
{:ok, session} = Neoxir.create_session("http://localhost:7474") 
```

Or

```elixir
session = Neoxir.create_session! # http://localhost:7474 is default
```

## Transactions

All cypher operations are executed in a transaction using a session.

Commit a single cypher query

```elixir
{:ok, response} = Neoxir.commit(session, statement: "CREATE (n) RETURN ID(n)") 

# or, which might raise an exception:
response = Neoxir.commit!(session, statement: "CREATE (n) RETURN ID(n)") 
```

Commit multiple cypher queries, TODO

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

Multiple statements

```
{:ok, response} = Neoxir.commit(session, [statement: "MATCH (n) RETURN ID(n) as X LIMIT 3"]) 
# => [[%{x: 0}, %{x: 1}, %{x: 2}]]
```



