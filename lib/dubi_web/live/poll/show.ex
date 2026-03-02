defmodule DubiWeb.Poll.Show do
  use DubiWeb, :live_view
  alias Dubi.Voting

  def mount(%{"slug" => slug}, _session, socket) do
    # connection?(socket) ensures it only subscribes once the
    # websocket is actually open (not during the initial static page load)
    if connected?(socket) do
      DubiWeb.Endpoint.subscribe("poll:#{slug}")
    end

    poll = Voting.get_poll_by_slug!(slug)

    {:ok, assign(socket, poll: poll, voted: false, slug: slug)}
  end

  def handle_event("vote", %{"option_id" => option_id}, socket) do
    Voting.increment_vote(option_id)

    updated_poll = Voting.get_poll_by_slug!(socket.assigns.poll.slug)

    {:noreply, assign(socket, poll: updated_poll, voted: true)}
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "vote_updated", payload: updated_poll}, socket) do
    # Swap the old poll data with the new data
    # LiveView handles the UI diff
    {:noreply, assign(socket, poll: updated_poll)}
  end

  defp get_percent(votes, total) when total > 0, do: round(votes / total * 100)

  defp get_percent(_votes, _total), do: 0
end
