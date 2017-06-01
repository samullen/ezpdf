defmodule EZPDF.CLI do
  def main(argv) do
    argv
    |> parse_args
    |> parse_config
    |> process_markdown
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

  def parse_config(:help) do
    :help
  end
  def parse_config(args_options) do
    {args, input_file, _} = args_options

    case ConfigParser.parse_file(Path.expand(Application.get_env(:ezpdf, :ezpdfrc_path))) do
      {:ok, config} -> 
        Application.put_env(:ezpdf, "header", args[:header] || config["config"]["header"])
        Application.put_env(:ezpdf, "footer", args[:footer] || config["config"]["footer"])
        Application.put_env(:ezpdf, "output", args[:output] || config["config"]["output"])
      _ -> %{}
    end

    input_file
  end

  def process_markdown(:help) do
    IO.puts """
      usage: ezpdf [path to input file]
      """
  end
  def process_markdown([input_path]) do
    case File.read(Path.expand(input_path)) do
      {:ok, data} -> Earmark.as_html(data)
      {:error, msg} -> IO.puts :stderr, :file.format_error(msg)
    end
  end
  def process_markdown([]) do
    IO.read(:stdio, :all)
    |> Earmark.as_html
  end

  def process_pdf({:ok, html, _}) do
    Enum.join([header_html(), html, footer_html()])
    |> PdfGenerator.generate_binary(page_size: "Letter", shell_params: ["--print-media-type", "--page-size", "Letter", "--dpi", "150", "--zoom", "3", "--margin-top", "8", "--margin-right", "8", "--margin-bottom", "8", "--margin-left", "8"])
  end

  def output_pdf({:ok, pdf_content}) do
    Path.expand(Application.get_env(:ezpdf, "output") || "output.pdf")
    |> File.write(pdf_content)
  end

  defp header_html do
    case File.read(Path.expand("#{Application.get_env(:ezpdf, "header")}")) do
      {:ok, data} -> data
      {:error, msg} -> 
        IO.puts :stderr, :file.format_error(msg)
      _ -> "<!DOCTYPE html>\n<html>\n<head></head>\n<body>"
    end
  end

  defp footer_html do
    case File.read(Path.expand("#{Application.get_env(:ezpdf, "footer")}")) do
      {:ok, data} -> data
      _ -> "</body></html>"
    end
  end
end
