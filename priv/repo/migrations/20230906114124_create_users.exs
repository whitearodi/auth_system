defmodule AuthSystem.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstname, :string, null: false
      add :lastname, :string, null: false
      add :email, :string, null: false
      add :hash_password, :string, null: false
      add :password, :string, null: false
      add :confirmed_at, :naive_datetime

      timestamps()
    end
  end
end
