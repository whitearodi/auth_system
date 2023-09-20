defmodule AuthSystem.Inventorys.Inventory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventorys" do
    field :item_name, :string
    field :item_amount, :integer
    field :payment_status, :string

    timestamps()
  end

  def changeset(inventory, attrs \\ %{}) do
    inventory
    |> cast(attrs, [:item_name, :item_amount, :payment_status])
    |> validate_required([:item_name, :item_amount, :payment_status])
  end
end
