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
    |> unique_constraint(:shortcode)
  end

  def insert_shortcode do
    query = from link in Link,
            limit: 1,
            order_by: [desc: link.id]
    records = Repo.all(query)

    if length(records) == 0 do
      Integer.to_string(1679616, 36) |> String.downcase() |> Link.randomize
    else
      record = Enum.at(records, 0)
      String.to_integer(Link.unrandomize(record.shortcode), 36) + 1 |> Integer.to_string(36) |> String.downcase() |> Link.randomize
    end
  end

  def randomize(code) do
    String.split(code,"") |> Enum.with_index(1) |> Enum.map(fn {x, i} -> 
      cond do 
        x == "" -> 
          ""
        rem(i,2) == 0 ->
          Integer.to_string(35 - rem(String.to_integer(x, 36) + 18, 36), 36)
        rem(i,3) == 0 ->
          Integer.to_string(35 - rem(String.to_integer(x, 36) + 12, 36), 36)
        rem(i,5) == 0 ->
          Integer.to_string(35 - rem(String.to_integer(x, 36) + 24, 36), 36)
        true ->
          Integer.to_string(35 - String.to_integer(x, 36), 36)
      end
    end) |> Enum.join("") |> String.downcase
  end

  def unrandomize(code) do
    String.split(code,"") |> Enum.with_index(1) |> Enum.map(fn {x, i} -> 
      cond do 
        x == "" -> 
          ""
        rem(i,2) == 0 ->
          Integer.to_string(rem((35 - String.to_integer(x, 36)) + 36 - 18, 36), 36)
        rem(i,3) == 0 ->
          Integer.to_string(rem((35 - String.to_integer(x, 36)) + 36 - 12, 36), 36)
        rem(i,5) == 0 ->
          Integer.to_string(rem((35 - String.to_integer(x, 36)) + 36 - 24, 36), 36)
        true ->
          Integer.to_string(35 - String.to_integer(x, 36), 36)
      end
    end) |> Enum.join("") |> String.downcase
  end

  def test_randoms do
    g = 1679616..2679952 
      |> Enum.map(fn x -> x |> Integer.to_string(36) |> String.downcase() end) 
      |> Enum.map(fn x -> x == x |> Link.randomize |> Link.unrandomize end) 
      |> Enum.filter(fn x -> x === false end)
    length(g) == 0
  end

end
