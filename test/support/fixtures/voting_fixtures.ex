defmodule Dubi.VotingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dubi.Voting` context.
  """

  @doc """
  Generate a poll.
  """
  def poll_fixture(attrs \\ %{}) do
    {:ok, poll} =
      attrs
      |> Enum.into(%{
        question: "some question",
        options: [
          %{label: "first option"},
          %{label: "second option"}
        ]
      })
      |> Dubi.Voting.create_poll()

    Dubi.Voting.get_poll!(poll.id)
  end

  @doc """
  Generate a option.
  """
  def option_fixture(attrs \\ %{}) do
    {:ok, option} =
      attrs
      |> Enum.into(%{
        label: "some label"
      })
      |> Dubi.Voting.create_option()

    option
  end
end
