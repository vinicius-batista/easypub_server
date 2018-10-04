defmodule EasypubWeb.Context do
  @moduledoc """
  Build Absinthe context
  """
  @behaviour Plug

  import Plug.Conn
  alias Absinthe.Plug
  alias Easypub.Accounts.AuthToken

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    conn
    |> get_req_header("authorization")
    |> case do
      ["Bearer " <> token] -> AuthToken.authorize(token)
      _ -> %{}
    end
  end
end
