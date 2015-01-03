defmodule NeoxirTest do

  use ExUnit.Case

  setup_all do
    #new(Mydb)
#    on_exit fn -> unload end
    :ok
  end


  test "create_session" do
    #expect(Mydb, :foo, fn -> :hej end)
    {:ok, session} = Neoxir.create_session
    assert session.root_url == "http://localhost:7474/" #["data"] == "http://localhost:7474/db/data/"
    assert session.data_url == "http://localhost:7474/db/data/"
    assert session.root_resource["neo4j_version"] == "2.1.6"
#    assert 1 + 1 == 2
  end

#   use ShouldI

#   import ShouldI.Matchers.Context

#   # setup do
#   #   { setup: :done
#   #     test: :shouldi }
#   # end
#   with "a session" do
#     setup context do
#       {:ok, session} = Neoxir.create_session
# #      %{session: session}
#       assign context, :session, session
#     end

#     should_assign_key url: "http://localhost:7474/2"
#     # should "sets the url", %{session: session} do
#     #   session.url == "http://localhost:7474/2"
#     # end

#     # should "sets the url", %{session: session} do
#     #   session.url == "http://localhost:7474/"
#     # end

# #     assert session.data_url == "http://localhost:7474/db/data/"
# #     assert session.root_resource["neo4j_version"] == "1.8"

#   end

end
