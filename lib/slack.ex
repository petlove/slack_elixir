defmodule Slack do
  @moduledoc """
  Documentation for `Slack`.
  """

  @doc """
  Send message through slack webhook

  ## Examples
      iex> Slack.send_message_webhook("Hello, world", "https://slack-webhook.com/test")
      :ok
      iex> Slack.send_message_webhook("", "")
      nil
      iex> Slack.send_message_webhook(nil, nil)
      nil
  """
  # Raise error
  def send_message_webhook(nil, nil), do: nil
  # Raise error
  def send_message_webhook("", ""), do: nil

  def send_message_webhook(message, webhook) when is_binary(message) and is_binary(webhook) do
    # when message and webhook is binary
    # nil
    :ok
  end

end
