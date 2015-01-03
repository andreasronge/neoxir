defmodule NeoxirTest do

  import Neoxir
  import Neoxir.TxEndPoint

  use ExUnit.Case
  setup_all do
    #new(Mydb)
#    on_exit fn -> unload end
    :ok
  end


  # create_session


  test "create_session returns a session struct" do
    session = create_session
    assert session.root_url == "http://localhost:7474/" #["data"] == "http://localhost:7474/db/data/"
    assert session.data_url == "http://localhost:7474/db/data/"
    assert String.valid?(session.root_resource["neo4j_version"])
  end


  # commit

  test "commit returns a response" do
    session = create_session
    response = commit(session, [statement: "CREATE (n) RETURN id(n)"])
    assert response.status_code == 200
    assert response == ""
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


  # use ShouldI

  # import ShouldI.Matchers.Context


  # with "a session" do
  #   setup context do
  #     {:ok, session} = Neoxir.create_session
  #     assign context, %{session: session}
  #     #Dict.put context, :session, :yes
  #   end

  #   should( "have necessary key", %{session: session} ) do
  #     assert session.root_url == "http://localhost:7474/2"
  #   end

  #   #should_have_key :root_url
  # end

end
