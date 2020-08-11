defmodule WordCount do
  @moduledoc """

  ## Examples

  iex> WordCount.run("./priv/be-proud-of-who-you-are.txt")
  [
    {"i", 7},
    {"to", 5},
    {"my", 3},
    {"and", 3},
    {"me", 3},
    {"when", 3},
    {"be", 3},
    {"a", 2},
    {"am", 2},
    {"can", 2}
  ]

  iex> WordCount.run("nonexistant.txt")
  "File not found"
  """

  def run(file) do
    output = file
             |> read()
             |> parse()
             |> sum_words()
             |> top10()

    IO.inspect(output)
  end

  defp read(file) do
    case File.read(file) do
      {:ok, text} -> {:ok, text}
      {:error, error} -> {:error, error}
    end
  end

  defp parse({:ok, contents}) do
    words = String.downcase(contents)
            |> String.replace(".", "")
            |> String.split([" ", "\n"])
            |> Enum.filter(fn(element) -> String.length(element) > 0 end)

    {:ok, words}
  end
  defp parse(error), do: error

  defp sum_words({:ok, words}) do
    occurences = Enum.reduce(words, %{}, fn(x, acc) ->
      Map.update(acc, x, 1, &(&1 + 1))
    end)

    {:ok, occurences}
  end
  defp sum_words(error), do: error

  defp top10({:ok, words}) do
    second_value = fn(element) ->
      {_, count} = element

      count
    end

    words
    |> Enum.sort_by(second_value, :desc)
    |> Enum.take(10)
  end
  defp top10({:error, error}) do
    case error do
      :enoent -> "File not found"
      _ -> error
    end
  end
end
