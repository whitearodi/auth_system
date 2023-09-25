defmodule AuthSystemWeb.InventoryController do
  use AuthSystemWeb, :controller

  alias AuthSystem.Inventorys
  alias AuthSystem.Inventorys.Inventory

  def index(conn, _params) do
    inventorys = Inventorys.list_inventory()
    render(conn, :index, inventorys: inventorys)
  end

  def new(conn, _params) do
    changeset = Inventorys.change_inventory(%Inventory{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"inventory" => inventory_params}) do
    case Inventorys.create_inventory(inventory_params) do
      {:ok, _inventory} ->
        conn
        |> put_flash(:info, "Created record.")
        |> redirect(to: ~p"/inventorys")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    inventory = Inventorys.get_inventory!(id)
    render(conn, :show, inventory: inventory)
  end

  def edit(conn, %{"id" => id}) do
    inventory = Inventorys.get_inventory!(id)
    changeset = Inventorys.change_inventory(inventory)
    render(conn, :edit, inventory: inventory, changeset: changeset)
  end

  def update(conn, %{"id" => id, "inventory" => inventory_params}) do
    inventory = Inventorys.get_inventory!(id)

    case Inventorys.update_inventory(inventory, inventory_params) do
      {:ok, inventory} ->
        conn
        |> put_flash(:info, "Inventory updated successfully.")
        |> redirect(to: ~p"/inventorys")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, inventory: inventory, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    inventory = Inventorys.get_inventory!(id)

    {:ok, inventory} = Inventorys.delete_inventory(inventory)

    conn
    |> put_flash(:info, "Inventory deleted successfully.")
    |> redirect(to: ~p"/inventorys")
  end
end
