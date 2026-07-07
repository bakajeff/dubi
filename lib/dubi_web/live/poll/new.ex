defmodule DubiWeb.Poll.New do
  use DubiWeb, :live_view
  alias Dubi.Voting
  alias Dubi.Voting.{Poll, Option}

  def mount(_params, _session, socket) do
    {:ok, assign_form(socket, new_poll_changeset())}
  end

  def handle_event("validate", %{"poll" => poll_params}, socket) do
    changeset =
      %Poll{}
      |> Voting.change_poll(scrub_options(poll_params))
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("add-option", _, socket) do
    changeset = socket.assigns.form.source
    existing_options = Ecto.Changeset.get_assoc(changeset, :options)
    new_options = existing_options ++ [%Option{}]

    changeset =
      changeset
      |> Ecto.Changeset.put_assoc(:options, new_options)

    {:noreply, assign_form(socket, changeset)}
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

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"poll" => poll_params}, socket) do
    case Voting.create_poll(poll_params) do
      {:ok, poll} ->
        {:noreply, push_navigate(socket, to: ~p"/polls/#{poll.slug}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp new_poll_changeset do
    Voting.change_poll(%Poll{
      options: [
        %Option{label: ""},
        %Option{label: ""}
      ]
    })
  end

  defp assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset))
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
end
