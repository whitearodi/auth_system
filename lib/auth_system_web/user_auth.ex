defmodule AuthSystemWeb.UserAuth do
  use AuthSystemWeb, :verified_routes

  import Phoenix.Controller
  import Plug.Conn

  alias AuthSystem.Accounts

  def log_in_users(conn, user) do
    users_return_to = get_session(conn, :users_return_to)
    # user = Accounts.get_users_by_email(params["email"])

    conn
    |> assign(:current_users, user)
    |> IO.inspect(label: "LOGIN")
    |> renew_session()
    |> put_session(:current_users, user)
    |> redirect(to: users_return_to || signed_in_path(conn))
  end

  def log_out_users(conn) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/users/log_in")
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Used for routes that require the users to not be authenticated.
  """
  def redirect_if_users_authenticated(conn, _opts) do
    if conn.assigns[:current_users] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  def fetch_current_users(conn, _opts) do
    users = get_session(conn, :current_users)
    assign(conn, :current_users, users)
  end

  # Handles mounting & authenticating current users on LiveViews
  #  def on_mount(:mount_current_users, _params, session, socket) do
  #   {:cont, mount_current_users(socket, session)}
  # end

  # def on_mount(:ensure_authenticated, _params, session, socket) do
  #   socket = mount_current_users(socket, session)

  #   if socket.assigns.current_users do
  #     {:cont, socket}
  #   else
  #     socket =
  #       socket
  #       |> Phoenix.LiveView.put_flash(:error, "You must log in to access this page.")
  #       |> Phoenix.LiveView.redirect(to: ~p"/users/log_in")

  #     {:halt, socket}
  #   end
  # end

  # def on_mount(:redirect_if_users_is_authenticated, _params, session, socket) do
  #   socket = mount_current_users(socket, session)

  #   if socket.assigns.current_users do
  #     {:halt, Phoenix.LiveView.redirect(socket, to: signed_in_path(socket))}
  #   else
  #     {:cont, socket}
  #   end
  # end

  # defp mount_current_users(socket, session) do
  #   current_users = get_session(session, :current_users)
  #   Phoenix.Component.assign_new(socket, :current_users, fn -> current_users end)
  # end

  def require_authenticated_users(conn, _opts) do
    if conn.assigns[:current_users] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page")
      # |> maybe_store_return_to()
      |> redirect(to: ~p"/users/log_in")
      |> halt()
    end
  end

  # defp maybe_store_return_to(%{method: "GET"} = conn) do
  #   IO.inspect(conn, label: "CONN")
  #   put_session(conn, :user_return_to, current_path(conn))
  # end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(_conn), do: ~p"/"
end
