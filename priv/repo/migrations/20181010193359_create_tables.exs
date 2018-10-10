defmodule Easypub.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do
    create table(:tables, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:number, :integer)
      add(:bar_id, references(:bars, on_delete: :delete_all, type: :binary_id))

      timestamps()
    end

    create(index(:tables, [:bar_id]))
  end
end
