defmodule Neoxir do

  defmodule Session do
    defstruct root_url: "", data_url: "", tx_end_point_url: "", root_resource: %{}
  end

  defmodule Transaction do
    defstruct commit_url: "", errors: [], expires: %{}
  end

  defmodule CypherResponseError do
    defexception message: "", code: ""

    def full_message(me) do
      "Cypher error: #{me.code}\n#{me.message}"
    end

  end


  def commit(session, statements) do
    response = Neoxir.TxEndPoint.commit(session, statements)
    case Neoxir.CypherResponse.to_rows(response) do
      {:ok, rows} -> {:ok, List.first(rows)}
      {:error, location, reasons} -> {:error, location, List.first(reasons)}
    end
  end

  def commit!(session, statements) do
    case commit(session, statements) do
      {:error, Neoxir.CypherResponse, reason} -> raise CypherResponseError, code: reason["code"], message: reason["message"]
      {:ok, response} -> response
    end
  end

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
