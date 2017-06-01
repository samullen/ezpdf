defmodule EZPDF.CLI do
  def main(argv) do
    argv
    |> Config.setup
    |> process
  end

  def process(:help) do
    IO.puts """
      usage: ezpdf [path to input file]
      """
  end

  def process(input_path) do
    input_path
    |> Processor.process
  end
end
