defmodule AuthSystem.Accounts do
  import Ecto.Query, warn: false
  alias AuthSystem.Repo
  alias AuthSystem.Accounts.Users

  # get users email
  def get_users_by_email(email) when is_binary(email) do
    Repo.get_by(Users, email: email)
  end

  # Get user by email and password
  def get_users_by_email_and_password(email, password)
      when is_binary(email) and
             is_binary(password) do
    users = Repo.get_by(Users, email: email)
    if Users.valid_password?(users, password), do: users
  end

  # Get a single user
  def get_user!(id), do: Repo.get!(Users, id)

  # Registers users
  def registers_users(attrs) do
    %Users{}
    |> Users.registration_changeset(attrs)
    |> Repo.insert()
  end

  # Returns an `%Ecto.Changeset{}` for tracking users changes
  def change_users_registration(%Users{} = users, attrs \\ %{}) do
    Users.registration_changeset(users, attrs, hash_password: false, validate_email: false)
  end

  # Setting
  # validate_emial??
  def change_users_email(users, attrs \\ %{}) do
    Users.email_changeset(users, attrs, validate_email: false)
  end

  # Emulates that the email will change without actually changing it in the database.
  def apply_users_email(users, password, attrs) do
    users
    |> Users.email_changeset(attrs)
    |> Users.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  # Returns an `%Ecto.Changeset{}` for changing the users password.
  # hashed_password?
  def change_users_password(users, attrs \\ %{}) do
    Users.password_changeset(users, attrs, hash_password: false)
  end

  # update the users password
  def update_users_password(users, password, attrs) do
    changeset =
      users
      |> Users.password_changeset(attrs)
      |> Users.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:users, changeset)
    |> Repo.transaction()
    |> case do
      {:ok, %{users: users}} -> {:ok, users}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  def reset_users_password(users, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:users, Users.password_changeset(users, attrs))
    |> Repo.transaction()
    |> case do
      {:ok, %{users: users}} -> {:ok, users}
      {:error, :users, changeset, _} -> {:error, changeset}
    end
  end
end
