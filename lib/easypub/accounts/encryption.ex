defmodule Easypub.Accounts.Encryption do
  @moduledoc """
  Module related to password encryption
  """
  @spec password_hashing(binary()) :: any()
  def password_hashing(password), do: Bcrypt.hash_pwd_salt(password)

  @spec validate_password(binary(), binary()) :: boolean()
  def validate_password(password, hash), do: Bcrypt.verify_pass(password, hash)
end
