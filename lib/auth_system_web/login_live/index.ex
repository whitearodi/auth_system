defmodule AuthSystemWeb.LoginLive.Index do
  use AuthSystemWeb, :live_view

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "users")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
