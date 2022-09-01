defmodule Slack.Webhook do
  @moduledoc """
  Send message through slack webhook
  """

  @doc """
  Send message function

  ## Examples
      iex> Slack.Webhook.send_message("", "")
      {:error, "Message and Webhook can't be nil or empty"}
      iex> Slack.Webhook.send_message(nil, nil)
      {:error, "Message and Webhook can't be nil or empty"}
      iex> Slack.Webhook.send_message(%{}, %{})
      {:error, "Invalid format."}
      iex> Slack.Webhook.send_message("message", "invalid")
      {:error, "Use a valid webhook link (https://hooks.slack.com/services/123)"}
      iex> Slack.Webhook.send_message("message", "")
      {:error, %{body: "invalid_token", status_code: 403}}

  """

  def send_message(message, webhook)
      when is_nil(message) or is_nil(webhook) or message == "" or webhook == "" do
    {:error, "Message and Webhook can't be nil or empty"}
  end

  def send_message(message, webhook) when is_binary(message) and is_binary(webhook) do
    body =
      Jason.encode!(%{
        text: message
      })

    response =
      HTTPoison.post(
        webhook,
        body,
        ["Content-Type": "application/json"]
      )

    case response do
      {:ok, result} ->
        Slack.slack_result(result)

      {:error, %HTTPoison.Error{id: _, reason: :nxdomain}} ->
        {:error, "Use a valid webhook link (https://hooks.slack.com/services/123)"}

      {:error, error} ->
        {:error, error}
    end
  end

  def send_message(_, _), do: {:error, "Invalid format."}
end
