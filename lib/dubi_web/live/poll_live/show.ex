defmodule DubiWeb.PollLive.Show do
  use DubiWeb, :live_view
  alias Dubi.Voting

  def mount(%{"slug" => slug}, _session, socket) do
    poll = Voting.get_poll_by_slug!(slug)

    {:ok, assign(socket, poll: poll, voted: false)}
  end

  def handle_event("vote", %{"option_id" => option_id}, socket) do
    Voting.increment_vote(option_id)

    updated_poll = Voting.get_poll_by_slug!(socket.assigns.poll.slug)

    {:noreply, assign(socket, poll: updated_poll, voted: true)}
  end

  def render(assigns) do
    ~H"""
    <div class="">
      <h1 class="">{@poll.question}</h1>

      <%= if @voted do %>
        <div class="">
          <p class="">🎉 Thanks for voting!</p>

          <%= for option <- @poll.options do %>
            <div class="">
              <span class="">{option.label}</span>
              <span class="">
                {option.votes} {if option.votes == 1, do: "vote", else: "votes"}
              </span>
            </div>
          <% end %>
        </div>
      <% else %>
        <form phx-submit="vote" class="space-y-3">
          <%= for option <- @poll.options do %>
            <label class="">
              <input
                type="radio"
                name="option_id"
                value={option.id}
                required
                class=""
              />
              <span class="">{option.label}</span>
            </label>
          <% end %>

          <button
            type="submit"
            class=""
          >
            Submit Vote
          </button>
        </form>
      <% end %>
    </div>
    """
  end
end
