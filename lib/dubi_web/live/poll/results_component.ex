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

          <progress class="progress progress-primary w-full" value={percent} max="100"></progress>
        </div>
      <% end %>

      <div class="divider" />

      <p class="text-gray-500 text-sm mt-4">Total votes: {@total_votes}</p>

      <div class="flex gap-4">
        <div
          class="btn btn-soft btn-primary"
          id="btn-share"
          phx-hook=".CopyToClipboard"
          data-share-link={"http://localhost:4000/polls/#{@poll.slug}"}
        >
          <.icon name="hero-share" /> Share
        </div>
      </div>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".CopyToClipboard">
      export default {
        mounted() {
          this.el.addEventListener("click", event => {
            const link = this.el.getAttribute("data-share-link");

            navigator.clipboard.writeText(link).then(() => {
              const originalText = this.el.innerText;
              this.el.innerText = "Copied! ✅";
              this.el.classList.add("btn-success");

              setTimeout(() => {
                this.el.innerText = originalText;
                this.el.classList.remove("btn-success");
              }, 2000);
            });
          });
        }
      }
    </script>
    """
  end

  defp get_percent(votes, total) when total > 0, do: round(votes / total * 100)
  defp get_percent(_votes, _total), do: 0
end
