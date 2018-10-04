defmodule Easypub.Repo.Migrations.CreateTokens do
  @moduledoc """
  Migration for create tokens
  """
  use Ecto.Migration

  def change do
    create table(:tokens, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all, type: :binary_id))
      add(:refresh_token, :string)
      add(:is_revoked, :boolean, default: false, null: false)
      add(:type, :string)

      timestamps()
    end

    create(unique_index(:tokens, [:refresh_token]))
  end
end
