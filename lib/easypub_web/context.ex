defmodule EasypubWeb.Context do
  @moduledoc """
  Build Absinthe context
  """
  @behaviour Plug

  import Plug.Conn
  alias Absinthe.Plug
  alias Easypub.Accounts.AuthToken
  alias EasypubWeb.Helpers.BuildLoader

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    conn
    |> get_req_header("authorization")
    |> authorize()
    |> BuildLoader.build()
  end

  defp authorize(["Bearer " <> token]), do: AuthToken.authorize(token)
  defp authorize(_), do: %{}
end
