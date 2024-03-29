defmodule EasypubWeb.GraphqlHelper do
  @moduledoc """
  Test helper for graphql queries
  """
  use Phoenix.ConnTest

  @endpoint EasypubWeb.Endpoint

  def graphql_query(conn, options) do
    conn
    |> post("/graphql", build_query(options[:query], options[:variables]))
    |> json_response(200)
  end

  def get_query_data(conn, query), do: conn["data"][query]

  def get_query_errors(conn, _), do: conn["errors"] |> Enum.at(0)

  defp build_query(query, variables) do
    %{
      query: query,
      variables: variables
    }
  end
end
