defmodule Slack do
  @moduledoc false

  def slack_result(response) do
    status =
      case response.body do
        "ok" ->
          :ok

        "invalid_token" ->
          :error
      end

    {status, %{status_code: response.status_code, body: response.body}}
  end
end
