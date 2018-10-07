defmodule Easypub.Repo.Migrations.UpdateMenuItems do
  use Ecto.Migration

  def change do
    alter table(:menu_items) do
      add(:people_count, :integer)
    end
  end
end
