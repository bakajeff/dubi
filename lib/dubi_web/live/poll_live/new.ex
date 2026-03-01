defmodule DubiWeb.PollLive.New do
  use DubiWeb, :live_view
  alias Dubi.Voting
  alias Dubi.Voting.{Poll, Option}

  def mount(_params, _session, socket) do
    changeset =
      Voting.change_poll(%Poll{
        options: [
          %Option{label: ""},
          %Option{label: ""}
        ]
      })

    {:ok, assign(socket, form: to_form(changeset))}
  end

  def handle_event("validate", %{"poll" => poll_params}, socket) do
    changeset =
      %Poll{}
      |> Voting.change_poll(poll_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("add-option", _, socket) do
    # Get current params from the form
    params = socket.assigns.form.params
    # Add a new blank option to the list
    options = Map.get(params, "options", %{})
    next_index = Enum.count(options) |> Integer.to_string()
    new_options = Map.put(options, next_index, %{"label" => ""})

    params = Map.put(params, "options", new_options)
    changeset = Voting.change_poll(%Poll{}, params)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"poll" => poll_params}, socket) do
    case Voting.create_poll(poll_params) do
      {:ok, poll} ->
        {:noreply, push_navigate(socket, to: ~p"/polls/#{poll.slug}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <div class="">
      <h1 class="">Create a New Poll</h1>

      <.form for={@form} phx-change="validate" phx-submit="save" class="space-y-4">
        <div>
          <.input field={@form[:question]} label="Question" placeholder="What's on your mind?" />
        </div>

        <div class="">
          <label class="">Options</label>
          <.inputs_for :let={option} field={@form[:options]}>
            <div class="">
              <.input field={option[:label]} placeholder={"Option #{option.index + 1}"} />
            </div>
          </.inputs_for>
        </div>

        <div class="">
          <button
            type="button"
            phx-click="add-option"
            class=""
          >
            Add another option
          </button>

          <button class="">
            Create Poll
          </button>
        </div>
      </.form>
    </div>
    """
  end
end
