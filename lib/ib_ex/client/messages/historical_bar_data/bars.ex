defmodule IbEx.Client.Messages.HistoricalBarData.Bars do
  defstruct request_id: nil, bars: nil

  alias IbEx.Client.Types.Bar
  alias IbEx.Client.Protocols.Traceable
  alias IbEx.Client.Protocols.Subscribable

  def from_fields([request_id, _start_datetime, _end_datetime, _amount_of_bars | bar_fields]) do
    bars =
      bar_fields
      |> Enum.chunk_every(8)
      |> Enum.map(&Bar.from_historical_bars/1)
      |> Keyword.get_values(:ok)

    {:ok,
     %__MODULE__{
       request_id: request_id,
       bars: bars
     }}
  end

  def from_fields(_fields) do
    {:error, :invalid_args}
  end

  defimpl Traceable, for: __MODULE__ do
    def to_s(msg) do
      "<-- HistoricalBars{request_id: #{msg.request_id}, bars: #{inspect(msg.bars)}}"
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
