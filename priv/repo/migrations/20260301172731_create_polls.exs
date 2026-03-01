defmodule Dubi.Repo.Migrations.CreatePolls do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :question, :string
      add :slug, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:polls, [:slug])
  end
end
