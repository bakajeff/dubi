defmodule DubiWeb.Poll.New do
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
    # Make sure Ecto doesn't see empty IDs as duplicates
    poll_params = scrub_options(poll_params)

    changeset =
      %Poll{}
      |> Voting.change_poll(poll_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("add-option", _, socket) do
    # Get current options from the form's changeset
    changeset = socket.assigns.form.source
    existing_options = Ecto.Changeset.get_assoc(changeset, :options)

    # Add a new blank option
    new_options = existing_options ++ [%Option{}]

    # Update the changeset
    changeset =
      changeset
      |> Ecto.Changeset.put_assoc(:options, new_options)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("remove-option", %{"index" => index}, socket) do
    index = String.to_integer(index)
    changeset = socket.assigns.form.source

    existing_options = Ecto.Changeset.get_assoc(changeset, :options)
    new_options = List.delete_at(existing_options, index)

    changeset =
      changeset
      |> Ecto.Changeset.put_assoc(:options, new_options)
      |> Map.put(:action, :validate)

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

  defp scrub_options(params) do
    if options = params["options"] do
      scrubbed =
        Enum.into(options, %{}, fn {k, v} ->
          {k, Map.delete(v, "id")}
        end)

      Map.put(params, "options", scrubbed)
    else
      params
    end
  end

  def render(assigns) do
    ~H"""
    <div class="container max-w-2xl mx-auto bg-base-200 p-8 rounded-lg">
      <h1 class="">Question & Answers</h1>

      <.form for={@form} phx-change="validate" phx-submit="save" class="space-y-4">
        <div>
          <.input field={@form[:question]} label="Ask a question" placeholder="What's on your mind?" />
        </div>

        <div class="">
          <label class="">Options</label>
          <.inputs_for :let={option} field={@form[:options]}>
            <div class="flex gap-2 items-center">
              <div class="grow">
                <.input field={option[:label]} placeholder={"Option #{option.index + 1}"} />
              </div>

              <button
                type="button"
                phx-click="remove-option"
                phx-value-index={option.index}
                class="text-red-500 hover:text-red-700"
              >
                <.icon name="hero-minus-mini" />
              </button>
            </div>
          </.inputs_for>
        </div>

        <div>
          <.button
            type="button"
            phx-click="add-option"
          >
            <.icon name="hero-plus-mini" /> Add option
          </.button>
        </div>

        <div class="flex justify-end">
          <.button variant="primary">
            Create Poll
          </.button>
        </div>
      </.form>
    </div>
    """
  end
end
