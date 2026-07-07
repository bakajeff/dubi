defmodule Dubi.Voting.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    field :voter_token, :string
    belongs_to :poll, Dubi.Voting.Poll
    belongs_to :option, Dubi.Voting.Option

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:voter_token, :poll_id, :option_id])
    |> validate_required([:voter_token, :poll_id, :option_id])
    |> unique_constraint(:voter_token, name: :votes_poll_id_voter_token_index)
    |> foreign_key_constraint(:poll_id)
    |> foreign_key_constraint(:option_id)
  end
end
