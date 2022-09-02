defmodule Slack.Webhook do
  @moduledoc """
  Send message through slack webhook
  """

  @doc """
  Send message function

  ## Examples
      iex> Slack.Webhook.send("", "")
      {:error, "Message and Webhook can't be nil or empty"}
      iex> Slack.Webhook.send(nil, nil)
      {:error, "Message and Webhook can't be nil or empty"}
      iex> Slack.Webhook.send(%{}, %{})
      {:error, "Invalid format."}
      iex> Slack.Webhook.send("message", "invalid")
      {:error, "Use a valid webhook link (https://hooks.slack.com/services/123)"}
      iex> Slack.Webhook.send("message", "")
      {:error, %{body: "invalid_token", status_code: 403}}

  """

  def send(message, webhook)
      when is_nil(message) or is_nil(webhook) or message == "" or webhook == "" do
    {:error, "Message and Webhook can't be nil or empty"}
  end

  def send(message, webhook) when is_binary(message) and is_binary(webhook) do
    body =
      Jason.encode!(%{
        text: message
      })

    response =
      HTTPoison.post(
        webhook,
        body,
        "Content-Type": "application/json"
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

  def send(_, _), do: {:error, "Invalid format."}
end
