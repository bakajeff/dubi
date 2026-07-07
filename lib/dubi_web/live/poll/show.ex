defmodule DubiWeb.Poll.Show do
  use DubiWeb, :live_view
  alias Dubi.Voting
  alias Phoenix.Socket

  def mount(%{"slug" => slug}, _session, socket) do
    poll = Voting.get_poll_by_slug!(slug)

    if connected?(socket), do: DubiWeb.Endpoint.subscribe("poll:#{slug}")

    {:ok,
     assign(socket, poll: poll, slug: slug, vote_form: to_form(%{"voter_token" => ""}, as: :vote))}
  end

  def handle_params(_params, uri, socket) do
    voted = socket.assigns.live_action == :results

    {:noreply, assign(socket, voted: voted, uri: uri)}
  end

  def handle_event(
        "vote",
        %{"vote" => %{"option_id" => option_id, "voter_token" => voter_token}},
        socket
      ) do
    case Voting.vote(option_id, voter_token) do
      {:ok, poll} ->
        DubiWeb.Endpoint.broadcast("poll:#{poll.slug}", "vote_updated", %{
          options: Enum.map(poll.options, &%{id: &1.id, votes: &1.votes})
        })

        {:noreply, assign(socket, poll: poll, voted: true)}

      {:error, :already_voted} ->
        {:noreply, put_flash(socket, :error, "You have already voted on this poll")}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Could not register vote, please try again")}
    end
  end

  def handle_info(
        %Socket.Broadcast{event: "vote_updated", payload: %{options: options}},
        socket
      ) do
    updated_options =
      Enum.map(socket.assigns.poll.options, fn option ->
        case Enum.find(options, &(&1.id == option.id)) do
          nil -> option
          updated -> %{option | votes: updated.votes}
        end
      end)

    {:noreply, assign(socket, poll: %{socket.assigns.poll | options: updated_options})}
  end
end
