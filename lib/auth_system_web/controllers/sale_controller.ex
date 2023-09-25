defmodule AuthSystemWeb.SaleController do
  use AuthSystemWeb, :controller

  alias AuthSystem.Inventorys
  alias AuthSystem.Sales
  alias AuthSystem.Sales.Sale

  def index(conn, _params) do
    sales = Sales.list_sales()
    render(conn, :index, sales: sales)
  end

  def new(conn, _params) do
    changeset = Sales.change_sale(%Sale{})
    products = Inventorys.list_inventory()
    render(conn, :new, changeset: changeset, products: products)
  end

  def create(conn, %{"sale" => sale_params}) do
    case Sales.create_sale(sale_params) do
      {:ok, _sale} ->
        conn
        |> put_flash(:info, "Sale created successfully")
        |> redirect(to: ~p"/sales")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sale = Sales.get_sales!(id)

    render(conn, :show, sale: sale)
  end

  def edit(conn, %{"id" => id}) do
    sale = Sales.get_sales!(id)
    changeset = Sales.change_sale(sale)
    render(conn, :edit, sale: sale, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sale" => sale_params}) do
    sale = Sales.get_sales!(id)

    case Sales.update_sale(sale, sale_params) do
      {:ok, _sale} ->
        conn
        |> put_flash(:info, "Sales updated successfully")
        |> redirect(to: ~p"/sales")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, changeset: changeset)
    end
  end
end
