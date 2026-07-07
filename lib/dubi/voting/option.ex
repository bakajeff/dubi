defmodule Dubi.Voting.Option do
  use Ecto.Schema
  import Ecto.Changeset

  schema "options" do
    field :label, :string
    field :votes, :integer, default: 0
    belongs_to :poll, Dubi.Voting.Poll

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(option, attrs) do
    option
    |> cast(attrs, [:label])
    |> validate_required([:label])
  end
end
