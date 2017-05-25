defmodule CliTest do
  use ExUnit.Case
  doctest EZPDF.CLI

  import EZPDF.CLI, only: [parse_args: 1]

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

  describe "process_input/1" do
    test "it takes STDIN if no input file is provided" do
    end

    test "it reads data from a provided input file" do
    end
  end
end
