defmodule Redirex.Store do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  def set(key, value) do
    GenServer.call(__MODULE__, {:set, {key, value}})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, {key}})
  end

  def host do
    GenServer.call(__MODULE__, {:host})
  end

  def init(args) do
    Logger.info("Initializing #{__MODULE__}")

    table_name = args[:table_name] || :"data/store.dets"
    {:ok, table} = :dets.open_file(table_name, type: :set)
    {:ok, {table}}
  end

  def handle_call({:set, {key, value}}, _from, {table}) do
    res = :dets.insert(table, {key, value})
    :dets.sync(table)
    {:reply, res, {table}}
  end

  def handle_call({:get, {key}}, _from, {table}) do
    case :dets.lookup(table, key) do
      [] -> {:reply, nil, {table}}
      [{^key, result}] -> {:reply, result, {table}}
    end
  end

  def handle_call({:host}, _from, {table}) do
    case :dets.lookup(table, :host) do
      [] ->
        host = Application.fetch_env(:redirex, :host)
        :dets.insert(table, {:host, host})
        :dets.sync(table)
        {:reply, host, {table}}

      [{:host, result}] ->
        {:reply, result, {table}}
    end
  end
end
