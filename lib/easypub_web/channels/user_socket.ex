defmodule EasypubWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: EasypubWeb.Schema
  alias Easypub.Accounts.AuthToken
  alias EasypubWeb.Helpers.BuildLoader

  ## Channels
  # channel "room:*", EasypubWeb.RoomChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(params, socket) do
    context =
      params
      |> Map.get("Authorization")
      |> authorize()
      |> BuildLoader.build()

    socket_updated = Absinthe.Phoenix.Socket.put_options(socket, context: context)
    {:ok, socket_updated}
  end

  defp authorize("Bearer " <> token), do: AuthToken.authorize(token)
  defp authorize(_), do: %{}

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     EasypubWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
