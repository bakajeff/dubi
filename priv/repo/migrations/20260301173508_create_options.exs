defmodule Dubi.Repo.Migrations.CreateOptions do
  use Ecto.Migration

  def change do
    create table(:options) do
      add :label, :string
      add :votes, :integer, default: 0, null: false
      add :poll_id, references(:polls, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:options, [:poll_id])
  end
end
