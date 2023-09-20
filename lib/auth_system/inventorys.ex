defmodule AuthSystem.Inventorys do
  import Ecto.Query, warn: false
  alias AuthSystem.Repo
  alias AuthSystem.Inventorys.Inventory

  def list_inventory() do
   Inventory
    |> Repo.all()
  end

  def get_inventory!(id) do
    Repo.get!(Inventory, id)
  end

  def create_inventory(attrs \\ %{}) do
    %Inventory{}
    |> Inventory.changeset(attrs)
    |> Repo.insert()
  end

  def update_inventory(%Inventory{} = inventory, attrs) do
    inventory
    |> Inventory.changeset(attrs)
    |> Repo.update()
  end

  def delete_inventory(%Inventory{} = inventory) do
    Repo.delete(inventory)
  end

  def change_inventory(%Inventory{} = inventory, attrs \\ %{}) do
    Inventory.changeset(inventory, attrs)
  end
end
