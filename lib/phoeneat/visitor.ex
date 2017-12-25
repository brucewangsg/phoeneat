defmodule Phoeneat.Visitor do
  use Ecto.Schema
  import Ecto.Changeset
  alias Phoeneat.Visitor

  schema "visitors" do
    field :ip_address, :string
    field :link_id, :integer
    field :user_agent, :string

    timestamps()
  end

  @doc false
  def changeset(%Visitor{} = visitor, attrs) do
    visitor
    |> cast(attrs, [:ip_address, :link_id, :user_agent])
    |> validate_required([:ip_address, :link_id, :user_agent])
  end
end
