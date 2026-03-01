defmodule Dubi.Voting.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "polls" do
    field :question, :string
    field :slug, :string
    has_many :options, Dubi.Voting.Option

    timestamps(type: :utc_datetime)
  end

  defp generate_slug(%Ecto.Changeset{valid?: true} = changeset) do
    slug = :crypto.strong_rand_bytes(6) |> Base.url_encode64(padding: false)
    put_change(changeset, :slug, slug)
  end

  defp generate_slug(changeset), do: changeset

  @doc false
  def changeset(poll, attrs) do
    poll
    |> cast(attrs, [:question])
    |> validate_required([:question])
    |> generate_slug()
    |> unique_constraint(:slug)
  end
end
