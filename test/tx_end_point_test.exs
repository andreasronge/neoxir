defmodule NeoxirTxEndPointTest do


  defmodule Commit do

     use ExUnit.Case, async: true
     import Neoxir, only: [create_session: 0]

     setup_all do
        {:ok, %{session: create_session}}
     end


     test "many valid cypher queries", %{session: session}  do
      statements = [
        [statement: "CREATE (n) RETURN ID(n) as x1"],
        [statement: "CREATE (n) RETURN ID(n) as x2"]
      ]

      response = Neoxir.TxEndPoint.commit(session, statements)
      assert response.status_code == 200
      assert String.valid?(response.body)
    end


    test "with rest response", %{session: session} do
      statement = "CREATE (TheMatrix:Movie {title:'The Matrix', released:1999, tagline:'Welcome to the Real World'}) return TheMatrix"
      response = Neoxir.TxEndPoint.commit(session, statement: statement, resultDataContents: [ "REST" ])
      assert response.status_code == 200
      assert String.valid?(response.body)
      assert Regex.match?(~r/metadata/, response.body)
    end


    test "a valid cypher query", %{session: session} do
      response = Neoxir.TxEndPoint.commit(session, statement: "CREATE (n) RETURN ID(n)") 
      assert response.status_code == 200
      assert String.valid?(response.body)
    end


    test "commit and to_rows", %{session: session} do
      response = Neoxir.TxEndPoint.commit(session, statement: "CREATE (n) RETURN ID(n) as x") 
      {:ok, rows} = Neoxir.CypherResponse.to_rows(response) 

      assert length(rows) == 1
      first_result = List.first(rows)
      assert length(first_result) == 1

      first_row = List.first(first_result)
      assert Dict.keys(first_row) == [:x]
      assert is_number(first_row[:x])
    end


    test "an invalid cypher query", %{session: session} do
      response = Neoxir.TxEndPoint.commit(session, statement: "CREATEA (n) RETURN ID(n)")
      assert response.status_code == 200
      assert String.valid?(response.body)
    end

  end


 
  # begin_tx


  # test "begin_tx" do
  #   tx = session |> begin_tx
  #   assert Regex.match?(~r/data\/transaction\/\d+\/commit/, tx.commit_url) 
  #   assert tx.errors == []
  #   assert String.length(tx.expires) == 31
  # end

  # test "create a node and return rest result" do
  #   # "resultDataContents" : [ "REST" ]
  #   {:ok, session} = Neoxir.session
  #   {:ok, tx} = Neoxir.TxEndPoint
  #   {:ok, response} = Neoxir.TxEndPoint.commit(session, [statement: "CREATE (n) RETURN n", resultDataContents: [ "REST" ]])
  #   assert response == ""
  # end


end
