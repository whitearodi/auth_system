defmodule AuthSystem.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :client_name, :string
    field :amount, :integer
    field :payment_method, Ecto.Enum, values: [:MPESA, :CASH]
    field :email, :string
    field :payment_status, Ecto.Enum, values: [:Completed, :Pending]

    timestamps()
  end

  def changeset(payment, params \\ %{}) do
    payment
    |> cast(params, [:client_name, :amount, :payment_method, :email, :payment_status])
    |> validate_required([:client_name, :amount, :payment_status, :email, :payment_method])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> unique_constraint(:email)
    |> validate_number(:amount, greater_than: 10, message: "Must be greater than 10")
  end
end
