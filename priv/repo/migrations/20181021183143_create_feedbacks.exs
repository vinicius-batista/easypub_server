defmodule Easypub.Repo.Migrations.CreateFeedbacks do
  use Ecto.Migration

  def change do
    create table(:feedbacks, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:has_mistake, :boolean, default: false, null: false)
      add(:bar_rating, :decimal)
      add(:app_rating, :decimal)
      add(:indication, :integer)

      add(:order_id, references(:orders, on_delete: :nothing, type: :binary_id))

      timestamps()
    end
  end
end
