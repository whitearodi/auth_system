defmodule AuthSystemWeb.InventoryHTML do
  use AuthSystemWeb, :html

  embed_templates "inventory_html/*"

  @doc """
  Renders a inventory form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def inventory_form(assigns)
end
