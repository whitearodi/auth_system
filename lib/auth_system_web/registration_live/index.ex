defmodule AuthSystemWeb.RegistrationLive.Index do
  use AuthSystemWeb, :live_view

  alias AuthSystem.Accounts
  alias AuthSystem.Accounts.Users

  def mount(_params, _session, socket) do
    # assign()
    # assign_form()
    changeset = Accounts.change_users_registration(%Users{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"users" => users_params}, socket) do
    case Accounts.registers_users(users_params) do
      {:ok, users} ->
        {:ok}

        changeset = Accounts.change_users_registration(users)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"users" => users_params}, socket) do
    changeset = Accounts.change_users_registration(%Users{}, users_params)

    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "users")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
