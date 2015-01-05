Neoxir
======


## Create a session

  session = Neoxir.create_session("http://localhost:7474") # http://localhost:7474 is default


## Transactions

All cypher operations are executed in a transaction using a session.

Commit a single cypher query

  {:ok, response} = Neoxir.commit(session, statement: "CREATE (n) RETURN ID(n)") 

Commit multiple cypher queries

  {:ok, response} = Neoxir.commit(session, [statement: "CREATE (n) RETURN ID(n)", statement: "..."]) 


## Cypher Response

Single statement

  {:ok, response} = Neoxir.commit(session, statement: "MATCH (n) RETURN ID(n) as X LIMIT 3") 
  # => [%{x: 0}, %{x: 1}, %{x: 2}]

Multiple statements

  {:ok, response} = Neoxir.commit(session, [statement: "MATCH (n) RETURN ID(n) as X LIMIT 3"]) 
  # => [[%{x: 0}, %{x: 1}, %{x: 2}]]


