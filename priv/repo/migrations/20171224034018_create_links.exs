defmodule Phoeneat.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :shortcode, :string
      add :domain, :string
      add :original_url, :string
      add :protocol, :string

      timestamps()
    end

  end
end
