defmodule EZPDF.CLI do
  def main(argv) do
    argv
    |> parse_args
    |> parse_config
    |> process_input
    |> process_pdf
    |> output_pdf
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

  def parse_config(args_options) do
    {args, input_file, _} = args_options

    case ConfigParser.parse_file(Path.expand("~/.ezpdfrc")) do
      {:ok, config} -> 
        Application.put_env(:EZPDF, "header", args[:header] || config["config"]["header"])
        Application.put_env(:EZPDF, "footer", args[:footer] || config["config"]["footer"])
        Application.put_env(:EZPDF, "output", args[:output] || config["config"]["output"])
      _ -> %{}
    end

    input_file
  end

  def process_input([]) do
    IO.read(:stdio, :all)
    |> Earmark.as_html
  end
  def process_input([input_path]) do
    case File.read(input_path) do
      {:ok, data} -> Earmark.as_html(data)
      {:error, msg} -> IO.puts :stderr, :file.format_error(msg)
    end
  end
  def process_input(:help) do
    IO.puts """
      usage: ezpdf [path to input file]
      """
  end

  def process_pdf({:ok, html, _}) do
    Enum.join([header_html(), html, footer_html()])
    |> PdfGenerator.generate_binary(page_size: "Letter", shell_params: ["--print-media-type", "--page-size", "Letter", "--dpi", "150", "--zoom", "3", "--margin-top", "8", "--margin-right", "8", "--margin-bottom", "8", "--margin-left", "8"])
  end

  def output_pdf({:ok, pdf_content}) do
    if Application.get_env(:EZPDF, "output") do
      File.write(Application.get_env(:EZPDF, "output"), pdf_content)
    else
      IO.binwrite(:stdio, pdf_content)
    end
  end

  defp header_html do
    case File.read("#{Application.get_env(:EZPDF, "header")}") do
      {:ok, data} -> data
      _ -> "<!DOCTYPE html>\n<html>\n<head></head>\n<body>"
    end
  end

  defp footer_html do
    case File.read("#{Application.get_env(:EZPDF, "footer")}") do
      {:ok, data} -> data
      _ -> "</body></html>"
    end
  end
end
