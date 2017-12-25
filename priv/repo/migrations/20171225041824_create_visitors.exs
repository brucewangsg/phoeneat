defmodule Phoeneat.Repo.Migrations.CreateVisitors do
  use Ecto.Migration

  def change do
    create table(:visitors) do
      add :ip_address, :string
      add :link_id, :integer
      add :user_agent, :string

      timestamps()
    end

  end
end
