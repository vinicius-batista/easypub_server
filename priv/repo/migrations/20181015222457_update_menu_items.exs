defmodule Easypub.Repo.Migrations.UpdateMenuItems do
  use Ecto.Migration

  def change do
    alter table(:menu_items) do
      add(:code, :string)
    end
  end
end
