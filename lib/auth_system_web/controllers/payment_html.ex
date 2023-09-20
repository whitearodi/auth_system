defmodule AuthSystemWeb.PaymentHTML do
  use AuthSystemWeb, :html

  embed_templates "payment_html/*"

  @doc """
  Renders a payment form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def payment_form(assigns)
end
