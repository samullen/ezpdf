defmodule ConfigTest do
  use ExUnit.Case

  import EZPDF.Config, only: [
    parse_args: 1, 
    parse_config: 1, 
  ]

  describe "parse_args/1" do
    test ":help returned by option parsing with -h and --help options" do
      assert parse_args(["-h", "anything"]) == :help
      assert parse_args(["--help", "anything"]) == :help
    end

    test ":header returned when passed the -H or --header options" do
      assert {[header: "anything"], [], []} = parse_args(["-H", "anything"])
      assert {[header: "anything"], [], []} = parse_args(["--header", "anything"])
    end

    test ":footer returned when passed the -F or --footer options" do
      assert {[footer: "anything"], [], []} = parse_args(["-F", "anything"])
      assert {[footer: "anything"], [], []} = parse_args(["--footer", "anything"])
    end

    test ":output returned when passed the -o or --output options" do
      assert {[output: "anything"], [], []} = parse_args(["-o", "anything"])
      assert {[output: "anything"], [], []} = parse_args(["--output", "anything"])
    end

    test ":input returned for non-option arguments" do
      assert {[], ["example.md"], []} = parse_args(~w{example.md})
    end
  end

  describe "parse_config/1" do
    test "returns :help if receives :help" do
      assert :help = parse_config(:help)
    end
    # {args, input_file, _} = args_options

    test "returns the [] if no input file is provided" do
      assert [] = parse_config({[], [], []}) 
    end

    test "returns the [filepath] if input file is provided" do
      assert ["/path/to/file.text"] = parse_config({[], ["/path/to/file.text"], []}) 
    end

    test "it sets the 'header' Application.env to the arg passed" do
      parse_config({[header: "header.html"], [], []}) 
      assert Application.get_env(:ezpdf, "header") == "header.html"
      Application.delete_env(:ezpdf, "header")
    end
    test "it sets the 'header' Application.env to the config" do
      parse_config({[], [], []}) 
      assert Application.get_env(:ezpdf, "header") == "./test/fixtures/files/header.html"
      Application.delete_env(:ezpdf, "header")
    end

    test "it sets the 'footer' Application.env to the arg passed" do
      parse_config({[footer: "footer.html"], [], []}) 
      assert Application.get_env(:ezpdf, "footer") == "footer.html"
      Application.delete_env(:ezpdf, "footer")
    end
    test "it sets the 'footer' Application.env to the config" do
      parse_config({[], [], []}) 
      assert Application.get_env(:ezpdf, "footer") == "./test/fixtures/files/footer.html"
      Application.delete_env(:ezpdf, "footer")
    end

    test "it sets the 'output' Application.env to the arg passed" do
      parse_config({[output: "output.html"], [], []}) 
      assert Application.get_env(:ezpdf, "output") == "output.html"
      Application.delete_env(:ezpdf, "output")
    end
    test "it sets the 'output' Application.env to the config" do
      parse_config({[], [], []}) 
      assert Application.get_env(:ezpdf, "output") == "./test/fixtures/files/output.html"
      Application.delete_env(:ezpdf, "output")
    end
  end
end
