defmodule AuthSystemWeb.UserSessionController do
  use AuthSystemWeb, :controller

  import Plug.Conn
  import Phoenix.Controller

  alias AuthSystem.Accounts
  alias AuthSystemWeb.UserAuth

  def create(conn, %{"action" => "registered"} = params) do
    create(conn, params, "Account created succesfully!")
  end

  def create(conn, %{"action" => "password_updated"} = params) do
    conn
    |> put_session(:users_return_to, ~p"/users/settings")
    |> create(params, "Password updated succesfully")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back")
  end

  defp create(conn, %{"users" => %{"email" => email, "password" => password}}, info) do
    # %{"email" => email} = users_params

    if  user = Accounts.get_users_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_users(user)
    else
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p(/users/log_in))
    end
  end

  def log_out(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully")
    |> UserAuth.log_out_users()
  end
end
