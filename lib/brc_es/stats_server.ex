defmodule BrcEs.StatsServer do
  use GenServer
  alias BrcEs.Stat

  @impl true
  def init(_args) do
    {:ok, %{}}
  end

  def add_record(pid, record) do
    GenServer.cast(pid, {:add_record, record})
  end

  def get_stats(pid, city) do
    GenServer.call(pid, {:get_stats, city})
  end

  def to_strings(pid) do
    GenServer.call(pid, :to_strings)
  end

  @impl true
  def handle_cast({:add_record, [city, temp]}, state) do
    state =
      Map.update(state, city, Stat.new(temp), &Stat.update(&1, temp))

    {:noreply, state}
  end

  @impl true
  def handle_call(:to_strings, _, state) do
    strings =
      state
      |> Map.keys()
      |> Enum.sort()
      |> Enum.map(fn city ->
        state
        |> Map.get(city)
        |> Stat.to_string(city)
      end)

    {:reply, strings, state}
  end

  @impl true
  def handle_call({:get_stats, city}, _, state) do
    stat = Map.get(state, city)
    {:reply, stat, state}
  end
end
