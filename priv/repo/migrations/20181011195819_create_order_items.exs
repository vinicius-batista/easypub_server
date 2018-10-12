defmodule Easypub.Repo.Migrations.CreateOrderItems do
  use Ecto.Migration

  def change do
    create table(:order_items, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:quantity, :integer)
      add(:order_id, references(:orders, on_delete: :nothing, type: :binary_id))
      add(:item_id, references(:menu_items, on_delete: :nothing, type: :binary_id))

      timestamps()
    end

    create(index(:order_items, [:order_id]))
    create(index(:order_items, [:item_id]))
  end
end
