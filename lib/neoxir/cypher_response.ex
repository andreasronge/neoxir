defmodule Neoxir.CypherResponse do
    defstruct status_code: 0, body: ""


  def to_rows(%Neoxir.CypherResponse{body: body}) do
    r = JSX.decode!(body)
    errors = r["errors"]
    if (length(errors) > 0) do
      {:error, __MODULE__,  errors}
    else
      result = r["results"]
      {:ok, Enum.map(result, &(map_result(&1)))}
    end
  end

  defp map_result(result) do
    columns = Enum.map(result["columns"], &(String.to_atom(&1)))
    rows = rows(result["data"])
    Enum.map(rows, &(map_row(columns, &1)))
  end

  defp map_row(columns, row) do
    {result, _} = Enum.reduce(row, {%{}, columns}, fn value, {dict, [h|t]} -> {Dict.put(dict, h, value), t} end)
    result
  end

  defp rows(data) do
    Enum.map(data, fn %{"row" => row} -> row end)
  end

end
