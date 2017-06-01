defmodule EZPDF.Config do
  def setup(argv) do
    argv
    |> parse_args
    |> parse_config
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

end
