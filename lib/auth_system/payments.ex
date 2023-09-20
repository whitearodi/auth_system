defmodule AuthSystem.Payments do
  import Ecto.Query, warn: false
  alias AuthSystem.Repo
  # alias AuthSystem.Payments.Payment
  alias AuthSystem.Payments.Payment

  def list_payments(_attrs \\ %{}) do
    Repo.all(Payment)
  end

  def get_payments!(id) do
    Repo.get!(Payment, id)
  end

  def create_payment(params \\ %{}) do
    %Payment{}
    |> Payment.changeset(params)
    |> Repo.insert()
  end

  def update_payment(%Payment{} = payment, attrs \\ %{}) do
    payment
    |> Payment.changeset(attrs)
    |> Repo.update()
  end

  def delete_payment(%Payment{} = payment) do
    Repo.delete(payment)
  end

  def change_payment(%Payment{} = payment, attrs \\ %{}) do
    Payment.changeset(payment, attrs)
  end
end
