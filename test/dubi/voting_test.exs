defmodule Dubi.VotingTest do
  use Dubi.DataCase

  alias Dubi.Voting

  describe "polls" do
    alias Dubi.Voting.Poll

    import Dubi.VotingFixtures

    @invalid_attrs %{question: nil, options: []}

    test "list_polls/0 returns all polls" do
      poll = poll_fixture()
      assert [%Poll{id: poll_id}] = Voting.list_polls()
      assert poll_id == poll.id
    end

    test "get_poll!/1 returns the poll with given id" do
      poll = poll_fixture()
      assert Voting.get_poll!(poll.id) == poll
    end

    test "create_poll/1 with valid data creates a poll" do
      valid_attrs = %{
        question: "some question",
        options: [
          %{label: "first option"},
          %{label: "second option"}
        ]
      }

      assert {:ok, %Poll{} = poll} = Voting.create_poll(valid_attrs)
      assert poll.question == "some question"
      assert is_binary(poll.slug)
      assert length(poll.options) == 2
    end

    test "create_poll/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Voting.create_poll(@invalid_attrs)
    end

    test "update_poll/2 with valid data updates the poll" do
      poll = poll_fixture()
      update_attrs = %{question: "some updated question"}

      assert {:ok, %Poll{} = poll} = Voting.update_poll(poll, update_attrs)
      assert poll.question == "some updated question"
      assert is_binary(poll.slug)
    end

    test "update_poll/2 with invalid data returns error changeset" do
      poll = poll_fixture()
      assert {:error, %Ecto.Changeset{}} = Voting.update_poll(poll, @invalid_attrs)
      assert poll == Voting.get_poll!(poll.id)
    end

    test "delete_poll/1 deletes the poll" do
      poll = poll_fixture()
      assert {:ok, %Poll{}} = Voting.delete_poll(poll)
      assert_raise Ecto.NoResultsError, fn -> Voting.get_poll!(poll.id) end
    end

    test "change_poll/1 returns a poll changeset" do
      poll = poll_fixture()
      assert %Ecto.Changeset{} = Voting.change_poll(poll)
    end

    test "vote/2 records a vote and returns the updated poll" do
      poll = poll_fixture()
      option = hd(poll.options)
      voter_token = "test-token-123"

      assert {:ok, updated_poll} = Voting.vote(option.id, voter_token)

      updated_option = Enum.find(updated_poll.options, &(&1.id == option.id))
      assert updated_poll.id == poll.id
      assert updated_option.votes == option.votes + 1
    end

    test "vote/2 prevents duplicate voting with the same voter token" do
      poll = poll_fixture()
      option = hd(poll.options)
      voter_token = "test-token-456"

      assert {:ok, _updated_poll} = Voting.vote(option.id, voter_token)
      assert {:error, :already_voted} = Voting.vote(option.id, voter_token)
    end

    test "vote/2 allows different voter tokens to vote on the same poll" do
      poll = poll_fixture()
      option1 = hd(poll.options)
      option2 = List.last(poll.options)

      assert {:ok, _poll_after_first} = Voting.vote(option1.id, "token-a")
      assert {:ok, poll_after_second} = Voting.vote(option2.id, "token-b")

      updated_option1 = Enum.find(poll_after_second.options, &(&1.id == option1.id))
      updated_option2 = Enum.find(poll_after_second.options, &(&1.id == option2.id))
      assert updated_option1.votes == option1.votes + 1
      assert updated_option2.votes == option2.votes + 1
    end

    test "vote/2 returns error for a missing option" do
      assert {:error, :option_not_found} = Voting.vote(-1, "some-token")
    end
  end

  describe "options" do
    alias Dubi.Voting.Option

    import Dubi.VotingFixtures

    @invalid_attrs %{label: nil}

    test "list_options/0 returns all options" do
      option = option_fixture()
      assert Voting.list_options() == [option]
    end

    test "get_option!/1 returns the option with given id" do
      option = option_fixture()
      assert Voting.get_option!(option.id) == option
    end

    test "create_option/1 with valid data creates a option" do
      valid_attrs = %{label: "some label", votes: 42}

      assert {:ok, %Option{} = option} = Voting.create_option(valid_attrs)
      assert option.label == "some label"
      assert option.votes == 0
    end

    test "create_option/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Voting.create_option(@invalid_attrs)
    end

    test "update_option/2 with valid data updates the option" do
      option = option_fixture()
      update_attrs = %{label: "some updated label", votes: 43}

      assert {:ok, %Option{} = option} = Voting.update_option(option, update_attrs)
      assert option.label == "some updated label"
      assert option.votes == 0
    end

    test "update_option/2 with invalid data returns error changeset" do
      option = option_fixture()
      assert {:error, %Ecto.Changeset{}} = Voting.update_option(option, @invalid_attrs)
      assert option == Voting.get_option!(option.id)
    end

    test "delete_option/1 deletes the option" do
      option = option_fixture()
      assert {:ok, %Option{}} = Voting.delete_option(option)
      assert_raise Ecto.NoResultsError, fn -> Voting.get_option!(option.id) end
    end

    test "change_option/1 returns a option changeset" do
      option = option_fixture()
      assert %Ecto.Changeset{} = Voting.change_option(option)
    end
  end
end
