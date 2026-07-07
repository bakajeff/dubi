defmodule Dubi.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :voter_token, :string, null: false
      add :poll_id, references(:polls, on_delete: :delete_all), null: false
      add :option_id, references(:options, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:votes, [:poll_id, :voter_token])
    create index(:votes, [:poll_id])
    create index(:votes, [:option_id])
  end
end
