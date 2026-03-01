defmodule Dubi.VotingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dubi.Voting` context.
  """

  @doc """
  Generate a unique poll slug.
  """
  def unique_poll_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a poll.
  """
  def poll_fixture(attrs \\ %{}) do
    {:ok, poll} =
      attrs
      |> Enum.into(%{
        question: "some question",
        slug: unique_poll_slug()
      })
      |> Dubi.Voting.create_poll()

    poll
  end

  @doc """
  Generate a option.
  """
  def option_fixture(attrs \\ %{}) do
    {:ok, option} =
      attrs
      |> Enum.into(%{
        label: "some label",
        votes: 42
      })
      |> Dubi.Voting.create_option()

    option
  end
end
