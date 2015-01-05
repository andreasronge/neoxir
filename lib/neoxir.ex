defmodule Neoxir do

  defmodule Session do
    defstruct root_url: "", data_url: "", tx_end_point_url: "", root_resource: %{}
  end

  defmodule Transaction do
    defstruct commit_url: "", errors: [], expires: %{}
  end

  defmodule CypherResponseError do
    defexception message: "", code: ""
  end

  @doc """
  Begin and commit a transaction in one request.
  If there is no need to keep a transaction open across multiple HTTP requests, 
  you can begin a transaction, execute statements, and commit with just a single HTTP request.

  ## Examples

    iex> Neoxir.create_session |> Neoxir.commit(statement: "MATCH n WHERE ID(n) = 0 RETURN ID(n) as x")
    {:ok, [%{x: 0}]}
  """
  def commit(session, statements) do
    response = Neoxir.TxEndPoint.commit(session, statements)
    case Neoxir.CypherResponse.to_rows(response) do
      {:ok, rows} -> {:ok, List.first(rows)}
      {:error, location, reasons} -> {:error, location, List.first(reasons)}
    end
  end

  @doc """
  Same as #commit but mayb raise an CypherResponseError

  ## Examples

    iex> Neoxir.create_session |> Neoxir.commit!(statement: "MATCH n WHERE ID(n) = 0 RETURN ID(n) as x")
    [%{x: 0}]
  """
  def commit!(session, statements) do
    case commit(session, statements) do
      {:error, Neoxir.CypherResponse, reason} -> raise CypherResponseError, code: reason["code"], message: reason["message"]
      {:ok, response} -> response
    end
  end

  @doc """
  Creates a new neo4j session using the given url to the database.
  """
  def create_session(url \\ "http://localhost:7474/") do
    {:ok, data} = HTTPoison.get(url)
    {:ok, body} = JSX.decode(data.body)
    data_url = body["data"]

    {:ok, data} = HTTPoison.get(data_url)
    {:ok, body} = JSX.decode(data.body)

    # body
    %Session{root_url: url, data_url: data_url, root_resource: body, tx_end_point_url: body["transaction"]}
  end

end
