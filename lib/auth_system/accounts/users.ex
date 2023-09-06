defmodule AuthSystem.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :hashed_password, :string, redact: true
    field :password, :string, redact: true, virtual: true
    field :confirmed_at, :naive_datetime

    timestamps()
  end

  # user changeset for registration
  def registration_changeset(users, attrs, opts \\ []) do
    users
    |> cast(attrs, [:firstname, :lastname, :email, :password])
    |> validate_email(opts)
    |> validate_password(opts)
  end

  defp validate_email(changeset, opts) do
    changeset
    |> validate_required([:email])
    |> validate_length(:email, max: 160)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> maybe_validate_unique_email(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 9)
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> maybe_hash_password(opts)
  end

  # Question
  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> validate_length(:password, max: 60, count: :bytes)
      |> put_change(:hash_password, Bycrpt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  defp maybe_validate_unique_email(changeset, opts) do
    if Keyword.get(opts, :validate_email, true) do
      changeset
      |> unsafe_validate_unique(:email, AuthSystem.Repo)
      |> unique_constraint(:email)
    else
      changeset
    end
  end

  def email_changeset(users, attrs, opts \\ []) do
    users
    |> cast([:email], attrs)
    |> validate_email(opts)
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  def password_changeset(users, attrs, opts \\ []) do
    users
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match ")
    |> validate_password(opts)
  end

  def confirm_changeset(users) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(users, confirmed_at: now)
  end

  # verifies the password
  def valid_password?(%AuthSystem.Accounts.Users{hashed_password: hash_password}, password)
      when is_binary(hash_password) and byte_size(password) > 0 do
    Bycrpt.verify_pass(
      password,
      hash_password
    )
  end

  def valid_password?(_, _) do
    Bycrpt.no_user_verify()
    false
  end

  # validate the password
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
