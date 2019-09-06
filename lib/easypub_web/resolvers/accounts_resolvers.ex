defmodule EasypubWeb.Resolvers.AccountsResolvers do
  @moduledoc """
  Accounts graphql resolvers module
  """
  alias Easypub.Accounts.{Auth}
  alias Easypub.Accounts

  def register_user(_, %{input: input}, _) do
    with {:ok, user} <- Accounts.create_user(input),
         do: Auth.generate_tokens(user)
  end

  def register_bar_owner(_, %{input: input}, _) do
    with {:ok, %{user: user}} <- Accounts.create_bar_owner(input) do
      Auth.generate_tokens(user)
    else
      {:error, _model, error, _} -> {:error, error}
    end
  end

  def login_user(_, %{input: %{email: email, password: password}}, _) do
    with {:ok, user} <- Auth.find_user_and_check_password(email, password),
         do: Auth.generate_tokens(user)
  end

  def logout(_, %{refresh_token: refresh_token}, %{context: %{current_user: %{id: id}}}) do
    refresh_token
    |> Auth.revoke_refresh_token(id)
    |> case do
      {:ok, _} -> {:ok, "User logout successfully."}
      error -> error
    end
  end

  def new_access_token(_, %{refresh_token: refresh_token}, _) do
    with {:ok, user} <- Auth.get_user_by_refresh_token(refresh_token),
         do: Auth.generate_new_access_token(user, refresh_token)
  end

  def profile(_, _, %{context: %{current_user: current_user}}), do: {:ok, current_user}

  def update_profile(_, %{input: input}, %{context: %{current_user: current_user}}) do
    Accounts.update_user(current_user, input)
  end

  def change_password(_, %{input: input}, %{context: %{current_user: current_user}}) do
    current_user
    |> Auth.check_password(input.current_password)
    |> case do
      true -> Accounts.update_user(current_user, %{password: input.new_password})
      false -> {:error, "Senha atual está incorreta"}
    end
  end
end
