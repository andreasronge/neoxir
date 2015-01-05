defmodule NeoxirTest do

  import Neoxir
  use ExUnit.Case

  # create_session

  test "create_session: returns a session struct" do
    session = create_session
    assert session.root_url == "http://localhost:7474/" 
    assert session.data_url == "http://localhost:7474/db/data/"
    assert String.valid?(session.root_resource["neo4j_version"])
  end

  # commit

  test "commit: single valid statement" do
    {:ok, response} = commit(create_session, statement: "CREATE (n) RETURN ID(n) as x")
    assert length(response) == 1
    first_row = List.first(response)
    assert Dict.keys(first_row) == [:x]
    assert is_number(first_row[:x])
  end

  test "commit: many valid statements" do
    statements = [
      [statement: "CREATE (n) RETURN ID(n) as x1"],
      [statement: "CREATE (n) RETURN ID(n) as x2"]
    ]

    {:ok, response} = commit(create_session, statements)

    [_, second_result ] = response

    assert length(second_result) == 1
    first_row = List.first(second_result)
    assert Dict.keys(first_row) == [:x2]
    assert is_number(first_row[:x2])
  end


  test "commit: single invalid statement" do
    {:error, Neoxir.CypherResponse, reason} = commit(create_session, statement: "CREATQQQ (n) RETURN ID(n) as x")
    assert reason["code"] == "Neo.ClientError.Statement.InvalidSyntax"
    assert Regex.match?(~r/Invalid input/, reason["message"])
  end


  test "commit: many invalid statements" do
    statements = [
      [statement: "QQCREATE (n) RETURN ID(n) as x1"],
      [statement: "AAAAREATE (n) RETURN ID(n) as x2"]
    ]

    {:error, _, response} = commit(create_session, statements)
    assert response == [%{"code" => "Neo.ClientError.Statement.InvalidSyntax",
   "message" => "Invalid input 'Q': expected <init> (line 1, column 1)\n\"QQCREATE (n) RETURN ID(n) as x1\"\n ^"}]
  end


  # commit!

  test "commit!: single valid statement" do
    response = commit!(create_session, statement: "CREATE (n) RETURN ID(n) as x")
    assert length(response) == 1
    first_row = List.first(response)
    assert Dict.keys(first_row) == [:x]
    assert is_number(first_row[:x])
  end

  test "commit!: invalid statement" do
    assert_raise Neoxir.CypherResponseError, ~r/Invalid input/, fn ->
      commit!(create_session, statement: "CCCCREATE (n) RETURN ID(n) as x")
    end    
  end

end
