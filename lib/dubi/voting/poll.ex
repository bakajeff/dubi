defmodule Dubi.Voting.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "polls" do
    field :question, :string
    field :slug, :string
    has_many :options, Dubi.Voting.Option

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:question, :slug])
    |> validate_required([:question, :slug])
    |> unique_constraint(:slug)
  end
end
