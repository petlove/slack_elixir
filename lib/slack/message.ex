defmodule Slack.Message do
  @moduledoc """
  Send message to slack using API token and channel ID.
  """
  @url "https://slack.com/api/chat.postMessage"

  @doc """
  Send message function

  ## Examples
      iex> Slack.Message.send("", "", "")
      {:error, "Message, token and channel_id can't be nil or blank."}
      iex> Slack.Message.send(nil, nil, "", "")
      {:error, "Message, token, channel_id and thread_id can't be nil or blank."}
      iex>
  """

  def send(message, token, channel_id)
      when is_nil(message) or is_nil(token) or is_nil(channel_id) or message == "" or token == "" or
             channel_id == "" do
    {:error, "Message, token and channel_id can't be nil or blank."}
  end

  def send(message, token, channel_id)
      when is_binary(message) and is_binary(token) and is_binary(channel_id) do
    body =
      Jason.encode!(%{
        text: message,
        channel: channel_id
      })

    case HTTPoison.post(@url, body, headers(token)) do
      {:ok, response} ->
        response.body
        |> Jason.decode!()
        |> response_handler()

      {:error, error} ->
        {:error, error}
    end
  end

  def send(_, _, _) do
    response_handler(%{"ok" => false, "error" => "Invalid params"})
  end

  @doc """
    Send message to thread
  """
  def send(message, token, channel_id, thread_id)
      when is_nil(message) or is_nil(token) or is_nil(channel_id) or is_nil(thread_id) or
             message == "" or token == "" or
             channel_id == "" or thread_id == "" do
    {:error, "Message, token, channel_id and thread_id can't be nil or blank."}
  end

  def send(message, token, channel_id, thread_id)
      when is_binary(message) and is_binary(token) and is_binary(channel_id) and
             is_binary(thread_id) do
    body =
      Jason.encode!(%{
        text: message,
        thread_ts: thread_id,
        channel: channel_id
      })

    HTTPoison.post(@url, body, headers(token))
  end

  def send(_, _, _, _) do
    response_handler(%{"ok" => false, "error" => "Invalid params"})
  end

  @doc """
    Create auth headers
  """
  def headers(token) do
    [
      Authorization: "Bearer #{token}",
      "Content-type": "application/json; charset=utf-8"
    ]
  end

  @doc """
    Create response
  """
  def response_handler(%{"ok" => true, "ts" => thread_id} = body) do
    {:ok,
     %{
       status_code: 200,
       thread_id: thread_id,
       response: "Message sent successfully to channel " <> body["channel"]
     }}
  end

  def response_handler(%{"ok" => false, "error" => error}) do
    {:error,
     %{
       status_code: 200,
       error: error
     }}
  end
end
