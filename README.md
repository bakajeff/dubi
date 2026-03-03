# Dubi

A sleek, real-time polling app built with **Elixir** and **Phoenix LiveView**. Create a poll, share the link, and watch votes roll in — no page refreshes needed.

## Features

- **Instant poll creation** — write a question, add options, and get a shareable link in seconds
- **Real-time results** — votes update live across all connected browsers via Phoenix PubSub
- **Shareable links** — each poll gets a unique short URL with one-click copy to clipboard
- **Dynamic forms** — add or remove options on the fly before submitting
- **Responsive UI** — styled with Tailwind CSS v4 for a clean look on any device

## Tech Stack

- **Elixir** — functional, concurrent, fault-tolerant
- **Phoenix 1.8** — the latest Phoenix with LiveView-first defaults
- **Phoenix LiveView 1.1** — real-time UI without writing custom JavaScript
- **Ecto + PostgreSQL** — schema-backed data layer with transactional vote counting
- **Tailwind CSS v4** — utility-first styling with zero config
- **esbuild** — fast JS bundling

## Getting Started

### Prerequisites

- [Elixir](https://elixir-lang.org/install.html) ~> 1.15
- [PostgreSQL](https://www.postgresql.org/) (or use the included Docker Compose file)

### Setup

```sh
# Clone the repo
git clone https://github.com/bakajeff/dubi.git
cd dubi

# Start PostgreSQL (if using Docker)
docker compose up -d

# Install deps, create DB, run migrations, and build assets
mix setup

# Start the server
mix phx.server
```

Then open [localhost:4000](http://localhost:4000) in your browser.

## Usage

1. Navigate to [`/polls/new`](http://localhost:4000/polls/new) to create a poll
2. Enter your question, add as many options as you like, and hit **Create Poll**
3. Share the generated link with others
4. Vote and see results update in real time

## Running Tests

```sh
mix test
```

---

Built with Elixir and Phoenix Framework
