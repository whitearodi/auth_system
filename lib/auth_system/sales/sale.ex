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
    |> validate_number(:quantity, greater_than: 0, message: "Must be greater than 0")
    |> check_if_allowed_to_sell(params)
  end

  defp check_if_allowed_to_sell(changeset, %{"inventory_id" => item_id, "quantity" => quantity}) do
    case AuthSystem.Inventorys.check_can_sell?(item_id, quantity) do
      true ->
        changeset
      _ ->
        add_error(changeset, :quantity, "Quantity greater than available stock")
    end
  end

  defp check_if_allowed_to_sell(changeset, %{} = params) do
    changeset
  end
end
