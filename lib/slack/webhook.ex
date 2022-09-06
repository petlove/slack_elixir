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

      iex> Slack.Webhook.send("message", "")
      {:error, "Message and Webhook can't be nil or empty"}

      iex> Slack.Webhook.send(%{}, %{})
      {:error, "Invalid format."}

      iex> Slack.Webhook.send("message", "invalid")
      {:error, %{response: "Use a valid webhook link.", status_code: 500}}

      iex> Slack.Webhook.send("message", "")
      {:error, "Message and Webhook can't be nil or empty"}

  """
  @spec send(binary, binary) :: tuple
  def send(message, webhook)
      when is_nil(message) or is_nil(webhook) or message == "" or webhook == "" do
    {:error, "Message and Webhook can't be nil or empty"}
  end

  def send(message, webhook) when is_binary(message) and is_binary(webhook) do
    body =
      Jason.encode!(%{
        text: message
      })

    case HTTPoison.post(webhook, body, headers()) do
      {:ok, %{status_code: status_code} = response} ->
        response.body
        |> response_handler(status_code)

      {:error, %HTTPoison.Error{id: _, reason: :nxdomain}} ->
        response_handler("Use a valid webhook link.", 500)

      {_, error} ->
        response_handler(error, nil)
    end
  end

  def send(_, _), do: {:error, "Invalid format."}

  defp headers(), do: ["Content-Type": "application/json; charset=utf-8"]

  defp response_handler(response, status_code) when status_code >= 200 and status_code <= 299 do
    {:ok, %{status_code: status_code, response: response}}
  end

  defp response_handler("invalid_token", status_code) do
    {:error, %{status_code: status_code, response: "Invalid webhook."}}
  end

  defp response_handler(response, status_code) do
    {:error, %{status_code: status_code, response: response}}
  end
end
