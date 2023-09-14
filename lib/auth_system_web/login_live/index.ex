defmodule AuthSystemWeb.LoginLive.Index do
  use AuthSystemWeb, :live_view
  alias AuthSystemWeb.UserAuth
  alias AuthSystem.Accounts.Users

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "users")
    {:ok, assign(socket, form: form, trigger_submit: false), temporary_assigns: [form: form]}
  end

  def handle_event("save", %{"users" => params}, socket) do
    case Users.validate_current_password(params) do
      {:ok, changeset} ->
        {:noreply, assign(socket, changeset: changeset, trigger_submit: true)}

      {:error, changeset} ->
        {:noreply, changeset: changeset}
    end
  end
end
