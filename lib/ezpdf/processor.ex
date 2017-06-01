defmodule EZPDF.Processor do
  def process(input_path) do
    input_path
    |> process_markdown
    |> process_pdf
    |> output_pdf
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
