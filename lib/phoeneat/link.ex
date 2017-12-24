defmodule Phoeneat.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias Phoeneat.Link
  import Ecto.Query, warn: false
  alias Phoeneat.Repo

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

  def insert_shortcode do
    query = from link in Link,
            limit: 1,
            order_by: [desc: link.id]
    records = Repo.all(query)

    if length(records) == 0 do
      Integer.to_string(1679616, 36) |> String.downcase()
    else
      record = Enum.at(records, 0)
      String.to_integer(record.shortcode, 36) + 1 |> Integer.to_string(36) |> String.downcase()
    end
  end

end
