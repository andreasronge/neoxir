
defmodule Neoxir.TxEndPoint do
  @headers %{"Accept" => "application/json; charset=UTF-8", "Content-Type" => "application/json"}


  # Begin and commit a transaction in one request
  # If there is no need to keep a transaction open across multiple HTTP requests, 
  # you can begin a transaction, execute statements, and commit with just a single HTTP request.
  def commit(%Neoxir.Session{tx_end_point_url: tx_end_point_url}, [head|_] = statements) when is_list head do
    payload = JSX.encode! statements: statements
    response = HTTPoison.post!("#{tx_end_point_url}/commit", payload, @headers)
    %Neoxir.CypherResponse{status_code: response.status_code, body: response.body} # results: body["results"], errors: body["errors"]
  end

  def commit(session = %Neoxir.Session{}, statement) do 
    commit(session, [statement])
  end


  # Commit an open transaction
  # Given you have an open transaction, you can send a commit request. 
  # Optionally, you submit additional statements along with the request that will be executed before committing the transaction.
  def commitx(transaction, statements) do
  end

  # Begin a transaction
  # You begin a new transaction by posting zero or more Cypher statements to the transaction endpoint. 
  # The server will respond with the result of your statements, as well as the location of your open transaction.
  def begin_tx(%Neoxir.Session{tx_end_point_url: tx_end_point_url}, statements \\ []) do
    {:ok, payload}  = JSX.encode [statements: statements]
    {:ok, response} = HTTPoison.post(tx_end_point_url, payload, @headers)
    {:ok, body }    = JSX.decode response.body

    %Neoxir.Transaction{commit_url: body["commit"], errors: body["errors"], expires: body["transaction"]["expires"]}
  end

  # Execute statements in an open transaction
  # Given that you have an open transaction, you can make a number of requests, each of which executes additional statements,
  # and keeps the transaction open by resetting the transaction timeout.
  def execute(transaction, statements) do
  end


  # Execute statements in an open transaction in REST format for the return
  # Given that you have an open transaction, you can make a number of requests, each of which executes additional statements, and keeps the transaction open by resetting the transaction timeout. Specifying the REST format will give back full Neo4j Rest API representations of the Neo4j Nodes, Relationships and Paths, if returned.


  # Reset transaction timeout of an open transaction
  # Every orphaned transaction is automatically expired after a period of inactivity. This may be prevented by resetting the transaction timeout.
  # The timeout may be reset by sending a keep-alive request to the server that executes an empty list of statements. This request will reset the transaction timeout and return the new time at which the transaction will expire as an RFC1123 formatted timestamp value in the “transaction” section of the response.
  def reset(transaction) do
  end



  # Rollback an open transaction
  # Given that you have an open transaction, you can send a roll back request. The server will roll back the transaction.
  def rollback(transaction) do
  end

end