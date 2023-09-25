defmodule AuthSystem.Inventorys.Inventory do
  use Ecto.Schema
  import Ecto.Changeset
  alias AuthSystem.Sales.Sale

  schema "inventorys" do
    field :item_name, :string
    field :item_amount, :integer
    field :quantity, :integer
    field :payment_status, :string

    timestamps()

    has_many :sales, Sale
  end

  def changeset(inventory, attrs \\ %{}) do
    inventory
    |> cast(attrs, [:item_name, :item_amount, :payment_status, :quantity])
    |> validate_required([:item_name, :item_amount, :payment_status, :quantity])
  end
end
