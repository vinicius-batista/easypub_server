defmodule Easypub.Repo.Migrations.CreateUsers do
  @moduledoc """
  Migration for create users
  """
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:name, :string)
      add(:email, :string)
      add(:password_hash, :string)
      add(:role, :string)
      add(:phone, :string)

      timestamps()
    end

    create(unique_index(:users, [:email]))
    create(unique_index(:users, [:phone]))
  end
end
