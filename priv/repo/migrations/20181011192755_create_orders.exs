defmodule Easypub.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:status, :string)
      add(:table_id, references(:tables, on_delete: :delete_all, type: :binary_id))
      add(:user_id, references(:users, on_delete: :nothing, type: :binary_id))

      timestamps()
    end

    create(index(:orders, [:table_id]))
    create(index(:orders, [:user_id]))
  end
end
