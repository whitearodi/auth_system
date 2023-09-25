defmodule AuthSystem.Repo.Migrations.CreateSales do
  use Ecto.Migration

  def change do
    create table(:sales) do
      add :quantity, :integer, null: false
      add :inventory_id, references(:inventorys, on_delete: :nothing)

      timestamps()
    end
  end
end
