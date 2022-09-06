# Slack

Elixir lib to send messages to Slack through a webhook or with an API token.

## Installation

If the package can be installed by adding `slack` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:slack, github: "petlove/slack_elixir"},
  ]
end
```

## Setup
Follow the [slack API docs](https://api.slack.com/docs) to create your own app and retrieve your API keys and/or webhooks. 

Add the following to your `config.exs`:
```elixir
config :slack,
  token: "slack_api_token"
```

<!-- Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/slack](https://hexdocs.pm/slack). -->

