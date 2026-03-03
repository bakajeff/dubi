defmodule DubiWeb.Poll.Show do
  use DubiWeb, :live_view
  alias Dubi.Voting

  def mount(%{"slug" => slug}, _session, socket) do
    # connection?(socket) ensures it only subscribes once the
    # websocket is actually open (not during the initial static page load)
    poll = Voting.get_poll_by_slug!(slug)

    if connected?(socket), do: DubiWeb.Endpoint.subscribe("poll:#{slug}")

    {:ok, assign(socket, poll: poll, slug: slug)}
  end

  def handle_params(_params, uri, socket) do
    voted = socket.assigns.live_action == :results

    {:noreply, assign(socket, voted: voted, uri: uri)}
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
end
