defmodule BrcEs.Stat do
  defstruct [:min, :max, :sum, :count, :mean]

  def new(temp) do
    %__MODULE__{
      min: temp,
      max: temp,
      sum: temp,
      count: 1,
      mean: temp
    }
  end

  def update(stat, temp) do
    stat
    |> update_field(:min, temp)
    |> update_field(:max, temp)
    |> update_field(:mean, temp)
  end

  def to_string(stat, city) do
    min = Float.round(stat.min, 2)
    max = Float.round(stat.max, 2)
    mean = Float.round(stat.mean, 2)

    "#{city}=#{min}/#{max}/#{mean}"
  end

  defp update_field(%__MODULE__{min: min} = stat, :min, temp) when temp < min do
    Map.put(stat, :min, temp)
  end

  defp update_field(%__MODULE__{max: max} = stat, :max, temp) when temp > max do
    Map.put(stat, :max, temp)
  end

  defp update_field(%__MODULE__{count: count, sum: sum} = stat, :mean, temp) do
    stat
    |> Map.put(:count, count + 1)
    |> Map.put(:sum, sum + temp)
    |> update_mean()
  end

  defp update_field(stat, _, _), do: stat

  defp update_mean(stat = %__MODULE__{count: count, sum: sum}) do
    Map.put(stat, :mean, sum / count)
  end
end
