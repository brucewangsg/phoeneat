defmodule Phoeneat.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias Phoeneat.Link


  schema "links" do
    field :original_url, :string
    field :domain, :string
    field :protocol, :string
    field :shortcode, :string # mapping of shortened shortcode URL, e.g. bdaced

    timestamps()
  end

  @doc false
  def changeset(%Link{} = link, attrs) do
    link
    |> cast(attrs, [:shortcode, :domain, :original_url, :protocol])
    |> validate_required([:shortcode, :domain, :original_url, :protocol])
  end
end
