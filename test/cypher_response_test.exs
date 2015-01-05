defmodule NeoxirCypherResponseTest do

  use ExUnit.Case

  test "CypherResponse.to_rows" do
    body = "{\"results\":[{\"columns\":[\"x\"],\"data\":[{\"row\":[0]},{\"row\":[1]},{\"row\":[2]}]}],\"errors\":[]}"
    response = %Neoxir.CypherResponse{body: body}
    {:ok, rows} = Neoxir.CypherResponse.to_rows(response) 

    assert rows == [[%{x: 0}, %{x: 1}, %{x: 2}]]
  end

  test "CypherResponse.to_rows when errors" do
    body = "{\"results\":[],\"errors\":[{\"code\":\"Neo.ClientError.Statement.InvalidSyntax\",\"message\":\"Invalid input 'Q': expected 'e/E' (line 1, column 6)\\n\\\"CREATQQQ (n) RETURN ID(n) as x\\\"\\n      ^\"}]}"
    response = %Neoxir.CypherResponse{body: body}
    {:error, Neoxir.CypherResponse, descriptions} = Neoxir.CypherResponse.to_rows(response)
    description = List.first(descriptions)

    assert description["code"] == "Neo.ClientError.Statement.InvalidSyntax"
    assert Regex.match?(~r/Invalid input/, description["message"])
  end


  test "CypherResponse.to_rows multiple queries" do
    body = "{\"results\":[{\"columns\":[\"x1\"],\"data\":[{\"row\":[253]}]},{\"columns\":[\"x2\"],\"data\":[{\"row\":[254]}]}],\"errors\":[]}"
    response = %Neoxir.CypherResponse{body: body}
    {:ok, rows} = Neoxir.CypherResponse.to_rows(response) 

    assert rows == [[%{x1: 253}], [%{x2: 254}]]
  end


end
