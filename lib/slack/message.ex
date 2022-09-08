defmodule Slack.Message do
  @moduledoc """
  Send message to slack using API token and channel ID.
  """
  @url "https://slack.com/api/chat.postMessage"
  @token Application.compile_env!(:slack, :token)

  @doc """
  Send message function

  ## Examples
      iex> Slack.Message.send("", "", "")
      {:error, "Message and channel_id can't be nil or blank."}

      iex> Slack.Message.send(nil, nil, "")
      {:error, "Message and channel_id can't be nil or blank."}

      iex> Slack.Message.send("123", "Hello")
      {:error, %{error: "channel_not_found", status_code: 200}}

      iex> Slack.Message.send(%{}, %{})
      {:error, %{error: "Invalid params", status_code: 500}}

      iex> Slack.Message.send("channel_id", "message", %{channel_id: "123456"})
      {:error, %{error: "channel_not_found", status_code: 200}}

  """
  @spec send(binary, binary) :: tuple
  @spec send(binary, binary, map) :: tuple
  def send(channel_id, message, opts \\ %{})

  def send(channel_id, message, _opts)
      when is_nil(message) or is_nil(channel_id) or message == "" or
             channel_id == "" do
        response_handler("Message and channel_id can't be nil or blank.", nil)
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
      {:ok, %{status_code: status_code} = response} ->
        response.body
        |> Jason.decode!()
        |> response_handler(status_code)

      {_, error} ->
        response_handler(error, error.status_code)
    end
  end

  def send(_, _, _) do
    response_handler(%{"ok" => false, "error" => "Invalid params"}, 500)
  end

  defp body(body, %{thread_id: thread_id}) do
    Map.put(body, :thread_ts, thread_id)
  end

  defp body(body, %{}), do: body
  defp body(body, _), do: body

  defp headers() do
    [
      Authorization: "Bearer #{@token}",
      "Content-type": "application/json; charset=utf-8"
    ]
  end

  defp response_handler(%{"ok" => true, "ts" => thread_id} = body, status_code)
       when status_code >= 200 and status_code <= 299 do
    {:ok,
     %{
       status_code: status_code,
       thread_id: thread_id,
       response: "Message sent successfully to channel " <> body["channel"]
     }}
  end

  defp response_handler(%{"ok" => false, "error" => error}, status_code) do
    {:error,
     %{
       status_code: status_code,
       error: error
     }}
  end

  defp response_handler(error, status_code) do
    {:error, %{error: error, status_code: status_code}}
  end
end
