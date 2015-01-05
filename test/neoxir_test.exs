defmodule NeoxirTest do

  import Neoxir
  use ExUnit.Case


  test "commit single statement" do
    {:ok, response} = commit(create_session, statement: "CREATE (n) RETURN ID(n) as x")
    IO.inspect response
  end

end
