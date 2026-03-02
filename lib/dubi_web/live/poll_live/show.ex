defmodule DubiWeb.PollLive.Show do
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

  def render(assigns) do
    ~H"""
    <div class="container max-w-2xl mx-auto bg-base-200 p-8 rounded-lg">
      <h1 class="text-2xl mb-2">{@poll.question}</h1>

      <%= if @voted do %>
        <% total_votes = Enum.sum(Enum.map(@poll.options, & &1.votes)) %>

        <div class="space-y-6">
          <%= for option <- @poll.options do %>
            <% percent = get_percent(option.votes, total_votes) %>
            <div class="relative">
              <div class="flex justify-between mb-1 text-sm font-semibold">
                <span>{option.label}</span>
                <span>{percent}% ({option.votes})</span>
              </div>

              <div class="w-full bg-gray-200 rounded-full h-4 overflow-hidden">
                <div
                  class="bg-indigo-600 h-full transition-all duration-500 ease-out"
                  style={"width: #{percent}%"}
                >
                </div>
              </div>
            </div>
          <% end %>
          <p class="text-center text-gray-500 text-sm mt-4">Total votes: {total_votes}</p>
        </div>
      <% else %>
        <form phx-submit="vote" class="space-y-4">
          <%= for option <- @poll.options do %>
            <div>
              <label class="">
                <input
                  type="radio"
                  name="option_id"
                  value={option.id}
                  required
                  class="radio mr-2"
                />
                <span>{option.label}</span>
              </label>
            </div>
          <% end %>

          <.button type="submit" variant="primary">
            Submit Vote
          </.button>
        </form>
      <% end %>
    </div>
    """
  end
end
