defmodule NeoxirTxEndPointTest do

  use ExUnit.Case
  import Neoxir, only: [create_session: 0]

  # Neoxir.TxEndPoint.commit


  test "Neoxir.TxEndPoint.commit: many valid cypher queries" do
    statements = [
      [statement: "CREATE (n) RETURN ID(n) as x1"],
      [statement: "CREATE (n) RETURN ID(n) as x2"]
    ]

    response = Neoxir.TxEndPoint.commit(create_session, statements) # , resultDataContents: [ "REST" ]
    assert response.status_code == 200
    assert String.valid?(response.body)
  end


  test "Neoxir.TxEndPoint.commit: a valid cypher query" do
    response = Neoxir.TxEndPoint.commit(create_session, statement: "CREATE (n) RETURN ID(n)") 
    assert response.status_code == 200
    assert String.valid?(response.body)
  end


  test "Neoxir.TxEndPoint.commit and to_rows" do
    response = Neoxir.TxEndPoint.commit(create_session, statement: "CREATE (n) RETURN ID(n) as x") 
    {:ok, rows} = Neoxir.CypherResponse.to_rows(response) 

    assert length(rows) == 1
    first_result = List.first(rows)
    assert length(first_result) == 1

    first_row = List.first(first_result)
    assert Dict.keys(first_row) == [:x]
    assert is_number(first_row[:x])
  end


  test "commit an invalid cypher query" do
    response = Neoxir.TxEndPoint.commit(create_session, statement: "CREATEA (n) RETURN ID(n)")
    assert response.status_code == 200
    assert String.valid?(response.body)
  end

  # begin_tx


  # test "begin_tx" do
  #   tx = create_session |> begin_tx
  #   assert Regex.match?(~r/data\/transaction\/\d+\/commit/, tx.commit_url) 
  #   assert tx.errors == []
  #   assert String.length(tx.expires) == 31
  # end

  # test "create a node and return rest result" do
  #   # "resultDataContents" : [ "REST" ]
  #   {:ok, session} = Neoxir.create_session
  #   {:ok, tx} = Neoxir.TxEndPoint
  #   {:ok, response} = Neoxir.TxEndPoint.commit(session, [statement: "CREATE (n) RETURN n", resultDataContents: [ "REST" ]])
  #   assert response == ""
  # end


end
