defmodule AuthSystemWeb.PaymentController do
  use AuthSystemWeb, :controller
  alias AuthSystem.Payments
  alias AuthSystem.Payments.Payment

  def index(conn, _params) do
    payments = Payments.list_payments()

    render(conn, :index, payments: payments)
  end

  ## ??
  def new(conn, _params) do
    changeset = Payments.change_payment(%Payment{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"payment" => payment_params}) do
    # IO.inpsect(payment_params, label: bleach)
    case Payments.create_payment(payment_params) do
      {:ok, _payment} ->
        conn
        |> put_flash(:info, "Payment created successfully")
        |> redirect(to: ~p"/payments")

      {:error, %Ecto.Changeset{} = changeset} ->
        # render actions
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    payment =
      id
      |> Payments.get_payments!()

    render(conn, :show, payment: payment)
  end

  def edit(conn, %{"id" => id}) do
    payment = Payments.get_payments!(id)
    changeset = Payments.change_payment(payment)
    render(conn, :edit, payment: payment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "payment" => payment_params}) do
    payment = Payments.get_payments!(id)

    case Payments.update_payment(payment, payment_params) do
      {:ok, _payment} ->
        conn
        |> put_flash(:info, "Payment updateded successfully")
        |> redirect(to: ~p"/payments")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, payment: payment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment = Payments.get_payments!(id)
    {:ok, _payment} = Payments.delete_payment(payment)

    conn
    |> put_flash(:info, "Payment deleted successfully.")
    |> redirect(to: ~p"/payments")
  end
end
