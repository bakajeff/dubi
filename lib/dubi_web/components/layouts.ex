defmodule DubiWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use DubiWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="border-b border-slate-200/80 bg-white/85 px-4 backdrop-blur sm:px-6 lg:px-8 dark:border-slate-800 dark:bg-slate-950/80">
      <div class="mx-auto flex h-16 max-w-5xl items-center justify-between gap-4">
        <a
          href="/"
          class="flex w-fit items-center gap-3 rounded-md text-slate-950 transition hover:text-orange-600 dark:text-white dark:hover:text-orange-300"
        >
          <img src={~p"/images/logo.svg"} width="36" alt="Dubi" />
          <span class="text-sm font-semibold">Dubi</span>
        </a>

        <ul class="flex items-center gap-2 text-sm font-medium">
          <li>
            <.link
              navigate={~p"/polls/new"}
              class="rounded-md px-3 py-2 text-slate-600 transition hover:bg-slate-100 hover:text-slate-950 dark:text-slate-300 dark:hover:bg-slate-900 dark:hover:text-white"
            >
              New poll
            </.link>
          </li>
          <li>
            <.theme_toggle />
          </li>
        </ul>
      </div>
    </header>

    <main class="px-4 py-10 sm:px-6 lg:px-8">
      {render_slot(@inner_block)}
    </main>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="relative grid grid-cols-3 rounded-full border border-slate-200 bg-slate-100 p-1 shadow-sm dark:border-slate-800 dark:bg-slate-900">
      <div class="absolute inset-y-1 left-1 w-[calc(33.333%-0.25rem)] rounded-full bg-white shadow-sm transition-[left] [[data-theme=light]_&]:left-[33.333%] [[data-theme=dark]_&]:left-[calc(66.666%-0.25rem)] dark:bg-slate-800" />

      <button
        type="button"
        id="theme-system"
        class="relative z-10 flex cursor-pointer items-center justify-center rounded-full p-2 text-slate-500 transition hover:text-slate-950 dark:text-slate-400 dark:hover:text-white"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
        title="Use system theme"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4" />
      </button>

      <button
        type="button"
        id="theme-light"
        class="relative z-10 flex cursor-pointer items-center justify-center rounded-full p-2 text-slate-500 transition hover:text-slate-950 dark:text-slate-400 dark:hover:text-white"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
        title="Use light theme"
      >
        <.icon name="hero-sun-micro" class="size-4" />
      </button>

      <button
        type="button"
        id="theme-dark"
        class="relative z-10 flex cursor-pointer items-center justify-center rounded-full p-2 text-slate-500 transition hover:text-slate-950 dark:text-slate-400 dark:hover:text-white"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
        title="Use dark theme"
      >
        <.icon name="hero-moon-micro" class="size-4" />
      </button>
    </div>
    """
  end
end
