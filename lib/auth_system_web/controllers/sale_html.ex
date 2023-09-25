defmodule AuthSystemWeb.SaleHTML do
  use AuthSystemWeb, :html

  embed_templates "sale_html/*"


  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def sale_form(assigns)

end
