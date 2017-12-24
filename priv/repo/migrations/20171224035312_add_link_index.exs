defmodule Phoeneat.Repo.Migrations.AddLinkIndex do
  use Ecto.Migration
  @disable_ddl_transaction true # force outside transaction

  def change do
    create index("links", [:shortcode], concurrently: true)
    create index("links", [:domain, :protocol], concurrently: true)
  end
end
