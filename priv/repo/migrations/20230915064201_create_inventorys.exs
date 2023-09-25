defmodule AuthSystem.Repo.Migrations.CreateInventorys do
  use Ecto.Migration

  def change do
    create table(:inventorys) do
      add :item_name, :string, null: false
      add :item_amount, :integer, null: false
      add :quantity, :integer, null: false
      add :payment_status, :string, null: false

      timestamps()
    end
  end
end
