defmodule EZPDF.CLI do
  def main(argv) do
    argv
    |> EZPDF.Config.setup
    |> process
  end

  def process(:help) do
    IO.puts """
      Usage: ezpdf [options] [markdown file]

        -h, --help              # Usage help
        -H, --header file       # html file to use as the header
        -f, --footer file       # html file to use as the footer
        -o, --output file       # output PDF to file (default: ./output.pdf)
      """
  end

  def process(input_path) do
    input_path
    |> EZPDF.Processor.process
  end
end
