defmodule AuthSystem.Sales do
  import Ecto.Query, warn: false

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

  def change_sale(%Sale{}, params\\ %{}) do
  Sale.changeset(%Sale{}, params)
  end

end
