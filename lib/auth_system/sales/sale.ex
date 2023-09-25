defmodule AuthSystem.Sales.Sale do
  alias AuthSystem.Inventorys.Inventory
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales" do
    field :quantity, :integer
    belongs_to :inventory, Inventory

    timestamps()

  end

  def changeset(sale, params \\ %{}) do
    sale
    |> cast(params, [:inventory_id, :quantity])
    |> validate_required([:inventory_id, :quantity])
  end
end
