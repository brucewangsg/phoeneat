defmodule Phoeneat.Repo.Migrations.AddUniqueShortcode do
  use Ecto.Migration
  @disable_ddl_transaction true # force outside transaction

  def change do
    drop index("links", [:shortcode], concurrently: true)
    create unique_index(:links, [:shortcode])
  end
end
