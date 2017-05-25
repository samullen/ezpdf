defmodule EZPDF.CLI do
  def main(argv) do
    argv
    |> parse_args
    # |> parse_config
    |> process_input
    # |> process
  end

  def parse_args(argv) do
    options = OptionParser.parse(argv, 
                                 switches: [
                                   help: :boolean, header: :string, 
                                   footer: :string, output: :string
                                 ],
                                 aliases: [
                                   h: :help, H: :header, F: :footer, o: :output
                                 ])

    case options do
      {[help: true], _, _} -> :help
      {_, _, _}            -> options
      _                    -> :help
    end
  end

  def process_input({options, [], []}) do
    IO.read(:stdio, :all)
  end
  def process_input({options, [input_path], []}) do
    case File.read(input_path) do
      {:ok, data} -> data
      {:error, msg} -> IO.puts :stderr, :file.format_error(msg)
    end
  end

  # def process() do
  # end
end
