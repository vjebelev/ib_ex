defmodule IbEx.Client.Messages.HistoricalBarData.Update do
  defstruct request_id: nil, bar: nil

  alias IbEx.Client.Types.Bar
  alias IbEx.Client.Protocols.Traceable
  alias IbEx.Client.Protocols.Subscribable

  def from_fields([request_id | bar_fields]) do
    case Bar.from_historical_data_update(bar_fields) do
      {:ok, bar} ->
        {:ok,
         %__MODULE__{
           request_id: request_id,
           bar: bar
         }}

      _ ->
        {:error, :invalid_args}
    end
  end

  def from_fields(_fields) do
    {:error, :invalid_args}
  end

  defimpl Traceable, for: __MODULE__ do
    def to_s(msg) do
      "<-- HistoricalBarDataUpdate{request_id: #{msg.request_id}, bar: #{inspect(msg.bar)}}"
    end
  end

  defimpl Subscribable, for: __MODULE__ do
    alias IbEx.Client.Subscriptions

    def subscribe(_, _, _) do
      {:error, :response_messages_cannot_create_subscription}
    end

    def lookup(msg, table_ref) do
      Subscriptions.lookup(table_ref, msg.request_id)
    end
  end
end
