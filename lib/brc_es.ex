defmodule BrcEs do
  @moduledoc """
  Documentation for `BrcEs`.
  """
  alias BrcEs.StatsServer

  def main(args) do
    IO.inspect(args)
    {:ok, pid} = GenServer.start_link(StatsServer, %{})

    File.stream!(Enum.at(args, 0))
    |> Stream.filter(fn l -> !String.starts_with?(l, "#") end)
    |> Stream.map(fn l ->
      l
      |> String.trim_trailing()
      |> String.split(";")
      |> List.update_at(1, fn n ->
        {n, _} = Float.parse(n)
        n
      end)
    end)
    |> Enum.each(fn r -> StatsServer.add_record(pid, r) end)

    IO.write("{")

    StatsServer.to_strings(pid)
    |> Enum.join(", ")
    |> IO.write()

    IO.puts("}")

    # IO.inspect(StatsServer.to_string(pid))
    # IO.inspect(StatsServer.get_stats(pid, "Delhi"))
  end
end
