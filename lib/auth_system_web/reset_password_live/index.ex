defmodule AuthSystemWeb.ResetPasswordLive.Index do
  use AuthSystemWeb, :live_view

  alias AuthSystem.Accounts

  def mount(params, _session, socket) do
    # socket = assign_users_token(socket, params)
    socket = assign(socket, params)

    form_source =
      case socket.assigns do
        %{users: users} ->
          Accounts.change_users_password(users)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  def handle_event("validate", %{"users" => user_params}, socket) do
    case Accounts.reset_users_password(socket.assigns.users, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset succesfully")
         |> redirect(to: ~p"/users/login_in")}

      {:error, changeset} ->
        # ??
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"users" => user_params}, socket) do
    # socket.assigns.user??
    changeset = Accounts.change_users_password(socket.assigns.users, user_params)
    # Map put??
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "users"))
  end
end
