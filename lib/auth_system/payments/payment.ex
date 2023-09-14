defmodule AuthSystem.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :client_name, :string
    field :amount, :integer
    field :payment_method, :string
    field :email, :string
    field :payment_status, :string

    timestamps()
  end


  def changeset(payment, attrs \\ %{}) do
    payment
    |> cast(attrs, [:client_name, :amount, :payment_status, :email, :payment_method])
    |> validate_required([:client_name, :amount, :payment_status, :email, :payment_method])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> unique_constraint(:email)
  end
end
