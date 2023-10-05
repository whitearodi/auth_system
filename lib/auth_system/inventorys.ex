defmodule AuthSystem.Inventorys do
  import Ecto.Query
  alias AuthSystem.Repo
  alias AuthSystem.Inventorys.Inventory
  alias AuthSystem.Sales.Sale

  def list_inventory() do
    group_query_two()
    |> Repo.all()

    #  Inventory
    #   |> Repo.all()
    # |> Repo.preload([:sales])
  end

  # def group_query_one do
  #   from i in Inventory,
  #   left_join: s in AuthSystem.Sales.Sale,
  #   on: i.id == s.inventory_id,
  #   group_by: i.id,
  #   select: sum(s.quantity)
  # end

  def group_query_two do
    from(i in Inventory,
      left_join: s in AuthSystem.Sales.Sale,
      on: i.id == s.inventory_id,
      group_by: [i.id],
      # select: %{ item_name: i.item_name, id: i.id, item_amount: i.item_amount, payment_status: i.payment_status,quantity_sold: sum(s.quantity), quantity: sum(i.quantity) })
      select: %{i | sales: sum(s.quantity)}
    )

    # |> change_to_struct()
  end

  def check_can_sell?(item_id, sale_quantity) do
    from(
      i in Inventory,
      where: i.id == ^item_id,
      select: i.quantity >= ^sale_quantity
    )
    |> Repo.one()
  end

  # defp change_to_struct(map) do
  #   Maptu.struct(map)
  # end

  def get_inventory!(id) do
    Repo.get!(Inventory, id)
  end

  def get_inventory(id) do
    Repo.get(Inventory, id)
  end

  def create_inventory(attrs \\ %{}) do
    %Inventory{}
    |> Inventory.create_changeset(attrs)
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
