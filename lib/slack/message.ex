defmodule Slack.Message do
  @moduledoc """
  Send message to slack using API token and channel ID.
  """
  @url "https://slack.com/api/chat.postMessage"
  @token Application.fetch_env!(:slack, :token)

  @doc """
  Send message function

  ## Examples
      iex> Slack.Message.send("", "", "")
      {:error, "Message and channel_id can't be nil or blank."}
      iex> Slack.Message.send(nil, nil, "")
      {:error, "Message and channel_id can't be nil or blank."}
      iex> Slack.Message.send(nil, nil, "")
      {:error, "Message and channel_id can't be nil or blank."}
      iex> Slack.Message.send("123", "Hello")
      {:error, %{error: "channel_not_found", status_code: 200}}

  """
  def send(channel_id, message, opts \\ %{})

  def send(channel_id, message, _opts)
      when is_nil(message) or is_nil(channel_id) or message == "" or
             channel_id == "" do
    {:error, "Message and channel_id can't be nil or blank."}
  end

  def send(channel_id, message, opts)
      when is_binary(message) and is_binary(channel_id) do
    body =
      %{
        text: message,
        channel: channel_id
      }
      |> body(opts)
      |> Jason.encode!()

    case HTTPoison.post(@url, body, headers()) do
      {:ok, %{status_code: status_code} = response}
      when status_code >= 200 and status_code <= 299 ->
        response.body
        |> Jason.decode!()
        |> response_handler()

      {_, error} ->
        {:error, error}
    end
  end

  def send(_, _, _) do
    response_handler(%{"ok" => false, "error" => "Invalid params"})
  end

  def body(body, %{thread_id: thread_id}) do
    Map.put(body, :thread_ts, thread_id)
  end

  def body(body, %{}), do: body
  def body(body, _), do: body

  defp headers() do
    [
      Authorization: "Bearer #{@token}",
      "Content-type": "application/json; charset=utf-8"
    ]
  end

  defp response_handler(%{"ok" => true, "ts" => thread_id} = body) do
    {:ok,
     %{
       status_code: 200,
       thread_id: thread_id,
       response: "Message sent successfully to channel " <> body["channel"]
     }}
  end

  defp response_handler(%{"ok" => false, "error" => error}) do
    {:error,
     %{
       status_code: 200,
       error: error
     }}
  end
end
