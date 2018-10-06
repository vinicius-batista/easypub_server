defmodule Easypub.Repo.Migrations.CreateMenuCategories do
  use Ecto.Migration

  def change do
    create table(:menu_categories, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string)
      add(:bar_id, references(:bars, on_delete: :delete_all, type: :binary_id))

      timestamps()
    end

    create(index(:menu_categories, [:bar_id]))
  end
end
