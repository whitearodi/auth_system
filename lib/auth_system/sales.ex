defmodule AuthSystem.Sales do
  import Ecto.Query

  alias AuthSystem.Inventorys.Inventory
  alias Ecto.Multi
  alias AuthSystem.Repo
  alias AuthSystem.Sales.Sale

  def list_sales() do
    Repo.all(Sale)
    # |> IO.inspect(label: "JUST CHECKING: ")
    |> Repo.preload([:inventory])
  end

  def get_sales!(id) do
    Repo.get!(Sale, id)
    |> Repo.preload([:inventory])
  end

  # def create_sale(params \\ %{}) do
  #   params["quantity"]
  #   Multi.new()
  #   |> Multi.update(:inventory, Inventory.changeset(params))
  #   |> Multi.insert(:sale, fn %{inventory: inventory} ->
  #     sale = %Sale{}
  #     %{sale | inventory: [] }
  #   end)
  #   |>  IO.inspect(inventory)
  #   |> Repo.transaction()
  # end

  def create_sale(params \\ %{}) do
    %Sale{}
    |> Sale.changeset(params)
    |> Repo.insert()
  end

  def update_sale(%Sale{}, params \\ %{}) do
    %Sale{}
    |> Sale.changeset(params)
    |> Repo.update()
  end

  def change_sale(%Sale{}, params \\ %{}) do
    Sale.changeset(%Sale{}, params)
  end

  #factor in when the db times out & rolling back the process 
  def make_sale(sale_params) do
    # Ecto.Multi
    # |> Repo.transaction()
  end
end
