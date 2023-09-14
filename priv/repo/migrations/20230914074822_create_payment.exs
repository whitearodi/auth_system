defmodule AuthSystem.Repo.Migrations.CreatePayment do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :client_name, :string, null: false
      add :amount, :integer, null: false
      add :payment_method, :string, null: false
      add :email, :string, null: false
      add :payment_status, :string, null: false

      timestamps()
    end
  end
end
