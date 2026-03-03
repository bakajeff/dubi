defmodule DubiWeb.Poll.ResultsComponent do
  use DubiWeb, :html

  attr :poll, :any, required: true

  def render(assigns) do
    total_votes = Enum.sum(Enum.map(assigns.poll.options, & &1.votes))
    assigns = assign(assigns, :total_votes, total_votes)

    ~H"""
    <div class="space-y-6">
      <%= for option <- @poll.options do %>
        <% percent = get_percent(option.votes, @total_votes) %>
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
      <p class="text-center text-gray-500 text-sm mt-4">Total votes: {@total_votes}</p>
    </div>
    """
  end

  defp get_percent(votes, total) when total > 0, do: round(votes / total * 100)
  defp get_percent(_votes, _total), do: 0
end
