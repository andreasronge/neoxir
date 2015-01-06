defmodule NeoxirCypherResponseTest do


 

  defmodule ToRows do
  use ExUnit.Case, async: true

    test "CypherResponse.to_rows" do
      body = "{\"results\":[{\"columns\":[\"x\"],\"data\":[{\"row\":[0]},{\"row\":[1]},{\"row\":[2]}]}],\"errors\":[]}"
      response = %Neoxir.CypherResponse{body: body}
      {:ok, rows} = Neoxir.CypherResponse.to_rows(response) 

      assert rows == [[%{x: 0}, %{x: 1}, %{x: 2}]]
    end

    test "when errors" do
      body = "{\"results\":[],\"errors\":[{\"code\":\"Neo.ClientError.Statement.InvalidSyntax\",\"message\":\"Invalid input 'Q': expected 'e/E' (line 1, column 6)\\n\\\"CREATQQQ (n) RETURN ID(n) as x\\\"\\n      ^\"}]}"
      response = %Neoxir.CypherResponse{body: body}
      {:error, Neoxir.CypherResponse, descriptions} = Neoxir.CypherResponse.to_rows(response)
      description = List.first(descriptions)

      assert description["code"] == "Neo.ClientError.Statement.InvalidSyntax"
      assert Regex.match?(~r/Invalid input/, description["message"])
    end


    test "multiple queries" do
      body = "{\"results\":[{\"columns\":[\"x1\"],\"data\":[{\"row\":[253]}]},{\"columns\":[\"x2\"],\"data\":[{\"row\":[254]}]}],\"errors\":[]}"
      response = %Neoxir.CypherResponse{body: body}
      {:ok, rows} = Neoxir.CypherResponse.to_rows(response) 

      assert rows == [[%{x1: 253}], [%{x2: 254}]]
    end

    test "complex results" do
      body =  "{\"results\":[{\"columns\":[\"name\",\"related_type\",\"related_to\"],\"data\":[{\"row\":[\"Tom Hanks\",\"ACTED_IN\",{\"roles\":[\"Zachry\",\"Dr. Henry Goose\",\"Isaac Sachs\",\"Dermot Hoggins\"]}]},{\"row\":[\"Hugo Weaving\",\"ACTED_IN\",{\"roles\":[\"Bill Smoke\",\"Haskell Moore\",\"Tadeusz Kesselring\",\"Nurse Noakes\",\"Boardman Mephi\",\"Old Georgie\"]}]},{\"row\":[\"Halle Berry\",\"ACTED_IN\",{\"roles\":[\"Luisa Rey\",\"Jocasta Ayrs\",\"Ovid\",\"Meronym\"]}]},{\"row\":[\"Jim Broadbent\",\"ACTED_IN\",{\"roles\":[\"Vyvyan Ayrs\",\"Captain Molyneux\",\"Timothy Cavendish\"]}]},{\"row\":[\"Tom Tykwer\",\"DIRECTED\",{}]},{\"row\":[\"Andy Wachowski\",\"DIRECTED\",{}]},{\"row\":[\"Lana Wachowski\",\"DIRECTED\",{}]},{\"row\":[\"Stefan Arndt\",\"PRODUCED\",{}]},{\"row\":[\"David Mitchell\",\"WROTE\",{}]},{\"row\":[\"Jessica Thompson\",\"REVIEWED\",{\"summary\":\"An amazing journey\",\"rating\":95}]}]}],\"errors\":[]}"
      response = %Neoxir.CypherResponse{body: body}
      {:ok, [rows|_]} = Neoxir.CypherResponse.to_rows(response) 

      assert length(rows) == 10
      assert List.last(rows) == %{name: "Jessica Thompson", related_to: %{"rating" => 95, "summary" => "An amazing journey"}, related_type: "REVIEWED"}
    end

  end




end
