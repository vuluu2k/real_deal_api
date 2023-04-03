defmodule RealDealApi.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  alias RealDealApi.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field(:email, :string)
    field(:has_password, :string)
    has_one(:user, User)

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :has_password])
    |> validate_required([:email, :has_password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{has_password: has_password}} = changeset
       ) do
    change(changeset, has_password: Bcrypt.hash_pwd_salt(has_password))
  end

  defp put_password_hash(changeset), do: changeset
end
