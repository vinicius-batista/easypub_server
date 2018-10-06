defmodule Easypub.Repo.Migrations.CreateBars do
  use Ecto.Migration

  def change do
    create table(:bars, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all, type: :binary_id))
      add(:name, :string)
      add(:address, :string)
      add(:status, :string)
      add(:avatar, :string)

      timestamps()
    end

    create(index(:bars, [:user_id]))
  end
end
