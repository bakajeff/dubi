defmodule DubiWeb.Poll.ResultsComponent do
  use DubiWeb, :html

  attr :poll, :any, required: true

  def render(assigns) do
    total_votes = Enum.sum(Enum.map(assigns.poll.options, &(&1.votes || 0)))
    assigns = assign(assigns, :total_votes, total_votes)

    ~H"""
    <div id="poll-results" class="space-y-6">
      <%= for option <- @poll.options do %>
        <% percent = get_percent(option.votes || 0, @total_votes) %>
        <div class="relative">
          <div class="flex justify-between mb-1 text-sm font-semibold">
            <span class="text-slate-800 dark:text-slate-200">{option.label}</span>
            <span class="text-slate-500 dark:text-slate-400">{percent}% ({option.votes || 0})</span>
          </div>

          <div class="h-3 overflow-hidden rounded-full bg-slate-100 dark:bg-slate-800">
            <div
              class="h-3 rounded-full bg-orange-500 transition-[width] duration-500"
              style={"width: #{percent}%"}
            >
            </div>
          </div>
        </div>
      <% end %>

      <div class="border-t border-slate-200 dark:border-slate-800" />

      <p class="mt-4 text-sm text-slate-500 dark:text-slate-400">Total votes: {@total_votes}</p>

      <div class="flex gap-4">
        <button
          type="button"
          class="inline-flex items-center justify-center gap-2 rounded-md border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-700 shadow-sm transition hover:bg-slate-50 focus:outline-none focus:ring-4 focus:ring-orange-500/15 dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100 dark:hover:bg-slate-800"
          id="share-poll"
          phx-hook=".CopyToClipboard"
          phx-update="ignore"
          data-share-link={"#{DubiWeb.Endpoint.url()}/polls/#{@poll.slug}"}
        >
          <.icon name="hero-share" class="size-4" />
          <span data-share-label>Share</span>
        </button>
      </div>
    </div>

    <script :type={Phoenix.LiveView.ColocatedHook} name=".CopyToClipboard">
      export default {
        mounted() {
          this.el.addEventListener("click", event => {
            const link = this.el.getAttribute("data-share-link");
            const label = this.el.querySelector("[data-share-label]");

            navigator.clipboard.writeText(link).then(() => {
              const originalText = label.textContent;
              label.textContent = "Copied";
              this.el.classList.add("border-emerald-300", "bg-emerald-50", "text-emerald-700");

              setTimeout(() => {
                label.textContent = originalText;
                this.el.classList.remove("border-emerald-300", "bg-emerald-50", "text-emerald-700");
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
