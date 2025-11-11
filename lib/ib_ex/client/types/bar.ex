defmodule IbEx.Client.Types.Bar do
  @moduledoc """
    Represents a bar (historical or real time).
  """

  defstruct timestamp: nil,
            open: nil,
            high: nil,
            low: nil,
            close: nil,
            volume: nil,
            vwap: nil,
            num_trades: nil

  alias IbEx.Client.Protocols.Traceable

  def from_historical_bars([
        ts,
        open_str,
        high_str,
        low_str,
        close_str,
        volume_str,
        vwap_str,
        num_trades_str
      ]) do
    case DateTime.from_unix(String.to_integer(ts)) do
      {:ok, timestamp} ->
        {
          :ok,
          %__MODULE__{
            timestamp: timestamp,
            open: Decimal.new(open_str),
            high: Decimal.new(high_str),
            low: Decimal.new(low_str),
            close: Decimal.new(close_str),
            volume: String.to_integer(volume_str),
            vwap: Decimal.new(vwap_str),
            num_trades: String.to_integer(num_trades_str)
          }
        }

      _ ->
        {:error, :invalid_args}
    end
  rescue
    _ ->
      {:error, :invalid_args}
  end

  def from_historical_bars(_) do
    {:error, :invalid_args}
  end

  def from_historical_data_update([
        num_trades_str,
        ts,
        open_str,
        high_str,
        low_str,
        close_str,
        vwap_str,
        volume_str
      ]) do
    case DateTime.from_unix(String.to_integer(ts)) do
      {:ok, timestamp} ->
        {
          :ok,
          %__MODULE__{
            timestamp: timestamp,
            open: Decimal.new(open_str),
            high: Decimal.new(high_str),
            low: Decimal.new(low_str),
            close: Decimal.new(close_str),
            volume: String.to_integer(volume_str),
            vwap: Decimal.new(vwap_str),
            num_trades: String.to_integer(num_trades_str)
          }
        }

      _ ->
        {:error, :invalid_args}
    end
  rescue
    _ ->
      {:error, :invalid_args}
  end

  def from_historical_data_update(_) do
    {:error, :invalid_args}
  end

  defimpl Traceable, for: __MODULE__ do
    def to_s(bar) do
      "Bar{
        timestamp: #{bar.timestamp},
        open: #{bar.open},
        high: #{bar.high},
        low: #{bar.low},
        close: #{bar.close},
        volume: #{bar.volume},
        vwap: #{bar.vwap},
        num_trades: #{bar.num_trades}
      }"
    end
  end
end
