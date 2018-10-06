defmodule Easypub.Repo.Migrations.CreateMenuItems do
  use Ecto.Migration

  def change do
    create table(:menu_items, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:photo, :string)
      add(:price, :decimal)
      add(:description, :string)
      add(:waiting_time, :string)
      add(:category_id, references(:menu_categories, on_delete: :delete_all, type: :binary_id))

      timestamps()
    end

    create(index(:menu_items, [:category_id]))
  end
end
